## Dependency

### What is dependency processing?

One would presume that once we have constructed our parse tree,
resulting in a `Module` object, that we could just walk it and emit code
form there. Such a technique is known as a single pass compiler as a
*single pass* over the source code comprised of tokens is performed and
during this grammar checking, type checking, code generation and lastly
code emitting is done. This technique results in a quicker execution
time but also makes the implementation bloated as all logic must be in
one file to support each stage. There are also other disbenefits:

1.  Symbol definitions
    -   Doing a single pass means you haven't stored all symbols in the
        program yet, hence resolution of some will fail unless you do
        some sort of over-complicated lookahead to find them - cache
        them - and then retry. In general it makes all sort of
        defintiion processing more painful.
    -   A multi-pass solution means we have all the symbols defined and
        then we can walk over each component and actually ensure the
        symbols being referred to exist and are defined in the right
        order
2.  Dependencies
    -   Some instructions must be generated which do not have a
        syntactical mapping. I.e. the static initialization of a class
        doesn't have a parser/AST node equivalent. Therefore our
        multi-stage system of parserot-to-dependency coversions allows
        us to convert all AST nodes to dependency nodes and add extra
        dependency nodes (such as `ClassStaticInit`) into the dependency
        tree despite them having no AST equivalent.
    -   Splitting this up also let's us more easily, once again, about
        symbols that are defined but reauire static initializations, and
        looping structures which must be resolved and can easily be done
        if we know all symbols (we just walk the AST tree)

*And the list goes on...*

Hopefully now one understands as to why a multi-pass compiler is both
easier to write (as the code is more modular) and easier to reason about
in terms symbol resolution. It is for this reason that a lot of the code
you see in the dependency processor looks like a duplicate of the parser
processor but in reality it's doing something different - it's generated
the actual executable atoms that must be typechecked and have code
generated for - taking into account looping structures and so forth.

> The dependency processor adds execution to the AST tree and the
> ability to reason about visited nodes and "already-initted" structures

### What gets accomplished?

There are a few main important factors that the dependency processing
and creation process provides us:

1.  Declaration ordering
    -   If a variable is referred to before it is declared then we have
        no way of checking this in an AST-only way (i.e. via the
        parser).
    -   The `DNode` type wraps these AST-nodes in a way that lets us
        mark them as visited hence a use-before-declare situation is
        easy to detect and report to the end-user
2.  Tree of execution
    -   When the dependency tree is fully created it can be "linearized"
        or left-hand leaf visited whereby eahc leaf-left node is
        appended into an array.
    -   This array then provides us a list of `DNode`s we walk through
        in the typechecker and can effectively generate instructions
        from and perform typechecking
    -   It's an easy to walk through "process - typecheck - code gen".
3.  Non-AST equivalents
    -   There is no equivalent AST node that represents a "static
        allocation" - that is something derived from the AST tree,
        therefore we need a list of **concrete** "instructions" which
        precisely tell the code generator what to do - this is one of
        those cases where a AST tree wouldn't help us - or we we would
        effectively have to implement this all in the parser which leads
        to overly complex parser.

### API

#### The `DNode`

The `DNode` (short for ***d**ependency **node***) is an object which
wraps the following methods and fields within it:

1.  `this(Statement statement)`
    -   The constructor of a DNode takes in a `Statement` that it is
        intended to wrap around - since it is all about `Statement`s we
        create dependencies from
2.  `getEntity()`
    -   Returns the `Statement` this dependency node wraps
3.  `isVisited()`
    -   Returns `true` if this dependency node has been visited before.
        See `markVisted()`
4.  `markVisited()`
    -   Mark this node as visited
5.  `isCompleted()`
    -   Returns `true` if this dependency node has been marked as
        completed. See `markCompleted()`.
6.  `markCompleted()`
    -   Marks this noe as completed.
    -   This is normally used as an alternative to `markVisited()` when
        all nodes have already been visited but a second run through is
        needed, therefore a second visitation state is required. See
        `tree()`.
7.  `DNode[] dependencies`
    -   The current `DNode`'s array of depenencies which themselves are
        `DNode`s
8.  `performLinearization()`
    -   Performs the linearization process on the dependency tree,
        visited all children knows in a depth-first-search
        left-visitation stratergy.
    -   This method is to only be called once, calling it again will
        raise a `DependencyException`
9.  `getLinearizedNodes()`
    -   Returns the `DNode[]` array of linearized nodes
    -   This method may be called numerous times but must be preceded by
        a call to `performLinearization()`, failing to do so will raise
        a `DependencyException`
10. `getTree()`
    -   Returns a `string` containing the string representation of the
        dependency tree.
    -   This method may be called numerous times but must be preceded by
        a call to `performLinearization()`, failing to do so will raise
        a `DependencyException`
11. `needs(DNode)`
    -   This adds the given `DNode` as a dependency to the current
        DNode, effectively appending it to the `dependencies` array.

![](/graphs/pandocplot390552161348119324.svg)

#### The `DNodeGenerator`

The DNodeGenerator is used to generate dependency node objects
(`DNode`s) based on the current state of the type checker. It will use
the type checker's facilities to lookup the `Module` that is contained
within and use this container-based entity to traverse the entire parse
tree of the container and process each different possible type of
`Statement` found within, step-by-step generating a dependency node for
each and attacching them to the relative parent dependency node - at the
end resulting with athe final dependency tree.

This type provides the following methods:

1.  `generate()`
    -   This is the method that starts the dependency tree generation,
        resulting in the return of a single `DNode` (which may have
        multiple dependencies and so on) at the end of processing
2.  `pool(Statement e)`
    -   Pools the given parse node `e`, returning a `DNode` wrapper for
        it
    -   Creates a new `DNode` if no such mapping exists, else returns
        the same `DNode`

TODO: Discuss the `DNodeGenerator`

### Pooling

Pooling is the technique of mapping a given parse node, let's say some
kind-of `Statement`, to the same `DNode` everytime and if no mapping
exists then creating a `DNode` for the respective parse node once off
and then returning that same dependency node on successive requests.
This means that the same object reference to the created `DNode` is
returned on each successive call. This mapping of sorts is how we get a
consistent dependency node handle on the various parse nodes we
encounter when doing dependency processing.

This is important because visitation marking is used in order to know if
a certain parse node has been processed but because `Statement` (parse
nodes) do not have such functionality whilst dependency nodes **do**, we
therefore need to map a given parse node to the same exact (by memory
reference) dependency node each time, and then check the visitation
status of said `DNode` during processing.

#### Example pooling

Below we have an example of what this process looks like. In this case
we would have done something akin to the following. Our scenario is that
we have some sort of parse node, let's assume it was a `Variable` parse
node which would represent a variable declaration.

![](/graphs/pandocplot11037938885968638614.svg)

------------------------------------------------------------------------

What we have done in the code below is extracted our parse node
`varPNode`, pooled it in order to retrieve a `DNode` dependency node for
it and then confirmed that the `varDNode.entity` is equal to that of the
`varPNode` itself. Furthermore we then pool the same parse node again
(`varPNode`) in order to show the returned dependency node will be the
same as that referenced by `varDNode`.

``` {.d .numberLines}
Variable varPNode = <... fetch node>;

DNode varDNode = pool(varPNode);
assert(varDNode.getEntity() == varPNode);

DNode varDNode2 = pool(varPNode);
assert(varDNode == varDNode2);
```

TODO: Add dependency generation notes here

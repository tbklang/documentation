## Meta

There are quite a lot of aspects one may want to be able to support in a modern language and many of these have to do with manipulating the original source code itself. However, text transformations on source code can only go so far - what one really wants is the ability to manipulate the AST tree that was _parsed_ from said source code.

This is where the meta section comes in. There is not one single component for this but rather several mechanisms at hand that, when combined correctly, allow one to perform all sorts of transformations.

TODO: `sizet` etc.
    These types will need to be handled somehow, probably in `getType()` in the type checker

### Meta API

There are some core interfaces which various `Statement`(s) (parser nodes) can implement in order to be able to be manipulated by the meta-processor, we describe these in this section. These are all defined in `source/tlang/compiler/symbols/mcro.d`.

#### the `MStatementSearchable`

Anything which implements this has the ability to search for objects of the provided type, and return a list of them.

|   Method name            | Return type   | Description                                                                           |
|--------------------------|---------------|---------------------------------------------------------------------------------------|
| `search(
TypeInfo_Class
)`   | `Statement[]` | Searches for all objects of the given type and returns an array of them. Only if the given type is equal to or sub-of `Statement` |

Sometimes one needs to be able to find all AST nodes of a given type, for example, I may have an `Expression` AST node such as:

```
1 + 2 + func()
```

And maybe I would like to find all AST nodes _therein_ that are type-compatible with the `IntegerLiteral` type - meaning I would be able to extract all the integer literals present in that expression, namely $1$ and $2$. Let's take a look at this example in code:

```d
// This is our main expression `1 + 2 + func()`
Expression exp = ...

// Cast to `MStatementSearchable` and only work
// if it supports it
if(cast(MStatementSearchable)exp)
{
    MStatementSearchable mss_exp = cast(MStatementSearchable)exp;
    Statement[] s = mss_exp.search(IntegerLiteral.classinfo);
    writeln(s);
}
```

The output of `writeln(s)` would be, if all the AST types we care about (and intermediay ones) implement `MStatementSearchable`, something like:

```
[Integerliteral [val: 1], Integerliteral [val: 2]]
```

#### the `MStatementReplaceable`

Anything which implements this has the ability to replace a given statement within itself with another statement.

Obviously this barrs one from replacing the statement `this` itself, in such a case attempt replacement via the parent (i.e. `this.parentOf()`).

|   Method name                   | Return type   | Description                                                                                     |
|---------------------------------|---------------|-------------------------------------------------------------------------------------------------|
| `replace(
    Statement,
    Statement)`  | `bool`        | Replace a given `Statement` (the first argument) with another `Statement` (the second argument), returns `true` if the replacement is successful, `false` otherwise |

A real example from the source code is how the dependency generator replaces occurences of the `FunctionCall` AST node `sizeof(...)` with an `IntegerLiteral` containing some numeric number. The idea is that `sizeof(ubyte)` should be replaced with an `IntegerLiteral` containing the number $1$ (the number of bytes of the `ubyte` type).

The implementation of this starts of with a `FunctionCall` node called `funcCall` and we then obtain the name of the function being called with `funcCall.getName()`, we do this to ensure that we are observing `sizeof(...)`:

```d
FunctionCall funcCall = cast(FunctionCall)exp;
string funcCall_n = funcCall.getName();

// store the parent of `funcCall`
Container funcCall_p = funcCall.parentOf();

/** 
 * In the case we have a function named
 * `sizeof()` then we want to replace
 * it in place with a different expression
 */
if(funcCall_n == "sizeof")
{
    ...
```

Now let's first create the AST node that I want to put in place of where the `sizeof(...)` `FunctionCall` AST node is currently:

```d
IntegerLiteral li = determineSizeOfLiteral(this.tc, n);
```

Next we want to do two things:

1. Set `li`'s parent to `funcCall`'s parent
    * This is to make it "act" the same
2. Place `li` exactly where `funcCall` was _in_ `funcCall`'s parent
    * This is pretty self-explanatory

```d
// Set to use the same parent as `funcCall`
li.parentTo(funcCall_p);

// Replace `funcCall` in `funcCall_p` with `li`
auto funcCall_p_cl = cast(MStatementReplaceable)funcCall_p;
funcCall_p_cl.replace(funcCall, li);
```

We have now performed the replacement.

#### the `MTypeRewritable`

TODO: Description

|   Method name      | Return type   |     Description                             |
|--------------------|---------------|---------------------------------------------|
| `getType()`        | `string`      | Gets this entity's type                     |
| `setType(string)`  | `void`        | Sets this entity's type to the provided one |

TODO: Add an example of it being used here please

#### the `MCloneable`

Anything which implements this should be able to make a full deep clone of itself and then also, optionally, allow a new parent to be set.

|   Method name    | Return type  |     Description                             |
|------------------|--------------|---------------------------------------------|
| `clone()`        | `Statement`  | Returns the deeply cloned `Statement`       |

TODO: Add an example of it being used here please


### the `MetaProcessor`

The `MetaProcessor` is the actual processing facility which can apply different types of AST manipulations to a given `Container`. It is run prior to type checking but after parsing. This makes sense as we want to do AST node manipulation _just_ after the parse tree has been constructed, then we can pass the changed program to the `TypeChecker` and it wouldn't know any different. For all the type checker knows, this is just the original program.

|   Method name                         | Return type  |     Description                                                                  |
|---------------------------------------|--------------|----------------------------------------------------------------------------------|
| `process(Container)`                  | `void`       | Processes the various types of meta statements in the provided `Container`       |
| `doTypeAlias(
    Container,
    Statement)`   | `void`       | Performs the replacement of type aliases such as `size_t`, `ssize_t`             |
| `typeRewrite(
    MTypeRewritable)`        | `void`       | Updates any type fields in `TypedEntity`s (these are the only ones really implementing the `MTypeRewritable` interface)       |
| `getConcreteType(
    string)`             | `string`     | Given an assumed type alias this will try resolve it to its concrete type        |
| `isTypeAlias(string)`                 | `bool`       | Given an assumed type alias this checks if it is a type alias                    |
| `isSystemType(string)`                | `bool`       | Checks if the given type is a system alias (so, is it `size_t`/`ssize_t`)        |
| `getSystemType(string)`               | `string`     | Resolves `size_t`/`ssize_t` to their concrete types using the `CompilerConfig`   |

### AST processing

The `process(Container)` method is the entry point to the whole meta-processor engine and it is called by the `TypeChecker`
by passing in the parsed `Module` instance such that the meta-proessing and AST manipulation can be applied to the entire
program tree.

This method is recursive in that what it first does is apply the AST manipulations, that you will see in the next sectiom,
to each body `Statement` of the current container. Right at the end after all these manipulations have taken place we then
check if the current `Statement` is a kind-of `Container`, if so then we recurse by calling `process(childContainer)` on
the child container. Therefore reaching the depths of the AST tree.

#### Type alias replacement

The first step which is applied is to replace all type aliases with their concrete values. This is accomplished
by calling the `doTypeAlias(Container, Statement)` method from the current container with the `Statement` we have
iterated to.

This does two checks:

1. Is the current statement `MTypeRewritable`-compatible?
    * If so then it means that the statement is some sort of `TypedEntity` which has a type field
    * This field is then updated by calling `setType(string)` with the new concrete type
2. Is the current statement `MStatementSearchable` and `MStatementReplaceable`?
    * This means that the statement can be **searched** and have parts of it **replaced**
    * A search is normally done via the `Container`, however, for any AST node of type `IdentExpression`
    * We search for `IdentExpression` because, for example if you have `1+sizeof(size_t)`, then the identity expression (named variable) would be that of `size_t` within the argument to `sizeof(...)`.
    * We can then replace the `IdentExpression` there with one referring to the concrete type
    * The concrete type is retrieved by calling `getConcreteType(string)` (with `"size_t"` in this case)

#### Macro replacement

To support macros such as `sizeof(<type>)` we need to be able to find where they occur and then, no matter how deep in the AST tree, replace
them with some other node (in this example an `IntegerLiteral`) which makes sense. We make heavy use of the `MStatementSearchable` (for **searching**) and the `MStatementReplaceable` (for **replacing**) interfaces as part of this process.

The method of replacement is to examine the current `Statement` being iterated on in the call to `process(Container)`, we then check the following things:

1. Is the current statement both `MStatementSearchable` and `MStatementReplaceable` compatible?
2. **If so**, search for all `FunctionCall` AST nodes
3. Of all the `FunctionCall` AST node(s) found:
    * If the name of the function being called is `sizeof`?
    * If their is only a single argument passed to said function call?
    * If the argument passed is an `IdentExpression`?
4. **If the above are all true**, then we proceed to do:
    * Extract the `IdentExpression`'s name field
    * Pass this to `sizeOf_Literalize(string)`
    * Now replace this `IdentExpression` with the `IntegerLiteral` returned by `sizeOf_Literalize(string)`

The replacement is done from the current container, and we pass it the `FunctionCall` (the `sizeof<type>`) we found as the first argument (what to search for) and then the second argument is our newly created `IntegerLiteral` which is what will replace the spot that `FunctionCall` occupies in the AST tree.
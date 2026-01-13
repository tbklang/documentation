## Type lookups

The mechanism by which someone queries for a *type object* (i.e. a
`Type`) by providing a *string query* of the type’s name, is a system
which begins in the type checker’s `getType` function (shown below).

``` d
public Type getType(Container c, string typeString)
{
        ...
}
```

If you have already read about how the *resolver* works then you won’t
find the implementation of this method much too complicated, it’s really
a simple lookup rooted at the starting container `c` for a *entity*
named `typeString`. There are a few gotchas here and their pertaining to
type aliases and built-in types.

Before we begin let’s look at the rule for the type lookup:

1.  Try find a built-in type
    - Call `getBuiltInType(this, c, typeString)` to see if a built-in
      type can be found
2.  Try find an *entity*
    - Try find an `Entity` AST node that has the name `typeString`
    - If found, it is also then checked to see if it is a kind-of
      `Type`. We do this to ensure the entity referenced is an actual
      type and not the name of, for example, a variable
3.  If the *entity* found in step **2** is a *type alias*
    - Check to see if it is a kind-of `TypeAlias`, if so store it in
      `ta`
    - Then call `getType(ta.parentOf(), ta.getReferentType())` and
      recurse

Note, that we need not worry about cycles in step **3** because they are
impossible when we get to this point as the dependency generator has
already performed use-before-declare checks on the `TypeAlias` objects
it encounters and if one occurred an error would have been thrown
earlier on.

### Builtin types

The module `tlang.compiler.symbols.typing.builtins` contains a method
for resolving built-in types:

    public Type getBuiltInType(TypeChecker tc, Container container, string typeString)
    {
        ...
    }

This contains a relatively simple lookup-table-like mechanism for
mapping from the `typeString` to some concrete `Type`. Effectively what
we have is a bunch of if-statements for handling this:

    /* `int`, signed (2-complement) */
    if(cmp(typeString, "int") == 0)
    {
        return new Integer("int", 4, true);
    }
    /* `uint` unsigned */
    else if(cmp(typeString, "uint") == 0)
    {
        return new Integer("uint", 4, false);
    }

    ...

In the case that no *built-in type* can be found for `typeString` then
`null` is returned.

#### How the system types `size_t` and `ssize_t` work

There is a special check within this module for these two types. They
cannot, as one may think, be implemented as a standard *type alias*
(using `TypeAlias`) because what they map to is only determinable based
on context that is not within the T language itself but rather something
the compiler implementation can determine.

That is - *“What is this systems largest word size?”*

The first check is to see whether `typeString` refers to one of these
*system types*:

``` d
/* `size_t` and `ssize_t` system types */
else if(isSystemType(typeString))
{
    ...
}
```

If that is the case we then get the corresponding *system type* for
`typeString`. We also pass in the compiler’s configuration as that helps
determine what these types should resolve to. From this we obtai a new
type string, `ts_rmp`:

``` d
// map it (`size_t`/`ssize_t`) to a typeString
// containing a concrete type
string ts_rmp = getSystemType(tc.getConfig(), typeString);
```

We then resolve `ts_rmp` via `getType(...)` and then return that:

``` d
// recurse with concrete type
return getBuiltInType(tc, container, ts_rmp);
```

TODO: We should move the stack-array checks, pointer checks etc. -
**out** of here and into `getType()` as there isn’t much “built-in”
about those.

TODO: Add a section on this TODO: Talk about builtins TODO: Talk about
pointer type resolution (this should maybe be done in `getType()` rather
as there isn’t much “built-in” about this)

### User-defined types

### Tying it all together

Bringing together what we know about both *built-in types* and
*user-defined types* we can now take a look at the implementation of
`getType(Container, string)`:

\`\`\`{d. .numberLines}

\`\`\`

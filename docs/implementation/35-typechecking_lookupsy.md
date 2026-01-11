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

TODO: Add a section on this TODO: Talk about builtins TODO: Talk about
pointer type resolution (this should maybe be done in `getType()` rather
as there isn’t much “built-in” about this)

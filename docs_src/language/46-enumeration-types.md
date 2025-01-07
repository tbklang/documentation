Enumeration types
=================

Enumeration types allow one to associate a set of compile-time constants with a named set. For
example we could declare an enumeration type named `Numberless` and give it two members as follows:

```{.d}
enum Numberless
{
	ONE,
	TWO
}
```

Each of these members will evaluate to an ordinal value of the enumeration type's member-type. The
member-type of an enumeration-type _without_ any value-assignments (we will get to those later) is
that of `int`. This implies then that `ONE` will eveluate to $0$ and `TWO` will
evaluate to $1$.

Below is an example of the usage within a function:

```{.d .numberLines}
int answer()
{
    return Numberless.ONE + Numberless.TWO;
}
```

When `answer()` is called it will return a result of $1$ (as $0+1$).

### Explicit member typing

The default member-type of an enumeration type is that of an `int` (when there are _no_ value-assignment).
This, however, can be changed by using an explicit type declaration when declaring your enumeration type.

In this case I have chosen to declare `Numberless` with an explicit member-type, a `long`:

```{.d}
enum Numberless : long
{
    ONE,
    TWO
}
```

### Explicitly assigned values

The ordinal values of any enumeration types are automatically filled in for supported types.
For example if we have an enumeraiton type like so:

```{.d}
enum Numberless : long
{
    ONE,
    TWO
}
```

Then the value of `Numberless.ONE` will be $0$ and `Numberless.TWO$ will be $1$. This is a useful
default behavior however sometimes we want to specify such numbers ourselves, and in the case of
this enumeration type `Numberless` - it may make more sense to do the following:

```{.d}
enum Numberless : long
{
    ONE = 1,
    TWO = 2
}
```

Now `Numberless.ONE` will be $1$ and `Numberless.TWO` will be $2$.


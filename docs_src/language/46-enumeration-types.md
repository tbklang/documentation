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

---

In the case that omit the value for one of the enum members, like so:

```{.d}
enum Numberless : long
{
    ONE = 1,
    TWO
}
```

Then the value of `Numberless.ONE` will be $1$ and that of `Numberless.TWO`
will be $0$, this is because members _without_ explicit values are filled from
their member-type's smallest value upwards (0 upwards) and only using values
that are not already assigned.

#### String enumerations

We also support string enumerations. This is something that can be rather useful
if you perhaps have several messages you want to store and re-use at a later stage
_but_ want to have an easy-to-remember name associated with.

Here is an example:

```{.d}
enum Message
{
    WELCOME = "Welcome to my app!",
    EXIT = "Shutting down..."
}
```

This is the only case were a non-integral typed value (`ubyte*` in this case as it
is a string literal) can be used as the enum's member type. This does, however, mean
that we can do things like this:

```{.d}
int main()
{
    return Message.WELCOME[0];
}
```

This would return $127$ - the ASCII value of the character `W`.
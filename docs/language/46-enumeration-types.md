# Enumeration types

Enumeration types allow one to associate a set of compile-time constants
with a named set. For example we could declare an enumeration type named
`Numberless` and give it two members as follows:

``` d
enum Numberless
{
    ONE,
    TWO
}
```

Each of these members will evaluate to an ordinal value of the
enumeration type’s member-type. The member-type of an enumeration-type
*without* any value-assignments (we will get to those later) is that of
`int` (TODO: double check). This implies then that `ONE` will eveluate
to $0$ and `TWO` will evaluate to $1$.

Below is an example of the usage within a function:

``` d
int answer()
{
    return Numberless.ONE + Numberless.TWO;
}
```

When `answer()` is called it will return a result of $1$ (as $0+1$).

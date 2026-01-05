## Aliases

Aliases allow one to map an expression to a name such that that expression can be re-used
across the source code just by referencing the alias's name.

Here I define an alias named `doIt` to have the expression `doubler(i)` bound to it:

```d
alias doIt = doubler(i);
```

Now whenever I reference the alias `doIt` (in any place where an expression may be used)
it will be replaced _in-place_ by `doubler(i)`. Therefore the following code:

```d
int main()
{
    int i = 2;

    return doIt;
}
```

Transforms into:

```d
int main()
{
    int i = 2;

    return doubler(i);
}
```

Whether or not this compiles depends on whether the now-transformed code is correct.
In our case it would not compile if a function named `doubler(int)` was not defined,
hence I defined it in the full file as:

```d
module usage_capture;

alias doIt = doubler(i);

int doubler(int i)
{
    return i*2;
}

int main()
{
    int i = 2;

    return doIt;
}
```
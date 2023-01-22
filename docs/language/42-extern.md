## External symbols

Some times it is required that a symbol be processed at a later stage that is not within the T compiler's symbol procvessing stage but rather at the linking stage. This is known as late-binding at link time where such symbols are only resolved then which can help one link their T program to some symbol in an ELF file (linked in with extra `gcc` arguments to `DGen`) or in a C standard library autpmatically included in the DGen's emitted C code.

In order to use such a feature one can make use of the `extern` keyword which us specify either a function's signature or variable that should be resolved during C compilation time **but** such that we can still use it in our T program with typechecking and all.

### External functions

To declare an external function use the `extern efunc ...` clause followed by a function's signature. Below we have an example of the `write` function from glibc being specified:

```{.d .numberLines}
extern efunc uint write(uint fd, ubyte* buffer, uint count);
```

We can now go ahead and use this function as a call such as with:

```{.d .numberLines}
extern efunc uint write(uint fd, ubyte* buffer, uint count);

void test()
{
    ubyte* buff;
    discard write(cast(uint)0, buff, cast(uint)1001);
}
```

### External variables

To declare en external variable use the `extern evar ...` clause followed by the variable declaration (type and name). Below we have an example (TODO: finish me)

```{.d .numberLines}
extern evar int myExternal;
```
## External symbols

Some times it is required that a symbol be processed at a later stage
that is not within the T compiler's symbol procvessing stage but rather
at the linking stage. This is known as late-binding at link time where
such symbols are only resolved then which can help one link their T
program to some symbol in an ELF file (linked in with extra `gcc`
arguments to `DGen`) or in a C standard library autpmatically included
in the DGen's emitted C code.

In order to use such a feature one can make use of the `extern` keyword
which us specify either a function's signature or variable that should
be resolved during C compilation time **but** such that we can still use
it in our T program with typechecking and all.

One could take a C program such as the following:

``` {.c .numberLines}
#include<unistd.h>

int ctr = 2;

unsigned int doWrite(unsigned int fd, unsigned char* buffer, unsigned int count)
{
    write(fd, buffer, count+ctr);
}
```

and then compile it to an on object file named `file_io.o` with the
following command:

``` {.bash .numberLines}
gcc source/tlang/testing/file_io.c -c -o file_io.o
```

And then link this with your T program using the command (take note of
the flag `-ll file_io.o` which specifies the object to link in):

``` {.bash .numberLines}
./tlang compile source/tlang/testing/simple_extern.t \
        -sm HASHMAPPER \
        -et true \
        -pg true \
        -ll file_io.o \
```

### External functions

To declare an external function use the `extern efunc ...` clause
followed by a function's signature. Below we have an example of the
`doWrite` function from our C program (seen earlier) being specified:

``` {.d .numberLines}
extern efunc uint doWrite(uint fd, ubyte* buffer, uint count);
```

We can now go ahead and use this function as a call such as with:

``` {.d .numberLines}
extern efunc uint write(uint fd, ubyte* buffer, uint count);

void test()
{
    ctr = ctr + 1;

    ubyte* buff;
    discard doWrite(cast(uint)0, buff, cast(uint)1001);
}
```

### External variables

To declare en external variable use the `extern evar ...` clause
followed by the variable declaration (type and name). Below we have an
example of the `ctr` variable from our C program seen earlier being
specified:

``` {.d .numberLines}
extern evar int ctr;
```

We have the same program as before where we then refer to it with:

``` {.d .numberLines}
...
extern evar int ctr;

void test()
{
    ctr = ctr + 1;

    ...
}
```

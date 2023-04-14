## Pointers

Pointers are just like any other variable one would declare but what is important is that
their values can be used in certain operations. A pointer's value is an address of another
variable and one can use a pointer to indirectly refer to such a variable and indirectly
fetch or update its value.

A pointer type is written in the form of `<type>*`, for example one may write `int*` which
is read as "a pointer to an `int`".

TODO: All pointers are 64-bit values - the size of addresses on one's system.

### Usage

Here we shall show you the use cases of pointers in the below example:

```d linenums="1"
int value = 69;
```

Firstly, we declare a new variable named `value`, now when a program runs on a computer these variable _"names"_ become addresses. So effectively what we have so far is some "address", that if we visit it now has the value of 69 assigned to it. With this sort of understanding, what follows will be easy to understand.

```d linenums="1" hl_lines="2"
int value = 69;
int* valuePtr = &value;
```

What we have ==here== is the declaration of a variable called `valuePtr` of type `int*`, meaning this variable is going to hold an address which points to an integer. What follows is the assignment of the value `&value` to our variable `valuePtr`. The `&` operator returns the address of our variable.

Resulting in us having another "variable" (our `valuePtr`) or address which, if we visit it we get another value which is _intended_ to be interpreted as another address as well - it is **this** address that if we visit we fetch the value of 69.

### Example code

Below is example usage of a pointer:

```d
module simple_pointer;

int j;

int function(int* ptr)
{
    *ptr = 2+2;
    return (*ptr)+1*2;
}

int thing()
{
    int discardExpr = function(&j);
    int** l;

    return discardExpr;
}
```

We can also cast pointers to smaller pointer types and use this technique to be able to address sub-sections of bigger data units.
```d
module simple_pointer_cast_le;

int j;

int ret()
{
    return 0;
}

int function(int* ptr)
{
    byte* bytePtr = cast(byte*)ptr;
    *bytePtr = 2+2;
    *(bytePtr+1) = 1;
    
    return (*ptr)+1*2;
}

int thing()
{
    int discardExpr = function(&j);
    int** l;

    return discardExpr;
}
```

Here we have a slightly modified version of the above code and we update the second-last significant byte (this code is written for little-endian x86) of the integer referred to by `ptr` to `1`. This means our number held in `j` - the variable pointed to be `ptr` - should (TODO: we can explain the memory here) become the result of `256+4` (that is `260`). After this we then return that number with two added to it.
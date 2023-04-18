## Pointers

Pointers are just like any other variable one would declare but what is important is that
their values can be used in certain operations. A pointer's value is an address of another
variable and one can use a pointer to indirectly refer to such a variable and indirectly
fetch or update its value.

A pointer type is written in the form of `<type>*`, for example one may write `int*` which
is read as "a pointer to an `int`".

TODO: All pointers are 64-bit values - the size of addresses on one's system.

### Pointer syntax

There are a few operators that can be used on pointers which are shown below, most specific of which are the `*` and `&` unary operators:

| Operator | Description | Example|
|----------|-------------|--------|
| `&`      | Gets the address of the identifier | `int* myVarPtr = &myVar`   |
| `*`      | Gets the value at the address held in the referred identifier | `int myVarVal = *myVarPtr` |

Below we will declare a module-level global variable `j` of type `int` and then use a function to indirectly update its value by the use of a pointer to this integer - in other words an `int*`:

```{.d numberLines=1}
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

We have a function declared called `function` which takes in an `int*` named `ptr`. This can hold the address of memory that points to an `int`. We then have a function called `thing` which will call the former function with the argument `&j` which means it is passing a pointer to the `j` variable in.

```{.d numberLines=1}
int function(int* ptr)
{
    *ptr = 2+2;
    return (*ptr)+1*2;
}
```

What `int function(int* ptr)` does is two things:

1. The first line, `*ptr = 2+2`, means that we will update the variable that is pointed to by the address stored in `ptr` to `2+2` (so `4`)
2. The second line, `return (*ptr)+1*2`, means a few things:
    1. The `*ptr` fetches the value pointed to by the address stored in `ptr`, so it would be `4` as of calling this
    2. The `+1*2` will add `2` to the value of `4`
    3. Lastly we return this value; `6`

#### Casting and arithmetic

Some of the existing operators such as those used for arithmetic have special usage when used on pointers:

| Operator | Description | Example|
|----------|-------------|--------|
| `+`      | Allows one to offset the pointer by a `+ offset*sizeof(ptrType)` | `ptr+1` |
| `-`      | Allows one to offset the pointer by a `- offset*sizeof(ptrType)` | `ptr-1` |

Below we show how one can use pointer arithmetic and the casting of pointers to work on sub-sections of data referenced to by a pointer:

```{.d linenums="1" hl_lines="12-14"}
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

What we first do over here in `int function(int* ptr)` is to cast our pointer `ptr` from an `int*` to a `byte*`, this means that we now can access the 4 byte integer byte-by-byte, on x86 we would be starting with the least-significant byte. What we have done here is updated said byte to the value of `2+2`:

```{.d linenums="1"}
byte* bytePtr = cast(byte*)ptr;
*bytePtr = 2+2;
```

We now apply pointer arithmetic to our `bytePtr` by adding `1` to it which would increment the address by `1`, resultingly pointing to the second least significant byte, we then use the dereference operator `*` to set this byte to `1`:

```{.d linenums="1"}
*(bytePtr+1) = 1;

```

This means our number held in `j` - the variable pointed to be `ptr` - should (TODO: we can explain the memory here) become the result of `256+4` (that is `260`). After this we then return that number with two added to it:

```{.d linenums="1"}
return (*ptr)+1*2;
```

#### Mixing and matching

One can even mix these if they want, for example we can do the following:

```{.d numberLines=1}
module simple_stack_arrays3;

void function()
{
    int[][22222] myArray;

    int[2][2] myArray2;

    int i = 2;
    myArray[i][i] = 69;
}
```

TODO: Describe that here we have a staxck array of integer arrays or integer pointers

NOTE: This appears before the array syntax, this should probaly be changed around

### Array syntax

**TODO:** Mention the `[<expr>]` syntax

**NOTE:** We can only work on this once the arrays branch is done and has been tested with the new pointers code
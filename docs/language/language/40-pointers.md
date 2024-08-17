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
| `*`      | Sets the value at the address held in the referred identifier | `*myVarPtr = 81` |

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
module complex_stack_array_coerce;

int val1;
int val2;

void coerce(int** in)
{
    in[0][0] = 69;
    in[1][0] = 420;
}

int function()
{
    int[][2] stackArr;
    stackArr[0] = &val1;
    stackArr[1] = &val2;
    
    discard coerce(stackArr);

    return val1+val2;
}
```

First let's take a look at what we have in `int function()`. Here we have declared an array of type `int[][2]` called `stackArr`, this means a stack array with two elements of type `int[]` (or `int*`). We then proceed to store two elements into this stack array, a pointer to the integer variable `val1` and `val2` respectively.

NOTE: This appears before the array syntax, this should probably be changed around

### Array syntax

One can also use the familiar array syntax to work with pointers, in fact the syntax `<compType>*` (for declaring a pointer to data of type `<compType>`) can also be written as `<compType>[]`, a similar syntax table exists whereby instead of using `*` we use the `[<offset>]` operator:

| Operator | Description | Example|
|----------|-------------|--------|
| `[<offset>]`      | Gets the value at the address held in the referred identifier | `int myVarVal = myVarPtr[0]` |
| `[<offset>]`      | Sets the value at the address held in the referred identifier | `myVarPtr[0] = 81` |

```{.d numberLines="1"}
module simple_stack_array_coerce;

void coerce(int* in)
{
    in[0] = 69;
    in[1] = 420;
}

int function()
{
    int[2] stackArr;
    discard coerce(stackArr);

    return stackArr[0]+stackArr[1];
}
```

What we have above is a program that has a function defined as `coerce(int* in)`, we have an `int*` as the parameter and as you can see instead of accessing the first and second items pointed to by `in` using the syntax `*(in+0)` and `*(in+1)` respectively, we have rather used `in[0]` and `in[1]` to the same effect.
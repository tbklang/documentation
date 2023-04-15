## Arrays

Arrays allow us to have one name refer to multiple instances of the same type. Think of an array like having multiple variables
of the same type tightly packed next to one-another but being able to refer to this group by a _single name_ and _each instance_ by a number - an _"offset"_ so to speak.

### Stack arrays

Stack arrays are what we refer to when we allocate an array (i.e. multiple instances of the same type next to each other) using the stack space of the current stack frame (the space for the current function call).

```{.d numberLines=1 hl_lines="5"}
module simple_stack_arrays4;

int function()
{
    int[22222] myArray;

    int i = 2;
    myArray[i] = 60;
    myArray[2] = myArray[i]+1;

    return myArray[2];
}
```

What we have above is a declaration of an array of `int` with 22222-many instances packed next to each other. We can then make use of the stack array by referring to its name and an index as we have done below:

```{.d}
myArray[i] = 60;
```

Here we are updating the `i`-th element of the array to the value of `60`.

```{.d}
myArray[2] = myArray[i]+1;
```

We can also later refer to the value of the array at that index again if we want to, perhaps, use it as part of an expression. What we have done here is to update the element at index `2` (the third element) of the array with the result of the `i`-th element of the array with `1` added to it.

#### Coercion

If one passes in a stack-based array to a function (TODO: finish this)

TODO: Add code example here

### Pointer arrays

Pointer arrays are just a way to use the array syntax, such as the `[<index>]` on pointers rather than the native pointer syntax, for this please see the next section on [pointers](39-pointers.md).

The _"unnumbered"_ (lacking a number between then `[]`) array syntax is the equivalent of declaring a pointer to the component type.

```{.d numberLines=1}
module simple_arrays4;

void function()
{
    int[] myArray;
    int i = 2;
    myArray[i] = myArray[1]+2;
}
```

The above program is equivalent to (TODO: do this and ensure equivalency in actual code **even though** the above compiles)

TODO: Add this

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
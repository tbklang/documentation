## Arrays

Arrays allow us to have one name refer to multiple instances of the same type. Think of an array like having multiple variables
of the same type tightly packed next to one-another but being able to refer to this group by a _single name_ and _each instance_ by a number - an _"offset"_ so to speak.

### Usage

#### Stack arrays

Stack arrays are what we refer to when we allocate an array (i.e. multiple instances of the same type next to each other) using the stack space of the current stack frame (the space for the current function call).

```{.d numberLines=1}
module simple_stack_arrays2;

void function()
{
    int[22222] myArray;

    int i = 2;
    myArray[i] = 1;
}
```

TODO: Add this

#### Pointer arrays

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
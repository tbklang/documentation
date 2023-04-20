## Arrays

Arrays allow us to have one name refer to multiple instances of the same
type. Think of an array like having multiple variables of the same type
tightly packed next to one-another but being able to refer to this group
by a *single name* and *each instance* by a number - an *“offset”* so to
speak.

### Stack arrays

Stack arrays are what we refer to when we allocate an array
(i.e. multiple instances of the same type next to each other) using the
stack space of the current stack frame (the space for the current
function call).

``` d
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

What we have above is a declaration of an array of `int` with 22222-many
instances packed next to each other. We can then make use of the stack
array by referring to its name and an index as we have done below:

``` d
myArray[i] = 60;
```

Here we are updating the `i`-th element of the array to the value of
`60`.

``` d
myArray[2] = myArray[i]+1;
```

We can also later refer to the value of the array at that index again if
we want to, perhaps, use it as part of an expression. What we have done
here is to update the element at index `2` (the third element) of the
array with the result of the `i`-th element of the array with `1` added
to it.

#### Coercion

If one passes in a stack-based array of type `<compType>[10]` to a
function with a paremeter type of `<compType>*` then type coercion will
occur and the address of the base of the stack array will be passed to
the function.

``` d
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

What we have above is an example of coercion occuring. We have stack
array named `stackArray` of type `int[2]`, we then pass it into a
function call `coerce(stackArray)`, therefore because it is defined as
`void coerce(int*)` and the type of the array is `int[2]` the component
types both match and the base address of the stack array is sent in as
an `int*` to the `coerce` function.

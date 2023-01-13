## Pointers

Pointers allow one to get the address of a named entity, store it, and use
it in a manner to either update the value at said address or fetch
the value from said address in an indirect manner.

### Pointer types

A pointer type is written in the form of `<type>*` where this is read as "a pointer-to <type>". The `<type>` is anything before the last asterisk. Therefore `<type>**` is a "a pointer-to < a pointer-to <type>>".

One also gets untyped pointers, these are written as `void*`.

All pointers are 64-bit values - the size of addresses on one's system.

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

    return 0;
}

int thing()
{
    int discardExpr = function(&j);
    int** l;
}
```
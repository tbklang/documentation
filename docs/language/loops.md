Loops
=====

Loops are structures which allow one to run code a repeated number of times based on a condition. The currently supported looping structures in TLang are:

1. `while` loops

## `while` loops

One can declare a while loop using the `while` keyword followed by a condition (an expression) as follows:

```d
int i = 5;
while(i)
{
    // Put some code here
    
    i = i - 1;
}
```
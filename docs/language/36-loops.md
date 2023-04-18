## Loops

Loops are structures which allow one to run code a repeated number of
times based on a condition. The currently supported looping structures
in TLang are:

1.  `while` loops

### `while` loops

One can declare a while loop using the `while` keyword followed by a
condition (an expression) as follows:

``` d
int i = 5;
while(i)
{
    // Put some code here
    
    i = i - 1;
}
```

### `for` loops

One can declare a for loop using the `for` keyword. A for loop consists
of 4 parts:

1.  A pre-run statement
    -   This is run once before the loop begins
2.  A condition
    -   Checked before starting the next iteration
3.  The body
    -   The code in-between the `{` and `}`
4.  A post-iteration statement
    -   Run at the end of each iteration

!!! info Currently it is required that your provide 1, 2 and 4 or else
the program will not compile (see
[variations](http://deavmi.assigned.network/git/tlang/tlang/issues/79))

An example for loop is as follows:

``` d
int i = 0;
for(int idx = i; idx < i; idx=idx+1)
{
    i = i + 1;

    for(int idxInner = idx; idxInner < idx; idxInner = idxInner +1)
    {

    }
}
```

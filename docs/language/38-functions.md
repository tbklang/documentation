## Functions

A function has three things:

1.  A *body* of code to execute
2.  Optional *input parameters*
3.  An optional *return type* and respective *return value*

### Void functions

A function of type `void` does not return anything. An example would be:

``` d
void sayHello()
{
    print("Hello there\n");
}
```

Trying to use a `return` in a void function such as the following would
result in an error:

``` d
void sayHello()
{
    return 1;
}
```

### Typed functions

A typed function has a *return type* and can return a value of said
type, here we have such an example of a function defined to return a
value of type `int`:

``` d
int myFunction()
{
    return 2;
}
```

### Parameters

Functions can take in parameters of the form
*`<type> arg1, <type> arg2, ...`*, below is an example of such a
function which takes to integral parameters and returns the sum:

``` d
int sum(int a, int b)
{
    return a+b;
}
```

Calling such a function is accomplished as such:

``` d
sum(2,1)
```

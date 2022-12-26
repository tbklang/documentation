Functions
=========

A function has three things:

1. A _body_ of code to execute
2. Optional _input parameters_
3. An optional _return type_ and respective _return value_

## Void functions

A function of type `void` does not return anything. An example would be:

```d
void sayHello()
{
    print("Hello there\n");
}
```

Trying to use a `return` in a void function such as the following would result in an error:

```d
void sayHello()
{
    return 1;
}
```

## Typed functions

A typed function has a _return type_ and can return a value of said type, here we have such an example of a function defined to return a value of type `int`:

```d
int myFunction()
{
    return 2;
}
```

## Parameters

Functions can take in parameters of the form _`<type> arg1, <type> arg2, ...`_, below is an example of such a function which takes to integral parameters and returns the sum:

```d
int sum(int a, int b)
{
    return a+b;
}
```

Calling such a function is accomplished as such:

```d
sum(2,1)
```

!!! warning
    Calling a  function like this is not yet supported. It must be in an expression, hence one can do `discard sum(2,1)` for now till we have direct function calls implemented. See issue #71.
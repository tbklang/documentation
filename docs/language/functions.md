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
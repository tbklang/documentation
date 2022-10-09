Modules
=======

A module is the top-level container for all T programs, it is the parent of all other syntactical components.

## Declaration

A module is defined using the `module` keyword followed by the name of the module:

```d
module myModule;

// Code goes here
```

## Naming

Because the module is the root of all other containers such as classes and structs, one can always use the module name to refer from the top-down. An example:

```d
module myModule;

class A
{
    static int b;
}

// This is the same
int value1 = A.b;

// As this
int value2 = myModule.A.b;
```
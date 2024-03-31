## Modules

A module is the top-level container for all T programs, it is the parent of all other syntactical components.

### Declaration

A module is defined using the `module` keyword followed by the name of the module:

```d
module myModule;

// Code goes here
```

You would then save this into a file named `myModule.t`.

> Note, that if your module's declared name does not match the filename there will not be an immediate error. **However**, this is because the default value for the configuration option `"modman:strict_headers"` is set to `false` - this will change in the future

### Naming

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

### Usage

TODO: Add usage example here
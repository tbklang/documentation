## OOP

T supports object-oriented programming out of the box, specifically
support for classes (with single inheritance) and interfaces.

### Classes

Single inheritance classes are supported in T and a basic class
definition for a class named `A` looks as follows:

``` d
class A
{
    // Code goes here
}
```

#### Constructors

A constructor for our class `A` is defined with a function named after
the class, so in this case that would be `A` as shown below:

``` d
class A
{
    A()
    {
        
    }
}
```

#### Destructors

Like a constructors, destructors follow the same syntax. However,
destructors have the tilde symbol, `~`, infront of them like so:

``` d
class A
{
    ~A()
    {
        
    }
}
```

Destructors run when you use the `delete` keyword on an object
reference.

------------------------------------------------------------------------

#### Inheritance

Classes in T support single inheritance using the `:` operator. Below we
have a base class **A** and a sub-class **B**. The syntax is as follows:

Class **A**:

``` d
class A
{
    
}
```

Class **B** (which inherits from **A**):

``` d
class B : A
{
    
}
```

### Interfaces

TODO: Add seciton on interfaces TODO: Also add support for this to TLang

``` d
interface A
{

}
```

### Polymorhipsm

TODO: Add notes on type-casting here and RTTI

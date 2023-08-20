## Naming

TODO: Insert things here about collision detection etc. (TODO: yeah,
later)

Once we have finish parsing we will effectively have a relationship
present between the AST nodes. The outermost `Container`-based node, the
*module* has a list of children AST nodes in it. This is in the form of
a `Statement[]`, one can imagine that you could loop through this array
to find a particular AST node of interest. These *statements* will be of
various different types, some will also implement the `Container`
interface, think of a class declared within a module, *that’s a a
container **in** another container*, meaning one could recurse down it.

Where does naming come into this whole picture though? That’s where we
look at the the `Entity`-type of AST nodes. These are effectively any
sort of *statement* which has a **name** associated with it. If we
combine the aforementioned recursive nature of traversing the AST tree
with name matching we can effectievly build a name-based lookup system
such that given any name we can look it up.

TODO: Add diagram in moleskin here

### The resolver

After we have parsed the tokens into a `Module`, this is passed to a new
instance of the `TypeChecker` (which you will read about next) but prior
to starting that process a new `Resolver` is created which takes in the
`TypeChecker` so it can access the `Module`. It then has the ability to
use this to do its resolution.

Before we get into how it all works let’s first see the API offered to
us by the resolver (in `source/`):

| Method name                                               | Return type | Description                                                                                                                                                                                                                             |
|-----------------------------------------------------------|-------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `generateNameBest(     Entity)`                           | `string`    | Given an `Entity` this will return the absolute path to it                                                                                                                                                                              |
| `generateName(     Container,     Entity)`                | `string`    | Returns the path of the `Entity` relative to the `Container`                                                                                                                                                                            |
| `isDescendant(     Container,     Entity)`                | `bool`      | Checks if the given `Entity` can be found *somewhere* within the provided `Container`                                                                                                                                                   |
| `resolveWithin(     Container,     string)`               | `Entity`    | Looksup an `Entity` with the given name from within the provided `Container`, does **not** recurse                                                                                                                                      |
| `resolveUp(     Container,     string)`                   | `Entity`    | Looksup an `Entity` with the name provided, starting from the `Container` given but it may resolve upwards past it if it isn’t found within it                                                                                          |
| `resolveBest(     Container,     string)`                 | `Entity`    | Combines the above two to resolution all the way down but also, if given an anchor `Container` and not found it can then trickle upwards till it is found                                                                               |
| `findContainerOfType(     TypeInfo_Class,     Statement)` | `Container` | Given a type-of `Container` and a `Statement` this will try find a container that the provided statement apears in by traversing upwards through any nested containers and stopping at the one which **exactly** matches the given type |

#### How resolution works

Let’s start off with an example program of which we can attempt to show
the resolution process:

``` d
module example_1;

int myVar;

class MyClass
{
    int myVar;
}
```

Once we have parsed the above program we would be able to use various
methods such as `resolveWithin(Container, string)`,
`resolveUp(Container, string)` and `resolveBest(Container, string)`.
After parsing we get a `Module` object so we can make use of this if we
see fit, we can, however, also lookup other containers *within* this
module and use that as a lookup anhor for some of the methods.

Let’s try and resolve the class declared with the name `MyClass`. For
this we can use `resolveWithin` and pass it the `Module` instance to
tell it to look for some entity named `"My Entity"`. One thing to note
is that this method only checks members of the given `Container` and not
the container itself (so you cannot lookup the `Module` itself via this
method, as an example). Anyways, in this case the container is the
*module* and the entity, `MyClass`, is within it:

``` d
// Get our resolver
Resolver res = typeChecker.getResolver();

// Get out module
Module anchor = typeChecker.getModule();

// Resolve the class
Entity foundEntity = res.resolveWithin(anchor, "MyClass");

// If found
if(foundEntity !is null)
{
    Clazz myClass = cast(Clazz)foundEntity;

    // Do whatever you want with the Clazz
    // ...
}
```

When an entity is not found then `null` is returned as the indicator,
hence prior to casting to the correct kind-of type we want I first do a
null check.

------------------------------------------------------------------------

What if we want to now lookup the `myVar` within the `MyClass` class but
we don’t don’t want to have to effectively find the direct parent of
each AST node being looked up, but rather just want to give a
dotted-path (pathdot-identifier) which describes how to reach it? Well,
that’s very easy, we can use `resolveBest(Container, string)` in order
to do that. We will anchor the lookup at the `Module` instance and
provide it the path of `"example_1.MyClass.myVar"`.

``` d
// Get our resolver
Resolver res = typeChecker.getResolver();

// Get out module
Module anchor = typeChecker.getModule();

// Resolve the class
Entity foundEntity - res.resolveBest(anchor, "example_1.MyClass.myVar");

// If found
if(foundEntity !is null)
{
    Clazz myClass = cast(Clazz)foundEntity;

    // Do whatever you want with the Clazz
    // ...
}
```

It should be noted that if you have a path start with the name of a
module then it will *always* actually anchor to the module, so even if
we did `resolveBest(foundEntity, "example_1.MyClass.myVar")` it would
start at the module anyways.

#### Nearest parent of a given type

There are few places in the compiler’s source code, in fact only one
actually as of writing, whereby one requires to lookup the `Container`
somewhere in the anscetor tree of a given AST node. For example, let us
look at the below example (this was the reason this method was actually
created in the first place). The below example can be found in
`source/tlang/testing/simple_function_recursion_factorial.t`:

``` d
module simple_function_recursion_factorial;

ubyte factorial(ubyte i)
{
    if(i == 0)
    {
        return 1;
    }
    else
    {
        return i*factorial(i-1);
    }
}
```

What we have above is a simple recursive function but where the problem
comes in is that when we are doing typechecking on the type of the
expression contained within the `return` expression, the
`return i*factorial(i-1)`, if that we need to find the enclosing
`Function`. Now a function is a kind-of `Container` however we cannot
simply do something akin to:

``` d
// Our return expression
ReturnExpr retExp = ....

// Parent of return expression
Container retContainer = retExp.parentOf();

// Cast to Function
Function func = cast(Function)retContainer; // ERROR: Runtime type check failure

// Type check the func.getType() and retExp's expression's type
```

The reason for this is that the `else {}` branch is a `Branch`, **also**
a kind-of container and we’d have a runtime type check failure when we
do that cast. We need a way to travel up the parenting/container tree
until we hit a a container of a *certain type* - in this case of type
`Function`. This is where the
`findContainerOfType(TypeInfo_Class containerType, Statement startingNode)`
method comes in handy. So now, repeating the above code using this
method we would have something that looks like this:

``` d
// Get the resolver
Resolver res =  typeChecker.getResolver();

// Our return expression
ReturnExpr retExp = ....

// Parent of return expression
Container retContainer = res.findContainerOfType(typeid(Function), retExp)

// Cast to Function
Function func = cast(Function)retContainer; // Works!

// Type check the func.getType() and retExp's expression's type
```

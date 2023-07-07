## Aims

A programming language normally has an aim, a *purpose of existence*, to
put it in a snobbish way that a white male like me would. It can range
from solving a problem in a highly specific domain (such are Domain
Specific Language (TODO: add citation)) to trying to solving various
problems spread across several different domains, a *general purpose*
programming language. This is where I would like to place Tristan - a
language that can support multiple paradigms of programming - whether
this be object-oriented programming with the usage of *classes* and
*objects* or functional programming with techniques such as map and
filter.

Tristan aims to be able to support all of these but with certain limits,
this is after all mainly an imperative language with those paradigms as
*“extra features”*. Avoiding feature creep in other systems-levels
languages such as C++ is something I really want to stress about the
design of this language, I do not want a big and confusing mess that has
an extremely steep learning curve and way too many moving parts.

### Paradigms

Tristan is a procedural programming language that supports
object-oriented programming and templates.

#### Object-oriented programming

Object orientation allows the programmer to create user-defined types
which encapsulate both data fields and methods which act upon said data.
Tristan supports:

1.  Class-based object orientation
    - Classes as the base of user-defined types and objects are
      instances of these types
    - Single inheritance hierachy
    - Runtime polymorhpism
2.  Interfaces
    - Multiple inheritance
    - Runtime polomprhism (thinking\hyperref{})

It is with this lean approach to object orientation that we keep things
simple enough (only single inheritance) but with enough power to model
the real world in code (by supporting interfaces).

### Templating

Templating, otherwise known as *generics*, is a mechanism by which a
given body of code which contains a type specifier such as variable
declarations or function definitions can have their said type specifiers
parameterized. The usage of this can be illustrated in the code below,
where we want to define a method `sum(a, b)` which returns the summation
of the two inputs. We define version that works for integral types
(`int`) and a version that works for decimal types (`float`):

``` d
// Integral summation function
int sum(int a, int b)
{
    return a+b;
}

// Decimal summation function
float sum(float a, float b)
{
    return a+b;
}
```

Being a small example we can reason about the easiness of simply
defining two versions of the `sum(a, b)` method for the two types, but
after some time this can either get overly repetitive if we have to do
this for more methods of a similar structure or when more types are
involved. This is where templating comes in, we can write a more general
version of the same function and let the compiler generate the
differently typed versions dependent on what *type parameter* we pass
in.

A templatised version of the above `sum(a, b)` function is shown below:

``` d
// Templatised function
template T
{
    T sum(T a, T b)
    {
        return a+b;
    }
}

// Integral version
sum!(int)(1,2)

// Decimal version
sum!(float)(1.0,2.0)
```

The way this works is that whenever you call the function `sum(a, b)`
you will have to provide it with the specific type you want generated
for that function.

### Systems-level access

Tristan does not shy away from features which give you access to
system-level concepts such as memory addresses (via pointers), assembly
(via the inline assembler) and so on. Such features are inherently
unsafe but it is this sort of control that I wish to give the user, the
balance between what the compiler should do and what the user should
make sure they are doing is tipped quite heavily in favor of the latter
in my viewpoint and hence we support such features as:

- Weak typing
  - By default this is not the behavior when using `cast()`
  - Casting to an incompatible type is allowed - even when a run-time
    type-check is invalid you can still force a cast with `castunsafe()`
  - The user should be able to do what *he* wants if requested
- Pointers
  - The mere *support* of pointers allowing one to take a memory-level
    view of objects in memory rather than the normal “safe access” means
- Inline assembly
  - Inserting of arbitrary assembler is allowed, providing the
    programmer with access to systems level registers,
    interrupts/syscall instructions and so on
- Custom byte-packing
  - Allowing the user to deviate from the normal struct packing
    structure in favor of a tweaked packing technique
  - Custom packing on a system that doesn’t agree with the alignment of
    your data **is** allowed but the default is to pack accordingly to
    the respective platform

### Specified behaviour

TODO: Insert ramblings here about underspecified behaviour and how they
plague C and how we easily fix this in tlang

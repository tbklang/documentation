---
title: "Adding support for `static` to parser"
date: 2021-06-06
author: Tristan B. Kildaire
tags: [typechecking, parser, static, oop, grandresolution]
---

# Adding support for `static` to parser

This article deals with things mentioned in [Type checking: The hard part begins](../typechecking_hard_part_begins)

## Basics

I am now working on adding support for the `static` keyword to the parser. For this however I have decided the following.

1. `static` must come _after_ an accessor such as `public`, `private`, `protected`
2. `static` only applies to things inside of classes
    * What is means is if something:
        * **Is** `static` then it will be initialized (expression evaluated) by the class on it's reference
        * **Is NOT** `static` then it will be initialized (expression evaluated) by the object of said class when that **object** is initialized

As for the semantics on class references, that will be decided when I get to implementing this for the type-checker (which might be soon seeing that is fixes the visitation tree and later dependancies for the grand paths like `x.h.j` (where `x` is a class, `h` is a member of `x` and also a class and `j` is a member of `h`))
3. Classes, structs and variables therefore can all be made `static`
4. The rules of course also imply a `static` entity can only be accessed from the container-type _and_ object as it is global data readyily-available
    * However, a non-static entity cannot be accessed in this way as finding which class instance or _object_ it belongs to (if _any_) would be ambiguous
5. Functions marked as `static` don't have initialization and don't follow the same meaning as in point _2_ **but** they allow access to such data in a manner that is simply an indirection of the point made in _4_ and hence the same rules apply as mentioned in _4_.

## Further notes

### On C's definition of `static`

C has a meaning for `static` that basically means the variable (of address-value pairing) is in the global data section rather than an address calculated off of an offset from the stack-frame base pointer (`%rbp`). For this I will rather add a keyword called `global` as that is _much_ more clearer than having a keyword have multiple meaning per context.
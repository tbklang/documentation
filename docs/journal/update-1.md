---
title: Major update - grind of a week
date: 2021-03-27
tags: [parser]
author: Tristan B. Kildaire
---

# Major update - grind of a week

The title makes no sense.

I have a raging foot fetish.

I have failed no nut november.

There are SSA agents outside my window looking at me whilst I poo.

Date: 27th of March 2021

A summary of the things I have worked on this week.

# Parser

The parser has had **a lot** of updates added to it. Namely I have added the following:

* Class parsing
	* This includes with or without inheritance/impentation (as in expecting the names and comma seperation)
* If statement parsing
	* This inludes with else if and else
* Module header is now required as the first statement

## Data structure generation

For many aspects of the program we represent them as some sort of `Statement`, of which we have sub-classes of
like `Entity` and `TypedEntity` (of which `Function` and `Variable` are kinds-of).

We also put these in a tree, by chainging objects toghether and such. And then all top-level `Statement`s
are put into `Statement[]` in the `Program` object (which should rather be named `Module` probably).

## Accessors

I have added support for `private`, `public` and `protected` keywords.

# Type-checker

I have started work on playing around with the generated program structures.

## Dot-path resolver

One thing I have worked on that started working is for checking if a given identifier exists based on a dot-seperated path (which makes sense when you have
classes and such as you could have a variable named `x` stored in class `clazz` and accessing it from the outside
would require `clazz.x`). A note to make about this is I need to edit the lexer to allow for tokenising those sequences
with dots in them.

So given the path `clazz.x` it will return the `Variable` object `x` within the `Clazz` object, `clazz`. In the case resolution
fails then a `null` reference is returned.

## What's next

A few things going between the parser and type-checker and seeing where their best placement would be. Then I think
actual name checking, expression resolution (for types) and checking that against variable types can begin and we can
get to work on the chunky work. But it will take some time. One thing I also need to do is replace the `expect(type)`
with basically the same code as `expect(identifier)` (once the aforementioned `x.x` lexer addition is added).

The reason for this is given the follow code example:

```
class D
{
	static int a;
}
```

You would agree that the variable `a` would be a valid identifier as `D.a`, perhaps when resolving an expression that
includes it.

You would also agree then that I should be able to declare a variable, say now named `y` of type `P` if I had the below
given code:

```
class D
{
	class P
	{
		
	}
}
```

You would agree then if my variable was at the global level, not within `P` or within `D` that to access the type `P` I would
need to use the path of `D.P` as follows:

```
D.P y;
```

Hence it really follows the same form as `expect(identifier)` then. I shouldn't be attempting to validate what a valid type
is during parsing anyways, only a valid possible form.

However here is something I just thought of. I cannot allow classes to be defined with dots in them or the variable's themselves.

> I guess it's usage v.s. declaration

What I will create is an `expect(IDENT_USAGE)` (which will allow dotted-or-non-dotted) and then `expect(IDENT_DEC)` (which will be
solely non-dotted).
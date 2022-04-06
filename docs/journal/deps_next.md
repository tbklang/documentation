Needing to add path-hopper
==========================

---
title: "Needing to add path-hopper"
date: 2021-08-11
author: Tristan B. Kildaire
tags: [typechecking, dependency, static, oop, tree, paths, grandresolver]
---

## Path hopper

The parser when it sees:

```d
int o = new A().l.p.p;
```

Will see a variable declaration for `o` of type `int` and then an atached _VariableAssignment_ with the expression, `new A().l.p.p` which is actually just 3 expressions. The outer layer is a _BinaryOperatorExpression_, with an _LHS_ of `new A()` and an _RHS_ of `l.p.p`. You might be thinking ae there not more bin-ops? Nope, the lexer returns `l.p.p` as one unit to the parser, it is seen simply as some _Entity_ (an object with a name). It is smart as to when to do this, it knows that a dot must be followed and in the case here we end the first expression with `.` as it was preceded by `new A()` (it's the `()` which set it off). Then the first dot splits this up, however we check backwards each step after encountering a dot, if what follows is not a dot valid for a path, say now a number out of nowhere (as the first character), then we produce tokens `new A()`, `.` and `1a` in an example such as:

```d
new A().13
```

However, if it was:

```d
new A().a12.a
```

Then we'd have the tokens `new A()`, `.`, `a12.`. So this is what we would want out of a lexer such that we can then easily get the proper parsing as such done, making sure
the right _kinds_ (potentially) of entities follow (not yet typechecked).

However, when we do dependency checking we must actually resolve this path (which we alreayd have a tool for, the *grand resolver*). But we must visit each hop, and do a dependency check depending on the type of thing it refers to.

Infact we must do the following:

1. Make sure each entity in the path (as we process each) exists *name-wise*
2. Make sure we init along the way if possible and given the current context
    1. Context implies the `static` or `non-static` nature of what we are accessing (so more of a type-checking thing)
        1. One remark, the way this is built is to only init, so static etc and some sanity chekcing for non-static
        2. Therefore there is no typechecking on this yet, we will do that once the tree is made as that means no look-behinds
        3. Which would be impossible, a lookahead after processing could work however, mmmh, still thinking
    2. Initialization means to init it, add it to the dependency tree
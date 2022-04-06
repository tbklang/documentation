---
title: "Code generation and type checking"
date: 2021-10-28
author: Tristan B. Kildaire
tags: [typechecking, dependency, tree, paths, codegeneration]
---

# Code generation and type checking

## Introduction

I haven't been updating this journal as much as I should be but I promise to change that and hopefully publish weekly updates or updates atleast whenever I have a span of 3 days of coding on the compiler project.

This blog post will aim to give an update on the new additions to the compiler that I have added this week.

## Dependency tree generation

Nothing has changed with regards to the way the dependency tree works or the _Parser Nodes_ (**PNodes**) and how they get mapped or _"pooled"_ (as I call it) to their own unique _Dependency Nodes_ (**DNodes**).

What has been _added_ however to the `dependency.d` file is more parser nodes getting their mapping to their own dependency nodes. Effectively this is a process which has to be done before typechecking or code generation can be done and hence I need to get as many parser nodes mapped into this tree as soon as possible because it means that pieces of code can then actually be processed in the next stage of the compiler.

### New mappings

Some new mappings I have added are in the departement of module-level statements, one of which that has newly been added is the mapping of _standalone assignments_:

```d
/* Support for this has existed already */
int p = 21;

/* Support for the below has been added */
p = 24;
```

This means now that the `Statement` `p = 24;` can now be typechecked and code generated.

## Linearisation, Code gen and type checking

### Linearisation

Having our `DNode` object, specifically the _root DNode_ we can traverse the tree in an acyclic manner. The ability to do so has already been implemented already (it was used for printing the tree in an acyclic manner) _however_ the ability to get a _"linearised tree"_ which walks down the tree in a linear fashion **wasn't**. This has been added now and results in an array `DNode[]` which can then be processed by thew typechecker and code generator (a backend code generator).

### Code generation and type checking

The typechecking aspect has not really been worked on too much for the reason that it's almost the same thing as code generation _or rather_ will use a lot of the code that code generation does as it is done in parallel.

The system I have come up takes the linearaised tree we discussed earlier (the `DNode[]`) and walks through it processing each entity in it. To illustrate how we do this I have provided a code snippet below which we can walk through to make sense of it all and see how it actually would process certain components differently and how it results in what I call a _"code queue"_ at the end which can be used by a frontend to emit platform-specific code.

#### Worked through example

```d
int age = 21;
```

The above snippet would result in a `DNode[]` that looks something like the following:

1. `LiteralExpression (21)`
2. `VariableAssignment`
3. `ModuleVariableDeclaration (age)`

The reason it looks backwards isn't because my compiler is "broken" or something, quite the contrary rather. The reason for this is because in the dependency tree we say that the variable declaration depends on the assignment, which in turn depends on the literal expression. Once this is linearised we can get the self-reliant (doesn't rely on anything but itself) component as the head of this queue.

When we process this however there is some important things to take into account when we do something akin to the bottom (in the compiler's source):

```d
/* Linearise the dependency tree */
DNode[] dnodes = linearDependencyTree(dTreeRoot);

/* Process each DNode */
foreach(DNode dnode; dnodes)
{
    /* Process current DNode */
    codeGenTypeCheck(node);
}
```

The important thing here is well, how do we know what the hell to do with a random `LiteralValue`? We don't do any look aheads so how can we know it will sometime soon and only _possibly_ be related to a variable declration (for all we know it could be used for a function call like `func(21)`). The answer is stacks.

For some `DNode` sub-types we simply leave them on the stack which I call thw `codeQueue`. Now the reason it is also called a _queue_ and even used as such in some cases will become apparent momentarily.

What happens to this `LiteralValue` DNode depends on the following `DNode`s that get processed. They will require some argument and can easily `.pop()` from the stack (even checking its type sometimes and if not related, `.push()`-ing it back back). 


They can then either _"assimilate"_ the instruction which means that a new instruction will be created that _contains **this** popped one_ and then that will be pushed on. The other case is re-ordering. 

The case of a variable declaration with an assignment does both in that order. We push `21` on the stack, leave it there, then we process the variable assignment which `.pop()`s and then consumes and assimilates and pushes back on the stack. When we get to the variable declaration this is where it gets interesting. We want to obviously have this assignment _somehow_ (in this case_) relate to the variable declaration. To do so we pop it offand see if it has a variable name of ours (for the assignment), if so we then push it back on and push our declaration on.

> I use the word "push" liberally (imagine 3rd wave feminism) because I cannot remmeber now at this darn early hour of the morning what I did but best believe there are push, pop and append (at bottom of stack) - funtions

Sometimes we do a little re-ordering, the reason for this is because we use it as s stack for temporary shananigans, like the `LiteralValue` one, but it myst also be a final queue in order for code generation so we then will finalise new additions to the code queue (say now another variable declaration) that will always append.

Effectively I am trying to say I use a _super-positioned queue-stack_.

If we declared say now an `int f`, we must `.append()` it. If we `.push()`'d it then we would have incorrect order. Where `f` is declared before `p` and that makes no sense. Trust me it makes sense when you see the code.

---

As for the type checking aspect of things I think it will end up taking a much similiar method of what we have done with the code queue and will be done in parallel with it (to save on time and code).

I will be posting more information on the typechecking system once I actually start implementing it as so far I have only been focussing on the code generation part.

## Weighting

A new feature I have added is known as _"weighting"_ and basically provides any object of type `Statement` or a sub-class to have a _weight_ attached to them which is used to order the statements of a program given the source code. Below is an example:

The following code below:

```d
int j = 1;
j = 2;

class F
{

}
```

Will be re-ordered to the below:

```d
class F
{

}

int j = 1;
j = 2;
```

Now this re-ordering had existed before but only for some sub-types of `Statement` objects, but now this **more general** system means it can be implemented on any source code entity.

The weighting system means we assign a number to each type of `Statement`, and in this case all classes have a weight of `0` and variable declarations and assignments have one of `2`. The `.getStatments()` method of the `Program` class returns a `Statement[]` array based on the ascending re-ordering of the original source-code-ordered `Statement[]` array.

---

The new weighting additions also mean that these two are equivalent:

```d
int p = 21;

p = 24;
```

and...

```d
p = 24;

int p = 21;
```

This is because I want them to be weighted the same (as in not be re-ordered). However, because of how _"pooling"_ and _"node visitation and marking"_ works we can easily report errors such as when the assignment to variable `p`, `p = 24;`, in the second example is incorrect due to the variable not being declared first.
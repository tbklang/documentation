Type checking: The hard part begins
===================================

---
title: "Type checking: The hard part begins"
date: 2021-06-04
tags: [typechecking, dependancies, initialization-order, precedence, oop, typing]
author: Tristan B. Kildaire 
---

Update on this.

I am working on the tree visitation algorithm now. So basically part of type checking to make sure typed entities that use class type reference classes that are able to be declared - getting rid of loops.

It will only really get to that interesting stuff as soon as I do expression type checking.

As then I can have an example like

```
int j = obj.k;

class obj
{
   static int k = j;
}
```

So here the type of the variable j is int, that is fine, no further checking as it is a built-in type (if it was a class type then my code from today applies however I am talking about something different here).

What I should actually be doing here is checking the expression. Then evaluating it and see what it refers to, oh a class, then you type check the class including that static entry which also has an expression and then you have to got back. Now visitation is used for a different case, what I might need here is to rather add an additional atrribute known as `mark` (or ready-to-reference), that should be false here for that variable as we are still parsing the expression, then if we loop back and see that the variable's expression is not ready to reference we error. Technically I need not just a visitatio tree (for a differrent example) but also a r-t-r tree as it can have multiple indirections.

A lot of work but I  have am idea of what to do. Also I do have a precedence thing added. That is preprocessed in the sense that I don't do it whilst type checking I do it before it starts, it will reshuffle entries as classes, functions, variables (at global level) and also within containers such as classes. This means that the whole precedence of initialization is implicit when I am doing (or todo the abive).

----

The visitation thing is a tad different, I think that is only useful for when you are doing type-of-variable checking (which is what I did today - not avriable expression checking).

An example is: 

```
class A
{
	A p;
	B l;
}

class B
{
	A l;
	B p;
}
```

So my type checker will see A, it will start with adding A to visitation tree as, well, it's just been visited, then it looks at A, skips it as it is of the type we are in. Of course there would be other checks here but the next thing then is we go to B, then we visit that class with recursion, however we won't (and I had this before I added visitation) jump back to A here as we check it is visited. Then we do similar for `B p;` in `class B {}`.

1. If there was an error in A before this we exit
2. If there was an error in B (as called from A) then we exit

So we are only ever left with the correct system. Now visitation helps in preventing stackoverflow from _type-check bouncing_ (or mutual recursion _sans le case base_) BUT it also provides something very important. A tree that we can use for codegen and other stuff in terms of HOW things should be initialized. Now I think this isn't a good example but I think the idea might help in expression parsing.

---

Now that I think of it, had I switched these around. Isomorphic really.

But what about:

```
class A
{
	A p;
}

class B
{
	A l;
	B p;
}
```

Well I guess this too is fine, we visit A then visited. Then B, and no checking on A as it is visited already.


So both cases have reverse-initialization path of A->B (this means B inits first then A should). These are bad examples because of there being, no static initializations.

---

Actually I think visitation wont help here. It only helps for checking between things which is needed of course. But it is progress made nontheless.

What I need basically when I go through this is a reliance-tree such that had we declared `class B{}` first and then `class A{}` as so:

```
class B
{
	A l;
	B p;
}

class A
{
	A p;
}
```

Then we get the right init order (visitation doesn't help here - it would return the incorrect visitation order).

What a reliance-tree would look like is basically, regardless of order. You generate who you rely on as a list an attach it to yourself. So both the two last examples would have reliance as follows, `A rel: []`, `B rel: [A]`.

Now if you used the examples where there are mutual declations BUT WITH static initializations then of course that would be problematic, atleast off the top of my head (kinda brainstorming and have uni work so just jotting these down). And reliance tree can help solve that, even with indirection you could use it. So when reliance it good you then mark it as ready to ref, and I think that will make it work easily.

---


So to sum up, reliance is next but requires marking mechanism. This also will only occur for static initialization. Visiataion has been added for getting some of the type checking done correctly (it is needed for all of it to work in a recursive sense).

The other thing I need to add is sorting this out for x.b.c type classes. I have grand resolution which can FIND and RESOLVE such entities however I realise why I ran into a bug earlier with `Them.Container` and my `VTreeNode` - has to do with no visiting those, however I am yet to disntinguish ebtween instance and static methods. SO that is where that would come in and I would be able to sort that out. I think I need to add more for that to work (nor parsing wise, that is done) but in the sense of static stuff.

---

I think I should look into reliance and marking now then and static immediately. As even a static without a expression implies a class (not object) reference and a load then.

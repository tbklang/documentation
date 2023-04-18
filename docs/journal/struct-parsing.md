---
title: Added support for structs to parser
author: Tristan B. Kildaire
date: 2021-05-31
tags: [parser, structs, internals]
---

# Added support for structs to parser

# Struct support

## The parser update

The parser now can parse structs such as:

```
struct structTest
{
    int j;
    int j;

    void pdsjhfjdsf(int j)
    {

    }

    void pdsjhfjdsf(int j)
    {

    }
}

struct structTest2
{

}
```

And if it contains anything but variable declarations or function definitions then it will throw this eror:

```
[ERROR] Only function definitions and variable declarations allowed in struct body
```

If the struct only contains variable declarations or function definitions then everything will work out fine. However, for now, I have forbid the variable declarations to have assignments attached to them as well, if this occurs then you will get the following error:

```
[ERROR] Assignments not allowed in struct body
```

---

## Generated structures

Every pass made through each item in the struct's body returns a `Statement` object which is then checked to see if it is one of the beforementioned objects, is it a kind-of `Function` (function definition in T's D code) or `Variable` (variable declaration), when it is anything else it throws an error. For the `Variable` part we check if `variable.getAssignment()` is not `null`, which means an assignment is present, then we throw an error.

The associated code is from the compiler codebase and is therefore licensed under the GPLv3.

This piece of code already makes sure that only assignments, accessor statements and function definitions would be possible or the closing of the struct:

From line TODO in commit ``

```d
/* If it is a type */
if (symbolType == SymbolType.IDENT_TYPE)
{
    /* Might be a function, might be a variable, or assignment */
    structMember = parseName();
}
/* If it is an accessor */
else if (isAccessor(getCurrentToken()))
{
    structMember = parseAccessor();
}
/* If closing brace then exit */
else if(symbolType == SymbolType.CCURLY)
{
    break;
}
```

We don't have any `else` here because if it were anything else but the above the casting check below would help. We of course need to do the check we do with accessors as:

The following should be legal:

```
struct Test
{
    public int j;
}
```

However, this (also via an accessor) should not be legal:

```
struct Test
{
    public class j
    {

    }
}
```

---

This code is what makes sure that the rules are conformed to actually (the previous code segment was only realy to parse further or catch ther `}` which will be left behind after a `parseBody()` calls within the `parseAccessor()` and `parseName()` calls):

```d
/* Ensure only function declaration or variable declaration */
if(cast(Function)structMember)
{

}
else if(cast(Variable)structMember)
{
    /* Ensure that there is (WIP: for now) no assignment in the variable declaration */
    Variable variableDeclaration = cast(Variable)structMember;

    /* Raise error if an assignment is present */
    if(variableDeclaration.getAssignment())
    {
        expect("Assignments not allowed in struct body");
    }
}
/**
* Anything else that isn't a assignment-less variable declaration
* or a function definition is an error
*/
else
{
    expect("Only function definitions and variable declarations allowed in struct body");
}   
```

---

# First alpha-tester

> Thanks `rany` (BNET), very cool

```d
[16:24:48] <~deavmi> http://[fdd2:cbf2:61bd::2]/projects/t/documentation/examples/
[16:24:49] <botty> Code examples | Tristan Lang
[16:24:52] <~deavmi> check that out rany
[18:02:19] <~deavmi> Working on struct parsing in tlang now
[18:02:22] <~deavmi> almost done
[18:04:27] <rany> i'm gunnaaaaaa 
[18:04:32] <rany> i'll try out tlang soon 
[18:04:38] <rany> T pose
[18:05:58] <rany> * This is TOP SECRET code, not for RELEASE!
[18:05:59] <rany> * Violators WILL BE PUT UP AGAINST A WALL AND
[18:05:59] <rany> * SHOT!
[18:06:11] <rany> deavmi what are you gunna do about it? 
[18:06:30] <rany> how to compile btw
[18:06:33] <~deavmi> rany: 
[18:06:34] <~deavmi> dub
[18:06:36] <~deavmi> dub build
[18:06:39] <rany> thanks
[18:06:41] <~deavmi> install dmd from dlang.org
[18:06:43] <botty> Home - D Programming Language
[18:06:44] <~deavmi> and dub comes with
[18:06:48] <~deavmi> So yeah
[18:06:54] <~deavmi> There are test codes too
[18:06:55] <rany> installing 
[18:07:04] <~deavmi> No codegen or full type checking or dependenayc graph generaiton yet
[18:07:15] <~deavmi> But lexer, parser and some collision detection and path resolution works
[18:07:27] <~deavmi> which is very cool cause atleast then you will be able to see some data structures being generated
[18:07:30] <rany> $ dub build 
[18:07:31] <rany> No package manifest (dub.json or dub.sdl) was found in
[18:07:31] <rany> Please run DUB from the root directory of an existing package, or run
[18:07:31] <rany> "dub init --help" to get information on creating a new package.
[18:07:31] <rany> No valid root package found - aborting.
[18:07:39] <rany> help 
[18:07:40] <rany> deavmi
[18:07:41] <rany> pls
[18:07:41] <~deavmi> mm
[18:07:43] <~deavmi> pwd
[18:07:44] <~deavmi> for me?
[18:07:48] <~deavmi> is that in the root of the repo?
[18:08:00] <rany> yes
[18:08:03] <rany> http://deavmi.assigned.network/projects/tdists/May/a1c6eb9c748fc8836140329f2bc63bd03a282d2a/src/source/tlang/
[18:08:04] <botty> Index of /projects/tdists/May/a1c6eb9c748fc8836140329f2bc63bd03a282d2a/src/source/tlang/
[18:08:12] <~deavmi> mmmh
[18:08:15] <~deavmi> that's weird
[18:08:17] <~deavmi> it shoudl work
[18:08:20] <~deavmi> like it does for me
[18:08:23] <~deavmi> mmm
[18:08:25] <~deavmi> let me try that
[18:08:27] <~deavmi> one moment
[18:09:46] <~deavmi> buidling it over sshfs now
[18:09:49] <~deavmi> on that exact directory
[18:10:10] <~deavmi> do ls for me
[18:10:16] <~deavmi> rany: 
[18:10:34] <rany> $  ls
[18:10:34] <rany> app.d  commandline  compiler  index.html  misc  testing
[18:10:43] <~deavmi> oh wait
[18:10:45] <~deavmi> I am dumbo
[18:10:49] <~deavmi> hold up let me correct the files
[18:10:53] <~deavmi> ah wait
[18:10:54] <~deavmi> no
[18:10:56] <~deavmi> go one dir out
[18:10:58] <~deavmi> src/
[18:11:00] <~deavmi> not src/source
[18:11:01] <~deavmi> then do it
[18:11:51] <rany> deavmi i got it to work 
[18:12:14] <rany> yes i'm in src 
[18:12:37] <~deavmi> nice
[18:12:41] <~deavmi> Well now 
[18:12:42] <rany> oh shit 
[18:12:44] <~deavmi> tlang compile file
[18:12:45] <~deavmi> should work
[18:12:46] <~deavmi> yeah
[18:12:47] <rany> i see deavmi
[18:12:47] <rany> fix that link then 
[18:12:49] <~deavmi> output is verbose as fuck
[18:12:50] <~deavmi> oh
[18:12:51] <~deavmi> will do
[18:12:52] <~deavmi> thanks
[18:13:10] <~deavmi> wait
[18:13:13] <~deavmi> source link is correct though
[18:13:24] <~deavmi> it is only to src/
[18:13:45] <rany> deavmi i was able to build tlang outside of src btw
[18:13:51] <~deavmi> oh
[18:13:51] <~deavmi> nice
[18:14:08] <rany> i did 
[18:14:08] <rany> dub init
[18:14:08] <rany> dub add jcli
[18:14:08] <rany> and then dub build
[18:14:08] <rany> and it worked
[18:14:20] <~deavmi> ah
[18:14:26] <~deavmi> you don;t need to if you did it in the src/
[18:14:29] <~deavmi> as it knows what to fetch then
[18:14:47] <rany> lmao deavmi
[18:14:51] <rany> vasily.jpg 
[18:17:23] <~deavmi> lol
```
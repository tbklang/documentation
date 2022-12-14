---
title: "Code emitting to C has begun!"
date: 2022-12-14
author: Tristan B. Velloza Kildaire
tags: [codeemit]
---

# Code emitting

Work has officially began on the code emitter process in the TLang compiler project and so far the results are pretty promising. It would appear that the two year old code of te lexer, parser, typechecker, dependency generator and code generation are continuing on strong with no bugs (at least not any I can see). I will be cleaning some aspects of those up and filling in the missing parts that are still needed. For example, up until yesterday there was no support in the parser for `return` statements, hence I added it. Small missing things like these are not my biggest worry now but rather the overall picture of how things need to go together. It is for this reason I decided to try implement the code emitter as I wanted to make sure the last stage of the pipeline could work with the last previous stages in a as much decoupled process as possible - _and so far so good!_

## C code emitting

What I am currently busy with now is implementing the `CodeEmitter` class which provides an abstract code emitter API that any emitter (to any language) should implement. Things such as code queue selection, movement back and forth of the cursor etc and emit methods. The more involved process of emitting C-code via the C-backend, `DGen` (which implements the `CodeEmitter` class) has started too! There is a lot of good work happening and **I have gotten some C code generated and to compile as well!**

This process has shown me what is valid in C and what is not too. For example, who would have known that globals definitions such as these are not allowed:

```c
#include<stdio.h>

int h = 1;
h = 2;
```

Well, now I know! I will have to disallow that in TLang or something, but for now will leave it and not write test cases that so such global assignments.

### Example emits

Well, let's see some of the example code emits that are possible!

#### Basic variable assignments

Here we will do some basic **global** variable assignments and also make use of said declared variables in the expressions.

Below is our TLang program that is input:

```d
module simple_variables_decls_ass;


int x = 1+2*2/1-6;

discard "TDOO: Technically also not allowed (not compile-time constant in C)";
int y = 2+x;

discard "TODO: Technically the below should not be allowed as we cannot do it in C - sadly";
y = 5+5;
```

The output C program is:

```c linenums="1" hl_lines="11-12"
/**
 * TLP compiler generated code
 *
 * Module name: simple_variables_decls_ass
 * Output C file: tlangout.c
 *
 * Place any extra information by code
 * generator here
 */
int t_c326f89096616e69e89a3874a4c7f324 = 1+2*2/1-6;
int t_7475a3886e530d59128c250d78d60d80 = 2+t_c326f89096616e69e89a3874a4c7f324;
t_7475a3886e530d59128c250d78d60d80 = 5+5;

int main()
{
    return 0;
}
```

Technically the example T code provided generates semantically incorrect C code **only** because we are doing global variables with non-constant values (see the ==yellow lines==) but the translation is still technically correct - that isn't a hard fix as it would be done at the TLang syntax level not the C emitting level. We simply would  catch it and throw an error before we are even near the emitting stage.

#### Function definitions

This is almost completed, for the most part, there are some outstanding issues (not that you will see in this example) some of which are quick fixes but we can emit function definitions now too. Please to be minded there is always a default emit of an `int main()` function - that's just some boilerplate generation code I added.

Anyways, let's try do code emitting for the following T program:

```d
module simple_function_decls;

int j = 21;
int k = 22;

int apple(int j)
{
    int h = 69;
}

int banana(int j)
{
    int h = 64;
}
```

The following C code is then emitted:

```c
/**
 * TLP compiler generated code
 *
 * Module name: simple_function_decls
 * Output C file: tlangout.c
 *
 * Place any extra information by code
 * generator here
 */
int apple(int j)
{
	int t_200d912625b05745ebf82a9bafcae2fc = 69;
}
int banana(int j)
{
	int t_cfa622ae9657b6beab75dcd872754b06 = 64;
}
int t_a8a8a0e434588979d98f9d8007e37301 = 21;
int t_0c9714cea1ccdfdd0345347c86885620 = 22;

int main()
{
    return 0;
}
```

Which as we can see works as expected.
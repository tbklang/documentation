Parsing begins
==============

---
title: Parsing begins
date: 2021-03-03
tags: [parser]
author: Tristan B. Kildaire
---

I begun working on the parser today, along with minor fixes
and additions to the lexer and some test cases. I started
added symbols to the `token -> symbol` mapper, the actual
parsing hasn't begun just yet but a lot of the plumbing behind
it has. I also added a neat feature for attaching line and
column numbers to the tokens during the lexical analysis stage
(however it doesn't seem to be working).

On `#programming` on BNET on March 3rd 2021:

```
[12:08:56] <~deavmi> I am working on parsing now
[12:09:01] <~deavmi> vv soon gonn start actual parsing
[12:09:05] <~deavmi> just getting symbol types added etc.
[12:13:38] <~deavmi> Damn  the `.t` extension is supported in VS code
[12:13:46] <~deavmi> WHo would know they supproted Tlang so early in development?
[12:16:40] <rnbunker> vscode🤮
[12:16:59] <rany> it's ok rnbunker
[12:17:03] <rnbunker> no
[12:17:09] <rany> he'll see the light eventually
[12:17:31] <~deavmi> Nah
[12:17:36] <~deavmi> I already got that dracula theme
[12:17:38] <~deavmi> I'm not changing
[12:17:39] <~deavmi> XD
[12:18:41] <rnbunker>  e w
[12:18:54] <rnbunker> you could've atleast used VS Codium instead
```

---

On `#BNET` on March 3rd 2021:

Here I was getting some neato-burrito recursive parsing
working so I was very pleased.

```
[16:55:57] <~deavmi> Damn this is going good I must say
[16:56:00] <~deavmi> Making a lot of porgress rn
[16:56:07] <~deavmi> If I keep this up I might be done with parsing VERY soon
[17:05:42] <rnbunker> Poggers
[17:15:56] <~deavmi> Recursive if statement parsing
[17:15:57] <~deavmi> works
[17:15:58] <~deavmi> nice
[17:16:07] <~deavmi> break time :coolcool:
[17:27:50] <~deavmi> I am coooompiling
[17:27:54] <~deavmi> chris9: ^
```

---

### Checklist

So far the following are done for today:

* function call parsing
* recursive if-statements/while parsing
	* So recursive body parsing with `parseBody()`
* expression parsing with arithmetic
	* Later on realised this was broken
* variable declarations
	* with assignment of expressions
	* without assignment

```
[22:07:06] --> muto (muto@Clk-94CCC13F.abhsia.telus.net) has joined #general
[22:14:43] <~deavmi> muto: o/
[22:19:28] <muto> yoyo how's it going?
[22:19:59] <~deavmi> not much man
[22:20:07] <~deavmi> I was wokring on my parser for my compiler earlier muto
[22:20:27] <~deavmi> Made good progress, need to think abput the recursive expression parsing a bit more and think how I did that a few years ago but the recursive body parsing is done
[22:20:31] <~deavmi> So if's within if's work
[22:20:34] <~deavmi> and while's etc
[22:20:51] <~deavmi> Lexer is completely done I think, only additional features like character escape needed
[22:20:53] <~deavmi> So that's good
[22:20:58] <muto> oh dang!
[22:21:16] <muto> That's good stuff
[22:21:29] <~deavmi> Yep
[22:21:29] <~deavmi> :)
[22:21:31] <~deavmi> Thanks
```
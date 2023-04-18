---
title: Why create TLang?
date: 2021-03-02
tags: [parser]
author: Tristan B. Kildaire
---

# Why create TLang?

**Question:** Why create the T programming language? Are there
not already languages out there that do what you want?

Excerpt from `#programming` on [BNET IRC](/projects/bonobonet)
on 2nd of March 2021.

```
[19:08:29] <~deavmi> Lmao
[19:08:36] <~deavmi> I kinda wanna work on my language again
[19:08:41] <~deavmi> before I touch networking projects again
[19:08:46] <~deavmi> Need a break from networkig  projects
[19:08:51] <~deavmi> Kinda wanna just write some recursive shits
[19:08:53] <~deavmi> and parsing
[19:08:54] <~deavmi> mmh yes
[19:09:01] <~deavmi> Need to work on my language's EBNF tho
[19:09:07] <~deavmi> And I haven't done one of those in a long time
[19:09:09] <~deavmi> Wikipedia tyme
[19:32:56] <rnbunker> Just drew a rectangle onto a window
[19:32:58] <rnbunker> I am epic
[19:45:23] <-- icyphox (icyphox@4F9F0E7E.7B04D780.68A4D984.IP) has quit (Read error)
[19:45:38] --> icyphox (icyphox@4F9F0E7E.7B04D780.68A4D984.IP) has joined #programming
[19:54:07] <~deavmi> I'm working on command-line parsing for my compiler project now
[19:54:07] <~deavmi> :)
[19:54:22] -*- deavmi goes to work on tlang...
[19:56:36] <rnbunker> have fun
[19:57:38] <orignal> deavmi in 1995 number of people developing own browser became more that people developing own OS
[19:57:45] <orignal> think about it ))
[20:36:47] <~deavmi> rnbunker: I will
[20:36:54] <~deavmi> orignal: damn
[20:36:56] <~deavmi> that's funny
[20:37:03] <~deavmi> I'd prefer OS dev over web browser dev any
[20:37:39] <~deavmi> So far so good, command-line parsing is basically there
[20:37:52] <~deavmi> Next I need to really define my ebnf but I think I can go ahead with the lexer without that
[20:37:55] <~deavmi> So I will be doing that next
[20:37:55] <~deavmi> :)
[20:38:46] <orignal> so I would suggest to do something more useful ))
[20:41:48] <zhoreeq> operating system in D
[20:42:02] <zhoreeq> because we've had enough of C ones
[20:45:06] <~deavmi> orignal: lmao nah, I want to write a language
[20:45:14] <~deavmi> You're basiclaly suggesting I write a web app then
[20:45:16] <orignal> what for?
[20:45:20] <~deavmi> As that is what is "trending"
[20:45:21] <~deavmi> lmao
[20:45:27] <orignal> who might be intersted in your language
[20:45:28] <orignal> ?
[20:45:30] <~deavmi> orignal: myself
[20:45:35] <~deavmi> I literaly want it to fit my needs
[20:45:47] <~deavmi> <zhoreeq> operating system in D
[20:45:47] <~deavmi> <zhoreeq> because we've had enough of C ones
[20:45:48] <~deavmi> bruh
[20:46:01] <orignal> well what tasks are you going to solve using this language?
[20:46:12] <orignal> and what's with existsing langauges
[20:46:21] <orignal> think scientific way
[20:46:32] <~deavmi> Literally to wirte my own softare in, the problem with current languages is there is nothing that is like C but with classes but without the bloat of D and C++
[20:46:46] <~deavmi> Like with C++ it has generics and templates, with D it does garbage collection and some other things
[20:46:49] <~deavmi> I don't believe they're needed
[20:47:03] <~deavmi> No lean language I can think of does something like C + OOP without bloating it
[20:47:10] <~deavmi> And adding MORE than just OOP
[20:47:12] <~deavmi> That's my thinking orignal
[20:47:16] <~deavmi> [20:46:21] <orignal> think scientific way
[20:47:24] <orignal> Objective-C? )))
[20:48:06] <orignal> scientific way means two things
[20:48:22] <~deavmi> Nah Objective C is aids
[20:48:25] <~deavmi> Theat syntax is bad
[20:48:27] <orignal> the problem you are trying to solve is important
[20:48:32] <orignal> and it's new
[20:48:32] <~deavmi> I believe it is to me
[20:48:36] <orignal> or your way in new
[20:48:36] <~deavmi> It is new to me
[20:48:39] <~deavmi> Yes
[20:48:52] <orignal> new for the world
[20:48:58] <~deavmi> Objective C firstly has a shit syntax. I literally want a boiled down version of D in a way, no templates
[20:49:02] <~deavmi> no gc
[20:49:03] <orignal> you must make sure nobody else did it before
[20:49:05] <~deavmi> but similiar syntax
[20:49:16] <~deavmi> orignal: I am pretty sure nobody has else I woulld have found it by now
[20:49:31] <~deavmi> And I have browseed throughe enough by now to feel nothing like what I quite want exists
[20:49:40] <orignal> I wouldn't be so sure
[20:49:42] <~deavmi> They always fuck up syntaxes and can't just add a simple addition to C
[20:49:49] <~deavmi> orignal: If you can find something be my guess
[20:49:54] <~deavmi> But I haven't stumbled across it uyet
[20:49:56] <~deavmi> * yet
[20:50:06] <orignal> how about Borland Pascal 7 ?))
[20:50:14] <~deavmi> I want to create a debloated C++, slightly modernize some C syntax (but keep it intact for the most)
[20:50:17] <~deavmi> orignal: Pascal?
[20:50:19] <~deavmi> You mean
[20:50:22] <~deavmi> var thing: string = 22;
[20:50:25] <~deavmi> >bruh
[20:50:27] <~deavmi> >pascal syntax
[20:50:31] <~deavmi> Pascal's OOP is shite too
[20:50:38] <orignal> wtype
[20:50:39] <~deavmi> Like the type syntax for it loks utterly trash and confusing
[20:50:43] <orignal> type A = object
[20:50:46] <orignal> begin end
[20:50:49] <~deavmi> Yeah it is 
[20:50:50] <~deavmi> fucntion()
[20:50:54] <~deavmi> variables for loclas
[20:50:55] <~deavmi> begin
[20:50:56] <~deavmi> end;
[20:50:57] <~deavmi> XD
[20:51:02] <~deavmi> >meme language
[20:51:06] <~deavmi> >meme syntax
[20:51:15] <~deavmi> I just want what C++ was meant to be == not retarded
[20:51:19] <~deavmi> anyways
[20:51:22] <~deavmi> back to tokenization!
[20:51:36] <orignal> for example I started doing i2pd
[20:51:45] <orignal> because I found not occupied area
[20:52:06] <orignal> nobody has implemented it properly before ))
[20:53:05] <~deavmi> orignal: That's how I feel about _C with classes_
[20:53:08] <~deavmi> Now you know how I feel
[20:53:11] <~deavmi> ))
[20:53:59] <orignal> C with classes was old C++
[20:54:08] <orignal> C++89 or so
[20:55:35] <~deavmi> Now you see the dilemma
[20:55:50] <~deavmi> Modern C++ uses standard library that relies on its modern feature
[20:55:52] <~deavmi> like generics
[20:55:56] <~deavmi> therefore
[20:56:00] <~deavmi> This will not suit my needs
[20:56:13] <~deavmi> And I don't know who wants to use such an old standard then too
[20:56:21] <~deavmi> w.r.t. wanting updated libs OR external library support
[20:56:22] <~deavmi> with stdlib
[20:59:31] <orignal> look at Borland C++ 3.1 
[20:59:40] <orignal> maybe that's what you are looking for
[21:07:51] <~deavmi> Will take a look
[21:07:56] <~deavmi> Just need to finish this lexer before bed time
[21:07:57] <~deavmi> :)
[21:07:59] <~deavmi> thanks orignal :)
[21:08:02] <~deavmi> Advice is much appreciated
[21:09:15] <orignal> )))
[21:09:31] <orignal> it worked exatcly the way you are looking for
[21:12:42] <~deavmi> But is it actively 
[21:12:44] <~deavmi> maintained
[21:12:52] <~deavmi> and licensed correctly, yeah I know I am getting petty now
[21:12:53] <~deavmi> )))
[21:13:00] <~deavmi> Anyways, my lexer is almost done
[21:13:12] <~deavmi> I just need to think about how I wrote my parser back at uni and then I can get to that
[21:13:18] <~deavmi> But first finish the lexer!
[21:13:18] <~deavmi> :)
[21:14:33] <orignal> it's from 1993 ))
[21:20:17] <~deavmi> Bruh
[21:20:19] <~deavmi> >1993
[21:20:25] <~deavmi> It's that still USSR time
[21:20:32] <~deavmi> Or like 2 yars after fall of USSR?
[21:20:36] <~deavmi> 1991?
[21:22:22] <orignal> no
[21:22:34] <orignal> USSR ended in december 1991
[21:25:18] <rnbunker> lol
[21:26:51] <rany> it ended on paper 
[21:27:01] <rany> but it will live forever in our hearts 
```
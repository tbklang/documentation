Parsing
=======

This chapter aims to describe how the parser works in the T compiler.

## What is _parsing_?

The parser is the first part of the compiler where the structure of the source code becomes apparent to the compiler itself. Up until now we have only been looking at the source code in a way to split it up into symbolic tokens almost like how one can split up the words in an ENglish sentence to know where one ends and another begins, yet there isn't no coherence between the symbols (or in this case of spoken language, the words) as to what they mean either individually or in context of others. It is therefore the job of the parser to build this meaning into a form that we can then process in the next stages of the compiler which need to know what each component is and any of its sub-components (related entities).

## Sections

1. [Tokens I/O](tokens)
    * Understand how the token I/O-subsystem allows retrieval and movement of/between tokens
2. [Structures](structures/)


5. [Weighting](weighting)
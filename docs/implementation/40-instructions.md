## Instruction representation

In this section we will be dicsussing the so-called *intermediate
representation* (or **IR**) which is used for modeling instructions
in-memory. This is of importance because it allows us to both *generate
code* during the type-checking/code-generation process. After this
process is done we have groups of `Instruction[]` arrays available.

Once this process is done there are various use-cases for the available
`Instruction`(s). Here are just a few ideas I have put together to give
you an idea of what could be done with them:

1.  Building a TLang interpreter
    - With the instructions available you could loop through each of
      them and execute them as you go along
    - You would need to implement your own state-management system to
      track declared variables and so forth; but it is definately
      possible.
2.  A code emitter
    - You could build a mechanism which streams in the instructions and
      then produces textual output for each instruction. This textual
      output could be some other language.
    - **This** use case is what we use in the `DGen` module which
      consumes many `Instruction[]`(s) and then emits C code from it;
      after which is then compiled to binaries.

This refers to the in-memory data model that is

![](/projects/tlang/uml/Instruction_in_memory_IR.svg)

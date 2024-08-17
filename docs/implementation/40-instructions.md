## Instruction representation

<!-- ![](/projects/tlang/uml/Instruction_in_memory_IR.svg) -->

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

### Types

[![](/projects/tlang/uml/Instruction_in_memory_IR.svg)](../../uml/Instruction_in_memory_IR.svg)

We need not discuss all of the available instruction types that are out
there, however it is worth dicussing a notable ones.

#### Base class

For anything to be considered a kind-of *instruction* it must inherit
from the `Instruction` class. There is not much to say about this class
other than that (after all the real functionality of an instruction is
unique to the specific type of instruction at hand). However, there are
some important things I do want to mention about this class which are
crucial.

The methods:

| Method               | Returns   | Description                        |
|----------------------|-----------|------------------------------------|
| `getContext()`       | `Context` | Returns this instruction’s context |
| `setContext(Contxt)` | `void`    | Sets this instruction’s context    |

The *context* object (already mentioned by now) is a rather useful
entity to have associated with the instructions. This is because it
gives us, well, *context* that we can use when processing a given
instruction.

An example of where this context is needed is when processing a
`FetchValueVar` instruction. In this instruction we have a `string`
which refers to the name of the entity (i.e. a variable) that needs to
have its associated value fetched. Where the context comes in that
whilst looking up such an entity (with the *resolver*) we would need to
provide an anchor point to search from. This anchor point is in the form
of a `Container` which can, as we already know by now, be retrieved from
the context object via a call to `getContainer()`. This is but just one
of the many examples whereby this context is required.

TODO: Any instruction interfaces (we don’t *yet* have any)

#### Other instructions

There are some other instructions. You can find these in the source tree
at `source/tlang/compiler/codegen/instruction.d`

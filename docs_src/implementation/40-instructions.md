## Instruction representation

In this section we will be dicsussing the so-called _intermediate representation_ (or **IR**)
which is used for modeling instructions in-memory. This is of importance because it allows
us to both _generate code_ during the type-checking/code-generation process. After this process
is done we have groups of `Instruction[]` arrays available.

Once this process is done there are various use-cases for the available `Instruction`(s).
Here are just a few ideas I have put together to give you an idea of what could be done
with them:

1. Building a TLang interpreter
    * With the instructions available you could loop through each
    of them and execute them as you go along
    * You would need to implement your own state-management system
    to track declared variables and so forth; but it is definately
    possible.
2. A code emitter
    * You could build a mechanism which streams in the instructions
    and then produces textual output for each instruction. This
    textual output could be some other language.
    * **This** use case is what we use in the `DGen` module which
    consumes many `Instruction[]`(s) and then emits C code from
    it; after which is then compiled to binaries.

### Types

[![](docs/uml/instructions.svg)](../../uml/instructions.svg)

We need not discuss all of the available instruction types that are out
there, however it is worth dicussing a notable ones.

#### Base class (`Instruction`)

For anything to be considered a kind-of _instruction_ it must inherit
from the `Instruction` class. There is not much to say about this
class other than that (after all the real functionality of an
instruction is unique to the specific type of instruction at hand).
However, there are some important things I do want to mention
about this class which are crucial.

The methods available in this class are:

1. `getContext()`
    * Returns this instruction's context
2. `setContext(Context)`
    * Sets this instruction's context

The _context_ object (already mentioned by now) is a rather useful entity
to have associated with the instructions. This is because it gives us, well,
_context_ that we can use when processing a given instruction.

An example of where this context is needed is when processing a `FetchValueVar`
instruction. In this instruction we have a `string` which refers to the name
of the entity (i.e. a variable) that needs to have its associated value
fetched. Where the context comes in that whilst looking up such an entity
(with the _resolver_) we would need to provide an anchor point to search
from. This anchor point is in the form of a `Container` which can, as
we already know by now, be retrieved from the context object via a call
to `getContainer()`. This is but just one of the many examples whereby this
context is required.

#### Value-based instructions (`Value`)

A `Value` instruction is a kind-of `Instruction` of which represents code
which generates some sort of value, think of literals, arithmetic operations,
pointer dereferences, variable reads and so on. Every such instruction always
has an associated `Type` object associated with it in order to know the
intended type of the instruction. Below we show the API usage of the `Value`
class:

1. `Type getType()`
    * Returns the type associated with this instruction
2. `setType(Type)`
    * Set the type to be associated with this instruction

There are quite a few instructions which sub-type this `Value` class.

#### Other instructions

There are of course a multi-tude of instructions that make up
the whole type hierachy.

A few notable `Value`-based instructions are:

1. `OperatorInstruction`
    * It has a `SymbolType` as a field which holds the intended
    operator
    * This is an abstract class which is a kind-of `Value` instruciton
2. `BinOpInstr`
    * It holds two `Instruction`s, one for the left-hand operand
    and another for the right-hand operand
    * This is a kind-of `OperatorInstruction`
3. `UnaryOpInstr`
    * It holds a single `Instruction` which represents
    the singular operand
    * It is a kind of `OperatorInstruction`

Some other instructions are:

1. `BranchInstruction`
    * This contains an _optional_ `Value`-based instruction
    representing a conditional
    * Along with this it contains a list of _body instructions_
    in the form of an `Instruction[]`
    * By itself it is not all that useful, however, it is
    often used in instructions such as `IfStatementInstruction`,
    `WhileLoopInstruction` and `ForLoopInstruction`
2. `PointerDereferenceAssignmentInstruction`
    * This is represents the assignment of some _value_
    to some entity referenced to by a pointer _value_
    * It contains two `Value`-based instructions, one
    represents the calculation of the pointer and
    another represents that of the value to _assign_
    at the memory address calculated as the pointer

You can find these in the source tree at `source/tlang/compiler/codegen/instruction.d`

### Rendering

When we speak about _render_ or _instruction rendering_ we are referring to
those instructions which implement the `IRenderable` interface found in the
`source/tlang/compiler/codegen/render.d` module.

This is a single-method interface, with the following sole method:

| Method            | Description             |
|-------------------|-------------------------|
| `string render()` | Renders the instruction |

Any instruction which implements this method can have a string representation
of itself generated in such a manner as to visually represent the structure
of the instruction itself.

In order to perform the rendering, a handy function in `render.d` is provided:

| Method                                | Description             |
|---------------------------------------|-------------------------|
| `string tryRender(Instruction instr)` | Renders the instruction |

This function attempts to render the given instruction. If the
instruction supports the `IRenderable` interface then that will
be used, otherwise the name of the instruction will be the fallback.

#### Example render

To make this example explicit we have implemented the `render()` method for
the `BinOpInstr` and `LiteralValue`. We then construct a binary operation
with two operands which are literal values:

```{.numberLines .d}
LiteralValue lhs = new LiteralValue("1", new Type("int"));
LiteralValue rhs = new LiteralValue("2", new Type("int"));
Instruction binOp = new BinOpInstr(lhs, rhs, SymbolType.ADD);
```

After this we can attempt rendering with the `tryRender` function as follows:

```{.numberLines .d}
string s_out = tryRender(binOp);
DEBUG("s_out: ", s_out);
assert(s_out == "1 + 2");
```

The `render()` implementation for binay operations uses `tryRender` on both
of its operands as so: $tryRender(operand_{lhs})\space operator\space tryRender(operand_{rhs})$. In this case those operands, the literal value instructions.
also have implemented `render()`. The latter implemented it in such a manner
so as to simply return the `LiteralValue`'s internal value itself, $1$ and $2$ respectively. 

$$
1 + 2
$$

Finally we end up with the render above.
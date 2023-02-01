## Typechecking and code generation

TODO: Add notes here
TODO: Talk about the queues that exist

### Instructions

#### The base `Instruction`

Every type of instruction that is produced during the code generation phase is a kind-of `Instruction`, it is the base class for all instructions and contains some common methods used by all of them:

1. `setContext(Context)`
    * Sets the `Context` object that is to be associated with this instruction.
    * This is normally done as a way to transfer the context from the respective parser-node to the corresponding instruction such that if such context is needed during further code generation (or even emit) it can then be accessed
2. `Context getContext()`
    * Returns this instruction's associated context via its `Context` object
3. `string produceToStrEnclose(string addInfo)`
    * Returns a string containing the additional info provided through `addInfo`
    * The format of the returned string will be `[Instruction: <className>: <addInfo>]` where `<className>` is the name of the instruction type (kind-of) and `<addInfo>` as explained previously

#### Value-based instructions (`Value`)

TODO: Talk about the `Value` instruction base class here

A `Value` instruction is a kind-of `Instruction` of which represents code which generates some sort of value, think of literals, arithmetic operations, pointer dereferences, variable reads and so on. Every such instruction always has an associated `Type` object associated with it in order to know the intended type of the instruction. Below we show the API usage of the `Value` class:

1. `Type getType()`
    * Returns the type associated with this instruction
2. `setType(Type)`
    * Set the type to be associated with this instruction
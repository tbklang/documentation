## Typechecking (and code gen)

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
## Typechecking and code generation

TODO: Add notes here TODO: Talk about the queues that exist

### Instructions

The process of code generation involves the production (creation) of
instructions and consumption of them (consuming them and embedding them
in other instructions). There are several types of instructions but the
main important base ones are listed below.

#### The base `Instruction`

Every type of instruction that is produced during the code generation
phase is a kind-of `Instruction`, it is the base class for all
instructions and contains some common methods used by all of them:

1.  `setContext(Context)`
    - Sets the `Context` object that is to be associated with this
      instruction.
    - This is normally done as a way to transfer the context from the
      respective parser-node to the corresponding instruction such that
      if such context is needed during further code generation (or even
      emit) it can then be accessed
2.  `Context getContext()`
    - Returns this instruction’s associated context via its `Context`
      object
3.  `string produceToStrEnclose(string addInfo)`
    - Returns a string containing the additional info provided through
      `addInfo`
    - The format of the returned string will be
      `[Instruction: <className>: <addInfo>]` where `<className>` is the
      name of the instruction type (kind-of) and `<addInfo>` as
      explained previously

#### Value-based instructions (`Value`)

TODO: Talk about the `Value` instruction base class here

A `Value` instruction is a kind-of `Instruction` of which represents
code which generates some sort of value, think of literals, arithmetic
operations, pointer dereferences, variable reads and so on. Every such
instruction always has an associated `Type` object associated with it in
order to know the intended type of the instruction. Below we show the
API usage of the `Value` class:

1.  `Type getType()`
    - Returns the type associated with this instruction
2.  `setType(Type)`
    - Set the type to be associated with this instruction

There are many instructions which sub-type this `Value` class, these can
be found in
`<TODO: Insert path here and put all Value-based instructions in their own module>`.

------------------------------------------------------------------------

### Code generation

The method of code generation and type checking starts by being provided
a so-called “action list” which is a linear array of dependency-nodes
(or `DNode`s for code’s sake), this list is then iterated through by a
for-loop, and each `DNode` is passed to a method called
`typeCheckThing(DNode)`:

``` d
foreach(DNode node; actionList)
{
    /* Type-check/code-gen this node */
    typeCheckThing(node);
}
```

The handling of every different instruction type and its associated
typechecking requirements are handled in one huge if-statement within
the `typeCheckThing(DNode)` method. This method will analyse a given
dependency-node and perform the required typechecking by extracting the
`DNode`’s emebedded parser-node, whilst doing so if a type check passes
then code generation takes place by generating the corresponding
instruction and adding this to some position in the code queue
(discussed later).

#### Code queue

TODO: Add information on this

The code queue is used as a stack and a queue in order to facilitate
instruction generation. Certain instructions are produced once off and
then added to the back of the queue (*“consuming”* instructions) whilst
other are produced and pushed onto the top of the queue (*“producing”*
instructions) for consumption by other consuming instructions later.

An example of this would be the following T code which uses a binary
operation with two operands (one being a `LiteralValue` instruction and
the other being a `FuncCall` instruction):

``` d
                                1 + func()
```

This would result in a situation where we have the following production

![](/projects/tlang/graphs/pandocplot12139419864099887541.svg)

------------------------------------------------------------------------

### Enforcement

Enforcement is the procedure of ensuring that a given `Value`-based
instruction, $instr_{i}$, conforms to the target type or *“to-type”*,
$type_{i}$. An optional flag can be passed such that if the
$typeof(instr_{i}) \neq type_{i}$ that it can then attempt coercion as
to bring it to the equal type.

The method by which this is done is:

``` d
typeEnforce(Type toType,
            Value v2,
            ref Instruction coercedInstruction,
            bool allowCoercion = false)
```

We will discuss exact equality and exact equality through coercion in
the next two sections.

#### Type equality

In order to check strict equality the type enforcer will initially check
the following condition. We label the `toType` as $t_{1}$ and the the
type of `v2` as $typeof(v_{2})$ (otherwise referred to as $t_{2}$).

The method `isSameType(Type t1, Type t2)` provides exact quality
checking between the two given types in the form of $t_{1} = t_{2}$.

#### Coercion

In the case of coercion an application of $coerce()$ is applied to the
incoming instruction, as to produce an instruction $coerceInstr_{i}$, a
`CastedValueInstruction`, which wraps the original instruction inside of
it but allows for a type cast/conversion to the target type, therefore
making the statement, $type_{i} = typeof(coerce(instr_{i}))$ (which is
the same as $type_{i} = typeof(coerceInstr_{i})$), valid.

TODO: Document this now

Coercion has a set of rules (TODO: docuemnt them) in terms of what can
be coerced. AT the end of the day if the coercion fails then a
`CoercionException` is thrown, if, however it succeeds then a
`CastedValueInstruction` will be placed into the memory location (the
variable) pointed to by the `ref` parameter of
`typeEnforce(..., ..., ref Instruction coercedInstruction, true)`.

TODO: Document the usage of this for variable assignments for example

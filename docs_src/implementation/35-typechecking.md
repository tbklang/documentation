## Typechecking and code generation

TODO: Add notes here
TODO: Talk about the queues that exist

### Code generation

The method of code generation and type checking starts by being provided a so-called "action list" which is a linear array of dependency-nodes (or `DNode`s for code's sake), this list is then iterated through by a for-loop, and each `DNode` is passed to a method called `typeCheckThing(DNode)`:

```{.d .numberLines}
foreach(DNode node; actionList)
{
    /* Type-check/code-gen this node */
    typeCheckThing(node);
}
```

The handling of every different instruction type and its associated typechecking requirements are handled in one huge if-statement within the `typeCheckThing(DNode)` method. This method will analyse a given dependency-node and perform the required typechecking by extracting the `DNode`'s emebedded parser-node, whilst doing so if a type check passes then code generation takes place by generating the corresponding instruction and adding this to some position in the code queue (discussed later).

#### Code queue

TODO: Add information on this

The code queue is used as a stack and a queue in order to facilitate instruction generation. Certain instructions are produced once off and then added to the back of the queue (_"consuming"_ instructions) whilst other are produced and pushed onto the top of the queue (_"producing"_ instructions) for consumption by other consuming instructions later.

An example of this would be the following T code which uses a binary operation with two operands (one being a `LiteralValue` instruction and the other being a `FuncCall` instruction):

```{.d}
                                1 + func()
```

This would result in a situation where we have the following production

```{.graphviz}
digraph CodequeueProcess {
        graph [
                label="Code queueing process"
                labelloc="t"
                fontname="Helvetica,Arial,sans-serif"
        ]
        
        node [
                fontname="Helvetica,Arial,sans-serif"
                shape=record
                style=filled
                fillcolor=gray95
        ]


        Codequeue0 [
                shape=plain
                label=<<table border="0" cellborder="1" cellspacing="0" cellpadding="4">
                        <tr> <td> <b>Code queue (state 0)    </b> </td> </tr>
                        <tr> <td>
                                <table border="0" cellborder="0" cellspacing="0" >
                                        <tr> <td port="ss1" align="left" >        <i>Empty queue</i>    </td> </tr>
                                </table>
                        </td> </tr>

                </table>>
        ]
        Codequeue0 -> Codequeue1 [xlabel="addInstr() "]

        Codequeue1 [
                shape=plain
                label=<<table border="0" cellborder="1" cellspacing="0" cellpadding="4">
                        <tr> <td> <b>Code queue (state 1)</b>     </td> </tr>
                        <tr> <td>
                                <table border="0" cellborder="0" cellspacing="0" >
                                        <tr> <td port="ss1" align="left" >- LiteralValue</td> </tr>
                                </table>
                        </td> </tr>

                </table>>
                
                
        ]
        Codequeue1:ss1 -> cl1_value

        subgraph clusterLiteral
        {
            style=filled;
            color=lightgrey;
            cl1_value [label="value: 1"]
            label = "LiteralValue";
        }
        
        subgraph clusterFuncCall
        {
            style=filled;
            color=lightgrey;
            cl2_value [label="symbol: func"]
            label = "FuncCall";
        }
        

        edge [arrowhead=vee]
        Codequeue1 -> Codequeue2 [xlabel="addInstr() "]
        
        Codequeue2 [
                shape=plain
                label=<<table border="0" cellborder="1" cellspacing="0" cellpadding="4">
                        <tr> <td> <b>Code queue (state 2)    </b> </td> </tr>
                        <tr> <td>
                                <table border="0" cellborder="0" cellspacing="0" >
                                        <tr> <td port="ss1" align="left" >- FuncCall</td> </tr>
                                        <tr> <td port="ss2" align="left" >- LiteralValue</td> </tr>
                                </table>
                        </td> </tr>

                </table>>
        ]
        Codequeue2:ss1 -> cl2_value
        Codequeue2:ss2 -> cl1_value
        
        edge [arrowhead=vee]
        Codequeue2 -> Codequeue3 [xlabel="popInstr() "]
        
        Codequeue3 [
                shape=plain
                label=<<table border="0" cellborder="1" cellspacing="0" cellpadding="4">
                        <tr> <td> <b>Code queue (state 3)    </b> </td> </tr>
                        <tr> <td>
                                <table border="0" cellborder="0" cellspacing="0" >
                                        <tr> <td port="ss1" align="left" >- LiteralValue</td> </tr>
                                </table>
                        </td> </tr>

                </table>>
        ]
        Codequeue3:ss2 -> cl1_value
        
        edge [arrowhead=vee]
        Codequeue3 -> Codequeue4 [xlabel="popInstr() "]
        
        Codequeue4 [
                shape=plain
                label=<<table border="0" cellborder="1" cellspacing="0" cellpadding="4">
                        <tr> <td> <b>Code queue (state 4.0 )    </b> </td> </tr>
                        <tr> <td>
                                <table border="0" cellborder="0" cellspacing="0" >
                                        <tr> <td port="ss1" align="left" >        <i>Empty queue</i>    </td> </tr>
                                </table>
                        </td> </tr>

                </table>>
        ]
        
        edge [arrowhead=vee]
        Codequeue4 -> Codequeue5 [xlabel="addInstr() "]
        
        subgraph clusterBinaryOp
        {
            style=filled;
            color=lightgrey;
            label = "BinaryOp";
            cl3_value [label="operator: +"]
            leftInstr -> cl1_value
            rightInstr -> cl2_value
        }
        
        Codequeue5 [
                shape=plain
                label=<<table border="0" cellborder="1" cellspacing="0" cellpadding="4">
                        <tr> <td> <b>Code queue (state 4.1 )    </b> </td> </tr>
                        <tr> <td>
                                <table border="0" cellborder="0" cellspacing="0" >
                                        <tr> <td port="ss1" align="left" >- BinOpInstr</td> </tr>
                                </table>
                        </td> </tr>

                </table>>
        ]
        Codequeue5:ss1 -> cl3_value
}
```

---

### Enforcement

Enforcement is the procedure of ensuring that a given `Value`-based instruction, $instr_{i}$, conforms to the target type or _"to-type"_, $type_{i}$. An optional flag can be passed such that if the $typeof(instr_{i}) \neq type_{i}$ that it can then attempt coercion as to bring it to the equal type.

The method by which this is done is:

```{.d}
typeEnforce(Type toType,
            Value v2,
            ref Instruction coercedInstruction,
            bool allowCoercion = false)
```

We will discuss exact equality and exact equality through coercion in the next two sections.

#### Type equality

In order to check strict equality the type enforcer will initially check the following condition. We label the `toType` as $t_{1}$ and the the type of `v2` as $typeof(v_{2})$ (otherwise referred to as $t_{2}$).

The method `isSameType(Type t1, Type t2)` provides exact quality checking between the two given types in the form of $t_{1} = t_{2}$.

#### Coercion

In the case of coercion an application of $coerce()$ is applied to the incoming instruction, as to produce an instruction $coerceInstr_{i}$, a `CastedValueInstruction`, which wraps the original instruction inside of it but allows for a type cast/conversion to the target type, therefore making the statement, $type_{i} = typeof(coerce(instr_{i}))$ (which is the same as $type_{i} = typeof(coerceInstr_{i})$), valid.

TODO: Document this now

Coercion has a set of rules (TODO: document them) in terms of what can be coerced. AT the end of the day if the coercion fails then a `CoercionException` is thrown, if, however it succeeds then a `CastedValueInstruction` will be placed into the memory location (the variable) pointed to by the `ref` parameter of `typeEnforce(..., ..., ref Instruction coercedInstruction, true)`.

##### Example

Below we have an example of the code which processes variable declarations _with assignments_ (think of `byte i = 2`):

```{.d .numberLines}
Value assignmentInstr;
if(variablePNode.getAssignment())
{
  Instruction poppedInstr = popInstr();
  assert(poppedInstr);

  // Obtain the value instruction of the variable assignment
  // ... along with the assignment's type
  assignmentInstr = cast(Value)poppedInstr;
  assert(assignmentInstr);
  Type assignmentType = assignmentInstr.getInstrType();

  /** 
   * Here we can call the `typeEnforce` with the popped
   * `Value` instruction and the type to coerce to
   * (our variable's type)
   */
  typeEnforce(variableDeclarationType, assignmentInstr, assignmentInstr, true);
  assert(isSameType(variableDeclarationType, assignmentInstr.getInstrType())); // Sanity check
}

...
```

What the above code is doing is:

1. Firstly popping off an `Instruction` from the stack-queue and then down-casting it to `Value` (for `Value`-based instructions would be required as an _expression_ is being assigned)
2. We then call `typeEnforce()` providing it with:
        * The variable's type - the `variableDeclarationType`
        * The incoming `Value`-based instruction `assignmentInstr`
        * The third argument, is `ref`-based, meaning what we provide it is the variable which will have the result of the enforcement (if coercion is required) placed into
        * The last argument is `true`, meaning _"Please attempt coercion if the types are not exactly equal, please"_

The last line containing an assertion:

```{.d .numberLines}
assert(isSameType(
        variableDeclarationType,
        assignmentInstr.getInstrType()
        ); // Sanity check
```

This is a sanity check, as if the type coercion failed then an exception would be thrown and the assertion would not be reached, however if the types were an exact match **or** if they were not but could be coerced as such then the two types should match.

---

### Validation

Validation performs the partial filling of certain aspects
of the given instruction via the provided context. This
can vary from setting the correct type for the instruction
to performing further type checking on the instruction.
The reason this exists is that certain instructions can
only have such information determined (and thereafter set)
once certain context is provided - which normally is only
available in **later** instructions used in tandum with the
one provided here.

| Method                                           | Description              |
|--------------------------------------------------|--------------------------|
| `validate(InstrCtx ctx, Instruction inputInstr)` | _ctx_ is the instruction context (`InstrCtx`) and _inputInstr_ is the `Instruction` to validate itself |

The `InstrCtx` is defined as follows:

```d
struct InstrCtx
{
    /** 
     * The container with which
     * the instruction being validated
     * is a member of
     */
    Container memberOf;
}
```

| Method                                          | Description                            |
|-------------------------------------------------|----------------------------------------|
| `void setContainer(Container membersContainer)` | Sets the container part of the context |
| `Optional!(Container) getContainer()`           | Returns an optional of the container   |


---


TODO: Maybe put variable stuff in some other place

#### Misc.

These are interesting tid-bits on how some of the other features are implemented.

#### Variable referencing counting

Firstly let me make it clear that this has nothing to do with **runtime** reference counting but rather a simple mechanism used to maintain a count or _number of_ references to variables after their declaration.

Below is a method table of the methods of concern:

| Method | Description | Return |
|--------|-------------|--------|
| `touch(Variable)` | Increments the count by 1 for the given variable, creates a mapping if one does not yet exist | `void` |
| `getUnusedVariables()` | Returns an array of all `Variable`s which have a reference count above `1` | `Variable[]` |

This aids us in implementing a single feature _unused variable detection_. It's rather simple, reference counts are incremented by using a `touch(Variable)` method defined in the `TypeChecker` and this is called whilst doing dependency generation in the dependency generator.

The first time a variable is encountered, such as even its declaration, we will then `touch(...)`-it. At the end of type checking we then call the `getUnusedVariables()` method which returns a list of the undeclared variables. These are variables with a reference count higher than `1`. We then print these out so the user can see which are unused.

#### Usage

Example usage below shows us `touch`-ing a variable when we process them in expressions such as a `VariableExpression` in the dependency module:

```{.d .numberLines}
...

/* Get the entity as a Variable */
Variable variable = cast(Variable)namedEntity;

/* Variable reference count must increase */
tc.touch(variable);

...
```

We then, after typechecking, run the following in the type checker module's `doPostChecks()` method:

```{.d .numberLines}
/** 
 * Find the variables which were declared but never used
 */
if(this.config.hasConfig("typecheck:warnUnusedVars") & this.config.getConfig("typecheck:warnUnusedVars").getBoolean())
{
        Variable[] unusedVariables = getUnusedVariables();
        gprintln("There are "~to!(string)(unusedVariables.length)~" unused variables");
        if(unusedVariables.length)
        {
                foreach(Variable unusedVariable; unusedVariables)
                {
                        // TODO: Get a nicer name, full path-based
                        gprintln("Variable '"~to!(string)(unusedVariable.getName())~"' is declared but never");
                }
        }
}
```
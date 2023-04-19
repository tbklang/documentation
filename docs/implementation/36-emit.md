## Code emit

The code emit process is the final process of the compiler whereby the
`initQueue`, `codeQueue` and all assorted auxilllary information is
passed to an instance of `CodeEmitter` (in the case of the C backend
this is sub-typed to the `DGen` class) such that the code can be written
to a file. At this stage all queues consist simply of instances of the
`Instruction` class.

Our C backend or *custom code emitter*, `DGen`, inherits from the
`CodeEmitter` class which specifies that the following methods must be
overriden/implemented:

1.  `emit()`
    -   Begins the emit process
2.  `finalize()`
    -   Finalizes the emitting process (only to be called after the
        `emit()` finishes)
3.  `transform(Instruction instruction)`
    -   Transforms or emits a single Instruction and returns the
        transformation as a string

### Queues

There are several notable queues that the `CodeEmitter` class contains,
these are as follows:

1.  `initQueue`
    -   Despite its name this holds instructions for doing memory
        allocations for static entities (not initialization code for
        said entities)
2.  `globalsQueue`
    -   This queue holds instructions for the globals executions. This
        includes things such as global variable declarations and the
        sorts.
3.  Function definitions map
    -   This is a string-to-queue map which contains the code queues for
        every function definition.

Along with these queues there are some methods used to manipulate and
use them, these are:

1.  `selectQueue(QueueType, string)`
    -   Select the type of queue: `ALLOC_QUEUE` (for the `initQueue`),
        `GLOBALS_QUEUE` (for `globalsQueue` and `FUNCTION_DEF_QUEUE`
        (for the function definitions queue)
    -   For function definitions, the optional string argument (second
        argument) must specify the name of the function definition you
        would wish to use. An invalid name will throw an error. (TODO:
        Ensure we do this actually)
    -   This automatically calls `resetCursor()`.
2.  `nextInstruction()`
    -   Moves the cursor to the next instruction. Throws an exception if
        out of bounds. (TODO: Ensure we do this actually)
3.  `previousInstruction()`
    -   Moves the cursor to the previous instruction. Throws an
        exception if out of bounds. (TODO: Ensure we do this actually)
4.  `resetCursor()`
    -   Resets the position of the instruction pointer to 0.
5.  `getCurrentInstruction()`
    -   Retrieves the current instruction at the cursor.

### Custom code emits

We override/implement the `transform(Instruction instruction)` in `DGen`
to work somewhat as a big if-statement that matches the different
sub-types of Instructions that exist, then the respective code-emit (C
code) is generated. This method has the potential to be recursive as
some instructions contain nested instructions that must be transformed
prior before the final transformation, in which case a recursive call to
`transform(Instruction)` is made.

#### Code emit example: Variable declarationsTODO: Update this with new symbol mapper code

The example below is the code used to transform the in-memory
representation of a variable declaration, known as the
`VariableDeclaration` instruction, into the C code to be emitted:

``` d
/* VariableDeclaration */
else if(cast(VariableDeclaration)instruction)
{
    VariableDeclaration varDecInstr = cast(VariableDeclaration)instruction;
    Context context = varDecInstr.getContext();
    
    Variable typedEntityVariable = cast(Variable)context.tc.getResolver().resolveBest(context.getContainer(), varDecInstr.varName);

    string renamedSymbol = SymbolMapper.symbolLookup(typedEntityVariable);

    return varDecInstr.varType~" "~renamedSymbol~";";
}
```

What we have here is some code which will extract the name of the
variable being declared via `varDecInstr.varName` which is then used to
lookup the parser node of type `Variable`. The `Variable` object
contains information such as the variable’s type and also if a variable
assignment is attached to this declaration or not.

TODO: Insert code regarding assignment checking

Right at the end we then build up the C variable declaration with the
line:

``` d
return varDecInstr.varType~" "~renamedSymbol~";";
```

#### Symbol renaming

In terms of general code emitting we could have simply decided to use
the TLang-esque symbol name structure where entities are seperated by
periods such as `simple_module.x` where `simple_module` is a
container-type such as a `module` and `x` is some entity within it, such
as a variable. However, what we have decided to do in the emitter
process, specifically in `DGen` - our C code emitter - is to actually
rename these symbols to a hash, wherever they occur.

The renaming mechanism is hanlded by the `symbolLookup(Entity)` method
from the `SymbolMapper` class. This method takes in a single argument:

1.  `entity`
    -   This must be a type-of `Entity`, this is the entity of which the
        symbol renaming should be applied on.

This allows one do then translate the symbol name with the following
usage. In this case we want to translate the symbol of the entity named
`x` which is container in the module-container named
`simple_variables_decls_ass`. Therefore we provide both peices of
information into the function `symbolLookup`:

``` d
// The relative container of this variable is the module
Container container = tc.getModule();

// Lookup a variable named "x"
string varLookup = "x"

// The Variable (type-of Entity)
Variable variable = cast(Variable)tc.getResolver().resolveBest(context.getContainer(), varLookup);

// Symbol map
string renamedSymbol = SymbolMapper.symbolLookup(variable);

// renamedSymbol == t_c326f89096616e69e89a3874a4c7f324
```

The resulting hash is generated by resolving the absolute path name of
the entity provided, applying an md5 hash to this name and then
pre-pending a `t_` to the name. Therefore for the above code we will
have `simple_variables_decls_ass.x` mapped to a symbol name of
`t_c326f89096616e69e89a3874a4c7f324` to be emitted into the C code file.

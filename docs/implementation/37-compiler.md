## Compiler

All of the functionality mentioned in the past chapters describing each stage of the compilation process and their respective components are all combined in a `Compiler` object which adds additional functionality via the compiler configuration sub-system. This sub-system is passed into each stage (TODO: Not yet, only the code emitter, we must fix this) such that if a requirement for a decision to be taken based on compiler flags is specified then such configuration paremeters can be obtained via each module of the compilation stage.

### Compiler system

The `Compiler` class provides is constructed by being given source code as a string along with a `File` struct which represents the file of which to write the final emitted code to. This type provides the following methods:

1. `this(string sourceCode, File emitOutFile)`
    * Constructs a new compiler object with the given source code and the file to write the emitted code out to
    * An newly initialized `File` struct that doesn't contain a valid file handle can be passed in in the case whereby the emitter won't be used but an instance of the compiler is required
2. `doLex()`
    * Performs the tokenization of the input source code, `sourceCode`.
    * A `LexerException` may be thrown if an error occurs during the toeknization process.
3. `getTokens()`
    * Returns the tokens produced by a call to `doLex()`
    * A `CompilerException` will be thrown if called without `doLex()` having been called.
4. `doParse()`
    * Peforms parsing on the tokens and returns the generated super-container parse node, `Module`.
    * A `CompilerException` will be thrown if called without `doLex()` having been called.
    * A `CompilerException` will be thrown if called without and no tokens were produced by the call to `doLex()`.
5. `doTypeCheck()`
    * Performs typechecking and code generation.
    * A `CompilerException` will be thrown is the previous stages, including `doParse()` and its requirements, have not been called.
6. `doEmit()`
    * Performs emitting of C code
    * A `CompilerException` will be thrown is the previous stages, including `doTypeCheck()` and its requirements, have not been called.
7. `compile()`
    * Performs all of the above stages.
    * A `CompilerException` can be thrown for any of the aforementioned reasons.
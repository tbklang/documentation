## Compiler

All of the functionality mentioned in the past chapters describing each
stage of the compilation process and their respective components are all
combined in a `Compiler` object which adds additional functionality via
the compiler configuration sub-system. This sub-system is passed into
each stage (TODO: Not yet, only the code emitter, we must fix this) such
that if a requirement for a decision to be taken based on compiler flags
is specified then such configuration paremeters can be obtained via each
module of the compilation stage.

![](/projects/tlang/graphs/pandocplot6118349527803707673.svg)

### Compiler system

The `Compiler` class provides is constructed by being given source code
as a string along with a `File` struct which represents the file of
which to write the final emitted code to. This type provides the
following methods:

1.  `this(string sourceCode, File emitOutFile)`
    -   Constructs a new compiler object with the given source code and
        the file to write the emitted code out to
    -   An newly initialized `File` struct that doesn't contain a valid
        file handle can be passed in in the case whereby the emitter
        won't be used but an instance of the compiler is required
2.  `doLex()`
    -   Performs the tokenization of the input source code,
        `sourceCode`.
    -   A `LexerException` may be thrown if an error occurs during the
        toeknization process.
3.  `getTokens()`
    -   Returns the tokens produced by a call to `doLex()`
    -   A `CompilerException` will be thrown if called without `doLex()`
        having been called.
4.  `doParse()`
    -   Peforms parsing on the tokens and returns the generated
        super-container parse node, `Module`.
    -   A `CompilerException` will be thrown if called without `doLex()`
        having been called.
    -   A `CompilerException` will be thrown if called without and no
        tokens were produced by the call to `doLex()`.
5.  `doTypeCheck()`
    -   Performs typechecking and code generation.
    -   A `CompilerException` will be thrown is the previous stages,
        including `doParse()` and its requirements, have not been
        called.
6.  `doEmit()`
    -   Performs emitting of C code
    -   A `CompilerException` will be thrown is the previous stages,
        including `doTypeCheck()` and its requirements, have not been
        called.
7.  `compile()`
    -   Performs all of the above stages.
    -   A `CompilerException` can be thrown for any of the
        aforementioned reasons.

TODO: Document `CompilerException` exception and `CompilerError` enum.

### Configuration sub-system

At user-request or due to constraints of the host machine it may be
required that certain aspects of the various components of the compiler
be modified in terms of their behaviour. This is where the compiler
configuration sub-system comes in in order to support a key-value store
that can be used via the `compiler.config` field at any time.

#### The `CompilerConfiguration` API

The `CompilerConfiguration` exposes the following API:

1.  `bool hasConfig(string key)`
    -   Checks if the given `key` exists in the key-value store, returns
        `false` if not, `true` otherwise
2.  `addConfig(ConfigEntry entry)`
    -   Stores the given entry in the cnfiguration store
    -   Throws a `CompilerException` if you are trying to update an
        entry to a different tye than the existing one
3.  `ConfigEntry getConfig(string key)`
    -   Returns the `ConfigEntry` at the provided name
    -   Throws a `CompilerException` if no such entry exists

#### The `ConfigEntry` API

The `ConfigEntry` represents a configuration entry, this is composed of:

1.  An entry name
    -   Fetched via `string getName()`
2.  An entry type
    -   This is fetched via `ConfigType getType()`
3.  An entry value
    -   This is fetched via `getX()`
    -   There are several getter functions which will interpret the
        union space dependent on which one you call, however, in reality
        a misinterpretation will cause a runtime error as we catch it
        before you attempt to do a reinterpattion of it, therefore
        throwing a `CompilerException`

The types that can be stored and their respectives methods are:

1.  Boolean
    -   Values: `true` or `false`
    -   Use `getBoolean()`
2.  Number
    -   Values: A valid D `ulong`
    -   Use `getNumber()`
3.  Text
    -   Values: A D `string`
    -   Use `getText()`
4.  Tex array
    -   Values: A D `string[]`
    -   Use `getArray()`

#### Example usage

##### Creation of entries

Below is an example of the usage of the `ConfigEntry`s in the
`CompilerConfiguration` system, here we add a few entries:

``` {.d .numberLines}
/* Enable Behaviour-C fixes */
config.addConfig(ConfigEntry("behavec:preinline_args", true));

/* Enable pretty code generation for DGen */
config.addConfig(ConfigEntry("dgen:pretty_code", true));

/* Enable entry point test generation for DGen */
config.addConfig(ConfigEntry("dgen:emit_entrypoint_test", true));

/* Set the mapping to hashing of entity names (TODO: This should be changed before release) */
config.addConfig(ConfigEntry("emit:mapper", "hashmapper"));
```

##### Retrieval of entries

Later on we can retrieve these entries, the below is code from the
`DGen` class which emits the C code), here we check for any object files
that should be linked in:

``` {.d .numberLines}
//NOTE: Change to system compiler (maybe, we need to choose a good C compiler)
string[] compileArgs = ["clang", "-o", "tlang.out", file.name()];

// Check for object files to be linked in
string[] objectFilesLink;
if(config.hasConfig("linker:link_files"))
{
    objectFilesLink = config.getConfig("linker:link_files").getArray();
    gprintln("Object files to be linked in: "~to!(string)(objectFilesLink));
}
else
{
    gprintln("No files to link in");
}

Pid ccPID = spawnProcess(compileArgs~objectFilesLink);
```

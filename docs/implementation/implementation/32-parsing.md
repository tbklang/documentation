## Parsing

Once we have generated a list of tokens (instances of `Token`) from the `Lexer` instance we need to turn these into a structure that represents our program's source code _but_ using in-memory data-structures which we can traverse and process at a later stage.

### Overview

The `Parser` class contains several methods for parsing different sub-structures of a TLang program and returning different data types generated by these methods. The parser has the ability to move back and forth between the token stream provided and fetch the current token (along with analysing it to return the type of symbol the token represents - known as the `SymbolType` (TODO: Cite the “Symbol types” section).

For example, the method `parseIf()` is used to parse if statements, it is called on the occurence of the token of `if`. This method returns an instance of type `IfStatement`. Then there are methods like `parseBody()` which is responsible for creating several sub-calls to methods such as `parseIf()` and building up a list of `Statement` instances (the top-type for all parser nodes).

The entry point to call is `parse()` which will return an instance of type `Module`.

!!! info
    The entry point handling may change soon with the advent of proper module support

### API

The API exposed by the parser is rather minimal as there isn't much to a parser than controlling the token stream pointer (the position in the token stream), fetching the token and acting upon the type or value of said token. Therefore we have the methods summarised below:

1. `nextToken()`
    * Moves the token pointer to the next token
2. `previousToken()`
    * Moves the token pointer to the previous token
3. `getCurrentToken()`
    * Returns the current `Token` instance at the current token pointer position
4. `hasTokens()`
    * Returns `true` if there are tokens still left in the stream (i.e. `tokenPtr < tokens.length`), `false` otherwise

### Initialization

The initialization of the parser is rather simple, an instance of the `Parser` class must be instantiated, along with this the following arguments must be provided to the constructor:

1. `Token[] tokens`
    * This is an array of `Token` to be provided to the parser for parsing. This would have been derived from the `Lexer` via its `performLex()` and `getTokens()` call.

A new instance woud therefore be created with something akin to:

```d
// Tokenize the following program
string sourceCode = "int i = 2;"
Lexer lexer = new Lexer(sourceCode);
lexer.performLex();

// Extract tokens and pass to the lexer
Token[] tokens = lexer.getTokens();
Parser parser = new Parser(tokens);
```

### Symbol types

The token stream is effectively a list of instances of `Token` which consist just of the token itself as a string and the coordinates of the token (where it occurs). However, some tokens, despite being different strings, can be of the same type or _syntactical grouping_. For example one would agree that both tokens `1.5` and `25.2` are both different tokens but are both floating points. This is where the notion of symbol types comes in.

The enum `SymbolType` in `parsing/symbols/check.d` describes all of the available types of tokens there are in the grammar of the Tristan programming language like so:

```d
public enum SymbolType {
	LE_SYMBOL,
	IDENT_TYPE,
	NUMBER_LITERAL,
	CHARACTER_LITERAL,
	STRING_LITERAL,
	SEMICOLON,
	LBRACE,
	...
}
```

Given an instance of `Token` one can pass it to the `getSymbolType(Token)` method which will then return an enum member from `SymbolType`. When a token has no associated symbol type then `SymbolType.UNKNOWN` is returned. Now for an example:

```d
// Create a new token at with (0, 0) as coordinates
Token token = new Token("100", 0, 0);

// Get the symbol type
SymbolType symType = getSymbolType(token);
assert(symType == SymbolType.NUMBER_LITERAL);
```

This assertion would pass as the symbol type of such a token is a number literal.

#### API

The API for working with and using `SymbolType`s is made available within the `parsing/data/check.d` and contains the following methods:

1. `isType(string)`
    * Returns `true` if the given string (a token) is a built-in type
    * Built-in type strings would be: `byte, ubyte, short, ushort, int, uint, long, ulong, void`
2. `getSymbolType(Token)`
    * Returns the `SymbolType` associated with the given `Token`
    * If the token is not of a valid type then `SymbolType.UNKNOWN` is returned
3. `getCharacter(SymbolType)`
    * This performs the reverse of `getSymbolType(Token)` in the sense that you provide it a `SymbolType` and it will return the corresponding string that is of that type.
    * This will work only for back-mapping a sub-section of tokens as you won't get anything back if you provide `SymbolType.IDENT_TYPE` as there are infinite possibiltiies for that - not a fixed token.

### Data types

Every node returned by a `parseX()` is of a certain type and there are some important types to mention here. The following types are from either `parsing/data.d` or `parsing/containers.d`.

#### `Statement`

The `Statement` type is the top-type for most parse nodes, it has the following important methods and fields:

1. `weight`
    * This holds a `byte` value which is used for when statements are required to be re-ordered. It starts default at 0 whereby that is the most prioritized re-ordering value (i.e. smaller means you appear first)
2. `parentOf()`
    * This returns an instance of `Container`, specifically indicating of which container this Statement is a parent of.
    * It can be `null` if this Statement was not parented.
3. `parentTo(Container)`
    * Set the parenting `Container` of this Statement to the one provided.
4. `toString()`
    * The default string representtion method for Statements (unless overridden) is to show a rolling count which is increment with every instantiation of a Statement object.

#### `Entity`

The `Entity` type is a sub-type of `Statement` and represents any named entity, along with initialization scopes (TODO: these are not yet implemented semantically and accessor types) (TODO: these are not yet implemented semantically.) The following methods and fields are to note:

1. `this(string)`
    * Constructs a new instance of an Entity with the provided name.
2. `getName()`
    * Returns the name of the entity.
3. `setAccessorType(AccessorType accessorType)`
    * TODO: Describe this
4. `getAccessorType()`
    * TODO: Describe this
5. `setModifierType(InitScope initScope)`
    * TODO: Describe this
6. `InitScope getModifierType()`
    * TODO: Describe this
7. `bool isExternal()`
    * If this returns `true` then it is a signal that this Entity should be emitted in a manner pertaining to an external symbol rather than one found in the current T module
8. `void makeExternal()`
    * Mark this Entity as external
    * You will see this used in `parseExtern()` as that is where we need to mark entities as external for link-time resolution

#### `Container`

The `Container` type is an interface that specifies a certain type to implement a set of methods. These methods allow the type to _become_ a container by then allowing one or more instances of `Statement` or rather a `Statement[]` to be contained within the container i.e. making it contain them.

It should be noted that the parenting method is used to climb up the hierachy **given** a Statement instance, however the Container technique is useful for a top-down search for an Entity - they are independent in that sense but can be used toghether TODO: double check but I believe this is right.

### How to parse

The basic flow of the parser involves the following process:

1. Firstly you need an entry point, this entry point for us is the `parse()` method which will return an instance of `Module` which represents the module - the TLang program.
2. Every `parseX()` method gets called by another such method dependent on the current symbol (and sometimes a lookahead)
    * For example, sometimes when we come across `SymbolType.IDENTIFIER` we call `parseName()` which can then either call `parseFuncCall()`, `parseTypedDeclaration()` or `parseAssignment()`. This requires a lookahead to check what follows the identifier because just by itself it is too ambuguous grammatically.
    * After determining what comes next the token is pushed back using `previousToken()` and then we proceed into the correct function
    * Lookaheads are rare but they do appear in situations like that
3. The `parseX()` methods return instances of `Statement` which is the top type for all parser-generated nodes or _AST nodes_.
4. When you are about to parse a sub-section (like an if statement) of a bigger syntax group (like a body) you leave the _offending token_ as the current token, then you call the parsing method (in this case `parseIf()`) and let it handle the call to `nextToken()` - this is simply the structure of parsing that TLang follows.
5. Upon exiting a `parseX()` method you call `nextToken()` - this determines whether this method would continue parsing or not - if not then you return and the caller will continue with that current token and move on from there.

#### Example of parsing if-statements

We will now look at an example of how we deal with parsing if statements in our parser, specifically within the `parseBody()`. The beginning of this method starts by moving us off the offending token that made us call `parseBody()` (hence the call to `nextToken()`). After which we setup an array of `Statement` such that we can build up a body of them:

```d
gprintln("parseBody(): Enter", DebugType.WARNING);

Statement[] statements;

/* Consume the `{` symbol */
nextToken();
```

Now we are within the body, as you can imagine a body is to be made up of several statements of which we do not know how many there are. Therefore we setup a loop that will iterate till we run out of tokens:

```d
while (hasTokens())
{
	...
}
```

Next thing we want to do if grab the current token and check what type of symbol it is:

```d
while (hasTokens())
{
	/* Get the token */
	Token tok = getCurrentToken();
	SymbolType symbol = getSymbolType(tok);
	gprintln("parseBody(): SymbolType=" ~ to!(string)(symbol));

	...
}
```

Following this we now have several checks that make use of `getSymbolType(Token)` in order to determine what the token's type is and then in our case if the token is `"if"` then we will make a call to `parseIf()` and append the returned Statement-sub-type to the body of statements (`Statement[]`):

```d
while(hasTokens())
{
	...

	/* If it is a branch */
	else if (symbol == SymbolType.IF)
	{
		statements ~= parseIf();
	}

	...
}
```

---

### Import system

#### What is a program?

Before we continue we should quickly discuss what _is a program_. The `Program` type is defined in a rather simple
manner. It _is_ a kind-of `Container` (a type ypu shall see described more in detail later) and hence has the methods
for adding or querying `Statement`(s) from/in itself.

What makes a program unique is that it will only allow you to add `Statement`(s) to it which are of the `Module` type,
and here is where the definition comes in.

>A program is a set of modules

There are also methods that relate to how this is managed but that is discussed in a later section on the topic of
_module management_. All you are required to know here is that _programs_ can hold _modules_. Notably too, a program
is **not** any kind-of `Entity` and hence has no name associated with it, the first such `Entity` within the tree
which _does_ is that of its associated _modules_.

#### Determining what to import

We can now move onto the crux of the matter which is _"How does the parser manage importing of modules?"_.

First we must observe that `import` statements are only valid at the module-level, meaning that you will
only ever see a call to `parseImport()` from the code within the `parse(string, boolean)` as follows:

```d
/* If it is an import */
else if(symbol == SymbolType.IMPORT)
{
    parseImport();
}
```

So then, how does this work. Well, compared to _other_ parts of the parser this is one which actually
has to maintain state and makes use of _multiple parsers_ in a recursive manner. Therefore it is worth
delving deeper into as compared to other topics of parsing which are rather straight forward.

**Steps**:

The first few steps are rather simple, and are what you would expect from any other parsing
method within the parser, but nonetheless they aid us in determining a set of important variables:

1. First consume the token `import`
2. Now expect an identifier kind-of `SymbolType`, i.e. a name, then save and consume
3. Check if there is a `,` symbol, if so we then loop whilst we have a `,`
    i. Each iteration saving the name found (i.e. `a, b, c;`)
4. Expect a semi-colon (`;`) and consume it

At the end of this we should have a list of modules wanting to be imported, namely
`collectedModuleNames`.

The code is attached below:

```{.d .numberLines}
/* Consume the `import` keyword */
lexer.nextToken();

/* Get the module's name */
expect(SymbolType.IDENT_TYPE, lexer.getCurrentToken());
string moduleName = lexer.getCurrentToken().getToken();

/* Consume the token */
lexer.nextToken();

/* All modules to be imported */
string[] collectedModuleNames = [moduleName];

/* Try process multi-line imports (if any) */
while(getSymbolType(lexer.getCurrentToken()) == SymbolType.COMMA)
{
    /* Consume the comma `,` */
    lexer.nextToken();

    /* Get the module's name */
    expect(SymbolType.IDENT_TYPE, lexer.getCurrentToken());
    string curModuleName = lexer.getCurrentToken().getToken();
    collectedModuleNames ~= curModuleName;

    /* Consume the name */
    lexer.nextToken();
}

/* Expect a semi-colon and consume it */
expect(SymbolType.SEMICOLON, lexer.getCurrentToken());
lexer.nextToken();
```

#### Visiting modules

We now have an array of modules wanting to be imported in the form of `collectedModuleNames`.
But what do we do with these now?

Well, we need to obviously open up the modules but that means ~~two~~ three things:

1. How do we map a module name `b` to a filename?
2. How do we prevent cycles when visiting modules
3. How do we add them all to the correct _program_?

Well, lucky for you the answers are all here - albeit, it did take a lot of time to get this
albeit simple-sounding system right.

The mapping of names is discussed in the _module management_ section but
needless to say it is performed by the current `Program`'s `ModuleManager`
which can be retrieved via `this.program.getModMan()`.

---

Let's look at how this code works. Recall that we were still busy in `parseImport()`.
Well, now we shall enter the following method `doImport(string[])` as follows:

```d
/* Perform the actual import */
doImport(collectedModuleNames);
```

This method first of all starts off by obtaining a few important object instances:

```d
// Print out some information about the current program
Program prog = this.compiler.getProgram();

// Get the module manager
ModuleManager modMan = compiler.getModMan();
```

---

Now, we must perform the following **steps**:

1. _For every_ module name `i` in `collectedModuleNames`
    i. Find a `ModuleEntry` for _name_ `i`
    ii. Append this `ModuleEntry` to `foundEnts`

This step is what satisfies the first 1/3 steps of ours. This maps the incoming
module _name_ to a module _filename_. The code for doing this is shown below:

```{.d .numberLines}
// Search for all the module entries
ModuleEntry[] foundEnts;
foreach(string mod; modules)
{
    gprintln(format("Module wanting to be imported: %s", mod));

    // Search for the module entry
    ModuleEntry foundEnt = modMan.find(mod);
    gprintln("Found module entry: "~to!(string)(foundEnt));
    foundEnts ~= foundEnt;
}
```

---

Now we have to do the following **steps**:

1. _For each_ module entry `m` in `foundEnts`
    i. Check if `m` has been visited, **if so**, then go back to `1` and process the next _module entry_
    ii. _If **not**_ then _mark the entry_ as visited
        a. Then read the module's source code
        b. Parse the module and obtain a `Module` object
        c. Save the obtained `Module` to the _module entry_ `m`

The code for the above algorithm can be seen below:

```{.d .numberLines}
// For each module entry, only import
// it if not already in the process
// of being visited
foreach(ModuleEntry modEnt; foundEnts)
{
    // Check here if already present, if so,
    // then skip
    if(prog.isEntryPresent(modEnt))
    {
        gprintln(format("Not parsing module '%s' as already marked as visited", modEnt));
        continue;
    }

    // Mark it as visited
    prog.markEntryAsVisited(modEnt);

    // Read in the module's contents
    string moduleSource = modMan.readModuleData_throwable(modEnt);
    gprintln("Module has "~to!(string)(moduleSource.length)~" many bytes");

    // Parse the module
    import tlang.compiler.lexer.kinds.basic : BasicLexer;
    LexerInterface lexerInterface = new BasicLexer(moduleSource);
    (cast(BasicLexer)lexerInterface).performLex();
    Parser parser = new Parser(lexerInterface, this.compiler);
    Module pMod = parser.parse(modEnt.getPath());

    // Map parsed module to its entry
    prog.setEntryModule(modEnt, pMod);
}
```

This whole process is important, especially the aspect whereby we mark a module as visited prior to finishing parsing it.
One needs this because a module `b` might import a module `a` which imports a module `b` and it is at this last point that
we want the check for visitation to return `true` even though parsing of the `b` module has not yet completed.

Then at the end of the entire process we save the obtained _module object_ to its respective _module entry_. The act
of saving it basically maps the module's _name_ to the `Module` object itself and **also** adds it to the `Program`'s
body - hence making this module a part of the larger program.


#### The first call to `parse(string, bool)`

Now that we know how all of this fits together it is worth taking a look at where this all starts, the _first call
to the parser_.

If we take a look at the `doParser()` method inside the `Compiler` object then we can get an idea of how this all
starts off.

We firstly construct a new `Parser` and provide it an instance of the `Compiler` itself and _of course_ the
tokens to parse. The compiler is important as it contains the `Program` instance whereby `Module`(s) will
be attached to:

```d
/* Spawn a new parser with the provided tokens */
this.parser = new Parser(lexer, this);
```

After this we then begin the parsing, notably we set the second parameter to `true` to indicate that the
module being parsed is for the entrypoint (we shall see the effect of this later):

```d
// It is easier to grab the module
// name from inside hence we should probably
// have a default parameter isEntrypoint=false
// and then add it from within
Module modulle = parser.parse(this.inputFilePath, true);
```

Now, we look to the `parse(string, bool)` method inside `Parser`. Here we do some obvious steps
of determing the module's name and then constructing an empty `Module` object to which the body
of the module, of which is to be parsed shortly, shall be added:

```{.d .numberLines}
Module modulle;

/* Expect `module` and module name and consume them (and `;`) */
expect(SymbolType.MODULE, lexer.getCurrentToken());
lexer.nextToken();

/* Module name may NOT be dotted (TODO: Maybe it should be yeah) */
expect(SymbolType.IDENT_TYPE, lexer.getCurrentToken());
string moduleName = lexer.getCurrentToken().getToken();
lexer.nextToken();

expect(SymbolType.SEMICOLON, lexer.getCurrentToken());
lexer.nextToken();

/* Initialize Module */
modulle = new Module(moduleName);
```

---

We then also copy over the file path so that we can associate it with the module itself. This
is not actually used anywhere else but it is here for now:

```d
/* Set the file system path of this module */
modulle.setFilePath(moduleFilePath);
```

---

Continuing on we now approach a vital step which relates to the boolean flag we set earlier. We
want to add ourselves, the _current module_, to the program immediately such that we are known to
have been visited already. The reason for this is because else only modules we import would be added
and we would be skipped (unless added via another import of one of those aforementioned modules):

```{.d .numberLines}
/**
 * If this is an entrypoint module (i.e. one
 * specified on the command-line) then store
 * it as visited
 */
if(isEntrypoint)
{
    gprintln
    (
        format
        (
            "parse(): Yes, this IS your entrypoint module '%s' about to be parsed",
            moduleName
        )
    );

    ModuleEntry curModEnt = ModuleEntry(moduleFilePath, moduleName);
    Program prog = this.compiler.getProgram();

    prog.markEntryAsVisited(curModEnt); // TODO: Could not call?
    prog.setEntryModule(curModEnt, modulle);
}
```

The reason the if statement is that because the `parse(string, bool)` method will be
called several other times for _other modules_ when they are parsed because the entry
point module had an import _for them_, and they follow semantics that we already mentioned
earlier with the whole `parseImport()` mechanism. Hence this is just a special case that
must be handled.

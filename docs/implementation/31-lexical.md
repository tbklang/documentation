## Lexical analysis

Lexical analysis is the process of taking a program as an input string
$A$ and splitting it into a list of $n$ sub-strings
$A_{1},\,A_{2}\ldots A_{n}$ called tokens. The length $n$ of this list
of dependent on several rules that determine how, when and where new
tokens are built - this set of rules is called a *grammar*.

### Grammar

The grammar is described in the [language
section](../../language/31-grammar/) and can be viewed alongside this
section for some context.

### Overview

The source code for the lexical analysis part of the compiler is located
in `source/tlang/compiler/lexer/` which contains a few important module
and class definitions.

#### Lexer API

The **Lexer API** describes the required methods that a tokenizer must
have in order to be used within the TLang compiler infrastructure. The
reason for describing such an interface is such that more improved
tokenizers can be easily integrated down the line in a manner that does
not require much churn in the parts of the code base that use the lexer
(namely the parser).

The API is described in the table below and the file in question is in
`source/tlang/compiler/lexer/core/lexer.d` which contains the
`LexerInterface` described below:

| Method name         | Return type | Description                                                                   |
|---------------------|-------------|-------------------------------------------------------------------------------|
| `getCurrentToken()` | `Token`     | Returns the `Token` at the current cursor position                            |
| `nextToken()`       | `void`      | Moves the cursor forward once                                                 |
| `previousToken()`   | `void`      | Moves the cursor backwards once                                               |
| `setCursor(ulong)`  | `void`      | Set’s the cursor’s position to the given index                                |
| `getCursor()`       | `ulong`     | Returns the cursor’s current position                                         |
| `hasTokens()`       | `bool`      | Returns `true` if there are more tokens to be consumed, otherwise `false`     |
| `getLine()`         | `ulong`     | Return’s the line number the lexer is at                                      |
| `getColumn()`       | `ulong`     | Return’s the column number the lexer is at                                    |
| `getTokens()`       | `Token[]`   | Exhausts the lexer’s token stream and returns all gathered tokens in an array |

#### Character constants

For completion we include the commonly used character constant
definitions. These come in the form of the `LexerSymbols` enumeration
type as shown below:

``` d
public enum LexerSymbols : char
{
    L_PAREN = '(',
    R_PAREN = ')',
    SEMI_COLON = ';',
    COMMA = ',',
    L_BRACK =  '[' ,
    R_BRACK =  ']' ,
    PLUS =  '+' ,
    MINUS =  '-' ,
    FORWARD_SLASH =  '/' ,
    PERCENT =  '%' ,
    STAR =  '*' ,
    AMPERSAND =  '&' ,
    L_BRACE =  '{' ,
    R_BRACE =  '}' ,
    EQUALS =  '=' ,
    SHEFFER_STROKE =  '|' ,
    CARET =  '^' ,
    EXCLAMATION =  '!' ,
    TILDE =  '~' ,
    DOT =  '.' ,
    COLON =  ':',
    SPACE = ' ',
    TAB = '\t',
    NEWLINE = '\n',
    DOUBLE_QUOTE = '"',
    SINGLE_QUOTE =  '\'' ,
    BACKSLASH =  '\\' ,
    UNDERSCORE =  '_' ,
    LESS_THAN =  '<' ,
    BIGGER_THAN =  '>' ,

    ESC_NOTHING =  '0' ,
    ESC_CARRIAGE_RETURN =  'r' ,
    ESC_TAB =  't' ,
    ESC_NEWLINE =  'n' ,
    ESC_BELL=  'a' ,

    ENC_BYTE =  'B' ,
    ENC_INT =  'I' ,
    ENC_LONG =  'L' ,
    ENC_WORD =  'W' ,
    ENC_UNSIGNED =  'U' ,
    ENC_SIGNED =  'S' ,
}
```

#### Helper methods

There are quite a few helper methods as well which are commonly used
across the lexer implementation and therefore are worth being aware of.
You can find these all within the `tlang.compiler.lexer.core.lexer`
module.

| Method name                        | Return type | Description                                                                                           |
|------------------------------------|-------------|-------------------------------------------------------------------------------------------------------|
| `isOperator(char c)`               | `bool`      | Checks if the provided character is an operator, returning `true` if so                               |
| `isSplitter(char c)`               | `bool`      | Checks if the provided character is a splitter, returning `true` if so                                |
| `isNumericalEncoder_Size(char)`    | `bool`      | Checks if the provided character is a numerical size encoder                                          |
| `isNumericalEncoder_Signage(char)` | `bool`      | Checks if the provided character is a numerical signage encoder                                       |
| `isNumericalEncoder(char)`         | `bool`      | Checks if the provided character is either a numerical size encoder or signage encoder                |
| `isValidEscape_String(char)`       | `bool`      | Checks if the given character is a valid escape character (something which would have followed a `\`) |
| `isValidDotPrecede(char)`          | `bool`      | Given a character return whether it is valid entry for preceding a ‘.’.                               |

#### the `Token`

A `Token` represents, well, a token which is produced in following the
grammar.

| Method name                  | Return type | Description                                                                           |
|------------------------------|-------------|---------------------------------------------------------------------------------------|
| `this(string, ulong, ulong)` | Constructor | Constructs a new `Token` with the given contents, followed by line and column numbers |
| `opEquals(Object other)`     | `bool`      | Overrides the behaviour of `==` to allow for comparing `Token`(s) based on content    |
| `getToken()`                 | `string`    | Returns the contents of this token                                                    |
| `toString()`                 | `string`    | Returns a string representation of the token including its data and line information  |

Below, as an example of the API, we show how you con compare tokens (if
you ever needed to):

``` d
// Create two tokens containing contents "int"
Token token1 = new Token("int");
Token token2 = new Token("int");

// Compare them for equality 
// (would evaluate to true rather than false by reference equality (the default in D))
assert(token1 == token2);
```

#### the `LexerException`

This is a simple exception type of which extends the `TError` exception
type (the base type used within the TLang compiler system).

It is rather simple, the constructor takes in the following (in order of
appearance):

1.  `LexerInterface`
    - We take in the offending instance of the lexer used which
      generated this exception
    - This is such that coordinate information (the $(x,y)$ source text
      pointer can be added into error messages)
2.  `LexerError`
    - This is an **optional** parameter which defaults to
      `LexerError.OTHER`
    - Base reason for the exception
3.  `string`
    - This is an **optional** parameter which defaults to `""`
    - This is the custom error text

The `LexerError` is an enumeration type that is comprised of the
following members:

``` d
/** 
 * The specified error which occurred
 */
public enum LexerError
{
    /** 
     * If all the characters were
     * exhausted
     */
    EXHAUSTED_CHARACTERS,

    /** 
     * Generic error
     */
    OTHER
}
```

------------------------------------------------------------------------

### Implementation of the single-pass tokenizer

The current lexer implementation that is being used is the `BasicLexer`
(available at `source/tlang/compiler/lexer/kinds/basic.d`) and it is a
one-pass lexer, this means that before you use any methods such as
`nextToken()` you must first have called `performLex()` on it such that
the `Token[]` can be generated.

This is not the most efficient way, but a streaming lexer is not yet
implemented **however** it is planned.

#### Overview

A quick overview of some of the fields which are used for tracking the
state of the token building process:

| Name           | Type      | Purpose                                                                    |
|----------------|-----------|----------------------------------------------------------------------------|
| `sourceCode`   | `string`  | the whole input program (as a string) to be tokenized                      |
| `position`     | `ulong`   | holds the index to the current character in the string array `sourceCode`  |
| `currentChar`  | `char`    | the current character at index-`position`                                  |
| `tokens`       | `Token[]` | The list of the currently built tokens                                     |
| `line`         | `ulong`   | Current line the tokenizer is on (with respect to the source code input)   |
| `column`       | `ulong`   | Current column the tokenizer is on (with respect to the source code input) |
| `currentToken` | `string`  | The token string that is currently being built-up, char-by-char            |

The implementation of the lexer, the `BasicLexer` class, is explained in
detail in this section. The lexical analysis is done one-shot via the
`performLex()` method which will attempt to tokenize the input program,
on failure returning `false`, `true` otherwise. In the successful case
the `tokens` array will be filled with the created tokens and can then
later be retrieved via a call to `getTokens()`.

Below is an example usage of the `BasicLexer` which makes use of it in
order to process the following input source code:

``` d
new A().l.p.p;
```

Here is the code to do so:

``` d
/**
* Test correct handling of dot-operator for
* non-floating point cases
*
* Input: `new A().l.p.p;`
*/
unittest
{
    import std.algorithm.comparison;
    string sourceCode = "new A().l.p.p;";
    BasicLexer currentLexer = new BasicLexer(sourceCode);
    currentLexer.performLex();
    gprintln("Collected "~to!(string)(currentLexer.getTokens()));
    assert(currentLexer.getTokens() == [
        new Token("new", 0, 0),
        new Token("A", 0, 0),
        new Token("(", 0, 0),
        new Token(")", 0, 0),
        new Token(".", 0, 0),
        new Token("l", 0, 0),
        new Token(".", 0, 0),
        new Token("p", 0, 0),
        new Token(".", 0, 0),
        new Token("p", 0, 0),
        new Token(";", 0, 0)
    ]);
}
```

------------------------------------------------------------------------

#### Using `performLex()`

This method contains a looping structure which will read
character-by-character from the `sourceCode` string and follow the rules
of the [grammar](../../language/31-grammar/), looping whilst there are
still characters available for consumption
(`position < sourceCode.length`).

We loop through each character and dependent on its value we start
building new tokens, certain characters will cause a token to finish
being built which will sometimes be caused by `isSplitter(character)`
being `true`. A typical token building process looks something like the
following, containing the final character to be tacked onto the current
token build up, the creation of a new token object and the addition of
it to the `tokens` list, finishing with flushing the build up string and
incrementing the coordinates:

A typical token building procedure looks something like this:

``` d
/* Generate and add the token */
currentToken ~= "'";
currentTokens ~= new Token(currentToken, line, column);

/* Flush the token */
currentToken = "";
column += 2
position += 2;
```

#### Character and token availability

Helper functions relating to character and token availability.

| Method name        | Return type | Description                                                                                                                                                                                                                                                                     |
|--------------------|-------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `hasToken()`       | `bool`      | Returns `true` if there is a token currently built i.e. `currentToken.length != 0`, `false` otherwise.                                                                                                                                                                          |
| `isBackward()`     | `bool`      | Returns `true` if we can move the character pointer backwards, `false` otherwise.                                                                                                                                                                                               |
| `isForward()`      | `bool`      | Returns `true` if we can move the character pointer forward, `false` otherwise.                                                                                                                                                                                                 |
| `isNumericalStr()` | `bool`      | This method is called in order to check if the build up, `currentToken`, is a valid numerical string. If the string is empty, then it returns `false`. If the string is non-empty and contains anything other than digits then it returns `false`, otherwise is returns `true`. |

#### Grammar-wise

These are all the methods which pertain to the construction of tokens
based on different states of the state machine.

These methods follow a sort of methodology whereby they will return
`true` if there are characters left in the buffer which can still be
processed after return, or `false` if there are none left.

| Method name       | Return type | Description                                                                               |
|-------------------|-------------|-------------------------------------------------------------------------------------------|
| `doIdentOrPath()` | `bool`      | Processes an ident with or without a dot-path                                             |
| `doChar()`        | `bool`      | Tokenizes a character                                                                     |
| `doString()`      | `bool`      | Tokenizes a string                                                                        |
| `doComment()`     | `bool`      | Processes various different types of comments                                             |
| `doEscapeCode()`  | `bool`      | Lex an escape code. If valid one id found, add it to the token, else throw Exception      |
| `doNumber()`      | `bool`      | Lex a number, this method lexes a plain number, float or numerically encoded.             |
| `doEncoder()`     | `bool`      | Lex a numerical encoder                                                                   |
| `doFloat()`       | `bool`      | Lex a floating point, the initial part of the number is lexed by the `doNumber()` method. |

#### Buffer management

These are methods for managing the advancement of the lexing pointer,
the position of $(x, y)$ coordinates (used for error reporting) and so
forth.

| Method name                                              | Return type | Description                                                                                             |
|----------------------------------------------------------|-------------|---------------------------------------------------------------------------------------------------------|
| `flush()`                                                | `void`      | Flush the current token to the token buffer.                                                            |
| `buildAdvance()`                                         | `bool`      | Consume the current char into the current token, returns `true` on non-empty buffer                     |
| `improvedAdvance(int inc = 1, bool shouldFlush = false)` | `bool`      | Advances the source code pointer                                                                        |
| `advanceLine()`                                          | `bool`      | Advance the position, line and current token, reset the column to 1. Returns `true` on non-empty buffer |

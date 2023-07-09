## Lexical analysis

Lexical analysis is the process of taking a program as an input string
$A$ and splitting it into a list of $n$ sub-strings
$A_{1},\,A_{2}\ldots A_{n}$ called tokens. The length $n$ of this list
of dependent on several rules that determine how, when and where new
tokens are built - this set of rules is called a *grammar*.

### Grammar

TODO: fix the link The grammar is described in the [language
section](31-grammar.md) and can be viewed alongside this section for
some context.

### Overview of files

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

##### the `Token`

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

### impl basicLexer

- `BasicLexer` - The token builder
  - `sourceCode`, the whole input program (as a string) to be tokenized
  - `position`, holds the index to the current character in the string
    array `sourceCode`
  - `currentChar`, the current character at index-`position`
  - Contains a list of the currently built tokens, `Token[] tokens`
  - Current line and column numbers as `line` and `column` respectively
  - A “build up” - this is the token (in string form) currently being
    built - `currentToken`

### Implementation

The implementation of the lexer, the `Lexer` class, is explained in
detail in this section. (TODO: constructor) The lexical analysis is done
one-shot via the `performLex()` method which will attempt to tokenize
the input program, on failure returning `false`, `true` otherwise. In
the successful case the `tokens` array will be filled with the created
tokens and can then later be retrieved via a call to `getTokens()`.

Example usage: TODO

#### performLex()

TODO: This is going to change sometime soonish, so I want the final
version of how it works here. I may as well, however, give a brief
explanation as I doubt *much* will change - only specific parsing cases.

This method contains a looping structure which will read
character-by-character from the `sourceCode` string and follow the rules
of the grammar (TODO: add link), looping whilst there are still
characters available for consumption (`position < sourceCode.length`).

We loop through each character and dependent on its value we start
building new tokens, certain characters will cause a token to finish
being built which will sometimes be caused by `isSpliter(character)`
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

1.  `hasToken()`
    - Returns `true` if there is a token currently built
      i.e. `currentToken.length != 0`, `false` otherwise.
2.  `isBackward()`
    - Returns `true` if we can move the character pointer backwards,
      `false` otherwise.
3.  `isForward()`
    - Returns `true` if we can move the character pointer forward,
      `false` otherwise.
4.  `isNumericalStr()`
    - This method is called in order to chck if the build up,
      `currentToken`, is a valid numerical string. If the string is
      empty, then it returns `false`. If the string is non-empty and
      contains anything other than digits then it returns `false`,
      otherwise is returns `true`.

TODO

#### isSpliter()

This method checks if the given character is one of the following:

``` d
character == ';' || character == ',' || character == '(' || 
character == ')' || character == '[' || character == ']' || 
character == '+' || character == '-' || character == '/' || 
character == '%' || character == '*' || character == '&' || 
character == '{' || character == '}' || character == '=' || 
character == '|' || character == '^' || character == '!' || 
character == '\n' || character == '~' || character =='.' || 
character == ':';
```

!!! error FInish this page

•              

•  \| (TODO: make it texttt)   (TODO: not appearing)   

Whenever this method returns `true` it generally means you should flush
the current token, start a new token add the offending spliter token and
flush that as well.

## Lexical analysis

Lexical analysis is the process of taking a program as an input string
$A$ and splitting it into a list of $n$ sub-strings
$A_{1},\,A_{2}\ldots A_{n}$ called tokens. The length $n$ of this list
of dependent on several rules that determine how, when and where new
tokens are built - this set of rules is called a *grammar*.

### Grammar

TODO: Add link to other seciton or remove this

### Overview of implementation

The source code for the lexical analysis part of the compiler is located
in `source/tlang/lexer.d` which contains two important class
definitions:

-   `Token` - This represents a token
    -   Complete with the token string itself, `token`. Retrivebale with
        a call to `getToken()`
    -   The coordinates in the source code where the token begins as
        `line` and `column`
    -   Overrides equality (`opEquals`) such that doing,

    ``` d
    new Token("int") == new Token("int")
    ```

    -   ...would evaluate to `true`, rather than false by reference
        equality (the default in D)
-   `Lexer` - The token builder
    -   `sourceCode`, the whole input program (as a string) to be
        tokenized
    -   `position`, holds the index to the current character in the
        string array `sourceCode`
    -   `currentChar`, the current character at index-`position`
    -   Contains a list of the currently built tokens, `Token[] tokens`
    -   Current line and column numbers as `line` and `column`
        respectively
    -   A "build up" - this is the token (in string form) currently
        being built - `currentToken`

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
    -   Returns `true` if there is a token currently built
        i.e. `currentToken.length != 0`, `false` otherwise.
2.  `isBackward()`
    -   Returns `true` if we can move the character pointer backwards,
        `false` otherwise.
3.  `isForward()`
    -   Returns `true` if we can move the character pointer forward,
        `false` otherwise.
4.  `isNumericalStr()`
    -   This method is called in order to chck if the build up,
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
`\texttt{;}`{=tex} `\texttt{,}`{=tex} `\texttt{(}`{=tex} `\texttt{)}`{=tex} `\texttt{[}`{=tex} `\texttt{]}`{=tex} `\texttt{+}`{=tex} `\texttt{-}`{=tex} `\texttt{/}`{=tex} `\texttt{\%}`{=tex} `\texttt{*}`{=tex} `\texttt{\&}`{=tex} `\texttt{\{}`{=tex} `\texttt{\}}`{=tex}

• `\texttt{=}`{=tex} \| (TODO: make it
texttt) \\texttt{\^} `\texttt{!}`{=tex} `\texttt{\\n}`{=tex}(TODO:
`\n `{=tex}not
appearing) \\texttt{\~} `\texttt{.}`{=tex} `\texttt{\:}`{=tex}

Whenever this method returns `true` it generally means you should flush
the current token, start a new token add the offending spliter token and
flush that as well.

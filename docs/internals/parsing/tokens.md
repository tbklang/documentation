Tokens
======

## Introduction

The first important thing a parser needs to be able to do before it can start creating new structures and manipulating existing strucrure is to be able to move back and forth in the token stream. The reasons that one may want to move backwards will become apparent later but surely one can easily understand why the ability to check if there are any tokens available, retreiving the current token and moving to the next would make sense.

## I/O

The `Parser` class provides the following methods:

1. `getCurrentToken()`
    * The returns an object of type `Token`
    * It does not advance the cursor
    * It returns the token at the current index of the `Token[]` using `tokenPtr`
2. `nextToken()`
    * This advances the integer `tokenPtr`
    * _"Goes"_ to the next token
3. `previousToken()`
    * This decrements the integer `tokenPtr`
    * _"Goes"_ to the previous token
4. `hasTokens()`
    * This checks if we have not consumed all tokens already
    * Returns `true` if not, `false` if so

As you can see from above the token I/O system is relatively simple. All we are doing is accessing `tokens[tokenPtr]` (the `tokens` aray at position/index `tokenPtr` by using the above functions) and also making sure we are not running out either.

> **Note**: Currently there is no automatic bounds checking whenever `getCurrentToken()` is called, hence one must do the checks oneself, this will be added in the very VERY near future (such that an exception will be thrown). We do use `hasTokens()` in some loops but it should be used everywhere
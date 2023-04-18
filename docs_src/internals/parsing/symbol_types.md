Symbol types
============

The token stream is effectively a list of instances of `Token` which consist just of the token itself as a string and the coordinates of the token (where it occurs). However, some tokens, despite being different strings, can be of the same type or syntactical grouping. For example one would agree that both tokens `1.5` and `25.2` are both different tokens but are both floating points. This is where the notion of symbol types comes in.

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
assert(symType == SymbolType.NUMBER_LIETRAL);
```

This assertion would pass as the symbol type of such a token is a number literal.
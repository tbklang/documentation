## Literals

TODO: Add this section

### String literals

TODO: Add this

#### Concatenation

String literal concatenation allows two strings literals, at compile-time, to be joined
together to a _single_ string literal. This operation is done by placing the two literals
next to one another as follows:

```d
ubyte* myName = "Tristan" " Velloza Kildaire";
```

The compiler will process this into a new _string expression_ in the form of "Tristan Velloza Kildaire",
therefore making it semantically the same as if you had rather done:

```d
ubyte* myName = "Tristan Velloza Kildaire";
```
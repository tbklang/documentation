## Comments

T supports two types of comments, these are described below.

### Single-line comments

Single-line comments can only span a line, one declares such a comment with the symbol `//` followed by arbitrary text as follows:

```{.d}
//This is a comment
// // This is also a Comment
//This too
```

### Multi-line comments

Multi-line comments can span multiple lines but may not contain the `/*` or `*/` symbols are these, as you shall see, demarcate the beginnings and endings of multi-line comments:

```{.d}
/* This is
A
        multi-line
            comment
*/
```
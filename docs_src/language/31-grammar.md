## Grammar

The grammar for the language is still a work in progress and may take some time to
become concrete but every now and then I update this page to add more to it or fix
any incongruencies with the parser's actual implementation. The grammar starts from
the simplest building blocks and then progresses to the more complex (heavily composed)
ones and these are placed into sections whereby they are related.

**TODO:** Finish implementing this

### Literals

These make are the basic atoms that define literals.

**TODO:** Finish enumerating all numbers

```
letter    ::= "A" | "B" | "C" | "D" | "E" | "F" | "G" | "H" | "I" | "J" | "K"
            | "L" | "M" | "N" | "O" | "P" | "Q" | "R" | "S" | "T" | "U" | "V"
            | "W" | "X" | "Y" | "Z" | "a" | "b" | "c" | "d" | "e" | "f" | "g"
            | "h" | "i" | "j" | "k" | "l" | "m" | "n" | "o" | "p" | "q" | "r"
            | "s" | "t" | "u" | "v" | "w" | "x" | "y" | "z";
number    ::= "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" | "0";
```

### Expressions

Expressions come in many forms and are defined here.

```
expr      ::= literal | binop | unaryop | parens;

parens    ::= "(", expr, ")";

infix     ::= "+" | "-" | "*" | "-";
prefix    ::= "*" | "&";
binop     ::= expr, operator, expr;
unaryop   ::= prefix, operator;

(* TODO: Below EBNF isn't right, I am not sure how to write it *)
funccall  ::= ident, "(", ([expr], { expr, ","}), ")";
```

**TODO:** Add `|`, `&` (infix), `&&` and `||` operators support first before adding them here

### Statements

Statements are inevitably the building blocks of a program and make
use of all the former defined sections of the grammar and more of
themsleves in some cases as well.

```
statement ::= discard | decl;







discard   ::= "discard", expr ;

ident     ::= letter | { letter | number };
decl      ::= type, identifier, [assign], ";";
type      ::= "int" | "uint" | ident;
assign    ::= "=", expr;


if        ::= "if", "(", expr, ")", "{", { statement }, "}",
             [ { "else", if } | ( "else", "{", { statement }, "}") ];

while     ::= "while", "(", expr, ")", "{", { statement }, "}";
```
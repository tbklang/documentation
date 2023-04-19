## Grammar

The grammar for the language is still a work in progress and may take
some time to become concrete but every now and then I update this page
to add more to it or fix any incongruencies with the parser's actual
implementation. The grammar starts from the simplest building blocks and
then progresses to the more complex (heavily composed) ones and these
are placed into sections whereby they are related.

**TODO:** Finish implementing this

### Literals

These make are the basic atoms that define literals.

    letter    ::= "A" | "B" | "C" | "D" | "E" | "F" | "G" | "H" | "I" | "J" | "K"
                | "L" | "M" | "N" | "O" | "P" | "Q" | "R" | "S" | "T" | "U" | "V"
                | "W" | "X" | "Y" | "Z" | "a" | "b" | "c" | "d" | "e" | "f" | "g"
                | "h" | "i" | "j" | "k" | "l" | "m" | "n" | "o" | "p" | "q" | "r"
                | "s" | "t" | "u" | "v" | "w" | "x" | "y" | "z";
    number    ::= "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9";

    float     ::= (number | {number}), ".", (number | {number});

### Expressions

Expressions come in many forms and are defined here.

    expr      ::= literal | binop | unaryop | parens;

    literal   ::= number | float;

    parens    ::= "(", expr, ")";

    infix     ::= "+" | "-" | "*" | "-";
    prefix    ::= "*" | "&";
    binop     ::= expr, operator, expr;
    unaryop   ::= prefix, operator;

    exprList  ::= [expr] | (expr, {",", expr});

    funccall  ::= ident, "(", exprList, ")";

**TODO:** Add `|`, `&` (infix), `&&` and `||` operators support first
before adding them here

### Statements

Statements are inevitably the building blocks of a program and make use
of all the former defined sections of the grammar and more of themsleves
in some cases as well.

    module    ::= "module", ident, ";", {decl};
    decl      ::= vdecl | funcDecl;



    statement ::= discard | vdecl;







    discard   ::= "discard", expr, ";";

    ident     ::= letter | { letter | number };
    vdecl     ::= type, identifier, [assign], ";";
    type      ::= "int" | "uint" | ident | ptrType;
    ptrType   ::= type, "*";
    assign    ::= "=", expr;


    parmList  ::= [type, ident] | {(type, ident), ","};
    funcdecl  ::= type, identifier, "(", parmList, ")", "{", {statement}, "}";


    if        ::= "if", "(", expr, ")", "{", { statement }, "}",
                 [ { "else", if } | ( "else", "{", { statement }, "}") ];

    while     ::= "while", "(", expr, ")", "{", { statement }, "}";

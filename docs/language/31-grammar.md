## Grammar

The grammar for the language is still a work in progress and may take
some time to become concrete but every now and then I update this page
to add more to it or fix any incongruencies with the parser’s actual
implementation. The grammar starts from the simplest building blocks and
then progresses to the more complex (heavily composed) ones and these
are placed into sections whereby they are related.

**TODO:** Finish implementing this

### Comments

These are the basic types of comments supported.

    (* TODO: I need to define all symbols as well so we can get this right *)
    (* As I don't like the ?-based special sequence *)
    singleComment  ::= "//", { anything };

    anything       ::= ? all ASCII characters excluding newline ?

### Literals

These make are the basic atoms that define literals.

    letter     ::= "A" | "B" | "C" | "D" | "E" | "F" | "G" | "H" | "I" | "J" | "K"
                | "L" | "M" | "N" | "O" | "P" | "Q" | "R" | "S" | "T" | "U" | "V"
                | "W" | "X" | "Y" | "Z" | "a" | "b" | "c" | "d" | "e" | "f" | "g"
                | "h" | "i" | "j" | "k" | "l" | "m" | "n" | "o" | "p" | "q" | "r"
                | "s" | "t" | "u" | "v" | "w" | "x" | "y" | "z";

    digit      ::= ("0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9")

    number     ::= digit {(digit | underscore)} ["." digit {(digit | underscore)}] [encoder]

    encoder    ::= "S" | "B" | "W" | "I" | "L" | "UB" | "UW" | "UI" | "UL" | "SB"
                  "SW" | "SI" | "SL";

    underscore ::= "_"

### Expressions

Expressions come in many forms and are defined here.

    expr      ::= literal | binop | unaryop | parens | ident;

    literal   ::= number | float;

    ident     ::= letter | { letter, number };

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
of all the former defined sections of the grammar and more of themselves
in some cases as well.

    module    ::= "module", ident, ";", {decl, ";"};
    decl      ::= vdecl | funcDecl;



    statement ::= discard | vdecl;



    comment   ::= singleComment | multiComment;



    discard   ::= "discard", expr, ";";


    vdecl     ::= type, identifier, [assign], ";";
    type      ::= "int" | "uint" | ident | ptrType;
    ptrType   ::= type, "*";
    assign    ::= "=", expr;


    parmList  ::= [type, ident] | {(type, ident), ","};
    funcdecl  ::= type, identifier, "(", parmList, ")", "{", {statement, ";"}, "}";


    if        ::= "if", "(", expr, ")", "{", { statement }, "}",
                 [ { "else", if } | ( "else", "{", { statement, ";" }, "}") ];

    while     ::= "while", "(", expr, ")", "{", { statement, ";" }, "}";

    (* TODO: Check if the below is correct actually *)
    for       ::= "for", "(", statement, ";", expr, ";", statement, ")", "{", {statement, ";"}, "}";

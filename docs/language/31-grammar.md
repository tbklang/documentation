## Grammar

* TODO: Need help with this @Wilhelm, some things to look at (must reference!)
    * https://karmin.ch/ebnf/examples

```

statement := discard | todo
expr      := literal | binop
binop     := expr operator expr
discard   := "discard" expr ;
oparen    := "("
cparen    := ")"
ocurly    := "{"
ccurly    := "}"
if        := "if" oparen expr cparen ocurly { statement } ccurly {"else" if } | "else" { statement }
```



!!! error
	A formal grammar does not yet exist, _however_, it is currently in the works and will be available by year end.
## Meta processor

The _meta processor_ is a mechanism that acts somewhat like a _shim_ (something you shove inbetween two things) between the _parser_ and the _typechecker_. Therefore because the parser provides us with an AST tree rooted in a `Module` of which is then passed to the type checker it would imply that the place where the meta processor fits in is something that _consumes the AST tree_, applies manipulations to its nodes or completely replaces some, and then finally returns to let the type checker begin its process.


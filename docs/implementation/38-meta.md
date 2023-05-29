## Meta processor

The *meta processor* is a mechanism that acts somewhat like a *shim*
(something you shove inbetween two things) between the *parser* and the
*typechecker*. Therefore because the parser provides us with an AST tree
rooted in a `Module` of which is then passed to the type checker it
would imply that the place where the meta processor fits in is something
that *consumes the AST tree*, applies manipulations to its nodes or
completely replaces some, and then finally returns to let the type
checker begin its process.

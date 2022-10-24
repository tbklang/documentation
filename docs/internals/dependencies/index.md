Dependency generation
=====================

Once we have finished creating an in-memory representation of the program via
prasing its source code we then need to make semantic sense of the program.

The process is split up into two parts which result in a form that the next
stages, [type checking](/interals/typechecking/) and [code generation](/internals/codegen/), can make sensible use of.
These stages are the following:

1. [Dependency generation]()
1. [Dependency linearization]()
## Meta processor

The _meta processor_ is a mechanism that acts somewhat like a _shim_ (something you shove in-between two things) between the _parser_ and the _typechecker_. Therefore because the parser provides us with an AST tree rooted in a `Module` of which is then passed to the type checker it would imply that the place where the meta processor fits in is something that _consumes the AST tree_, applies manipulations to its nodes or completely replaces some, and then finally returns to let the type checker begin its process.

Examples of things which require AST manipulation are:

1. Type aliases
    * `size_t` and `ssize_t` need to be resolved to their concrete types
2. Macros
    * Macros such as `sizeof(<type>)` need to be replaced with a `NumberLiteral` with the value that is equal to the bit-width (in bytes) of the type `<type>`

### Meta API

There are some core interfaces which various `Statement`(s) (parser nodes) can implement in order to be able to be manipulated by the meta-processor, we describe these in this section. These are all defined in `source/tlang/compiler/symbols/mcro.d`.

#### the `MStatementSearchable`

Anything which implements this has the ability to search for objects of the provided type, and return a list of them.

TODO: Method table (required methods to implement)

|   Method name            | Return type   | Description                                                                           |
|--------------------------|---------------|---------------------------------------------------------------------------------------|
| `search(
TypeInfo_Class
)`   | `Statement[]` | Searches for all objects of the given type and returns an array of them. Only if the given type is equal to or sub-of `Statement` |

TODO: Add an example of it being used here please

#### the `MStatementReplaceable`

Anything which implements this has the ability to, given an object `x`, return a `ref x` to it hence allowing us to replace it.

**FIXME:** This description is wrong and wrong in the code, no more `ref` stuff is ysed AT ALL, and hasn't been for a long time anyways, so that comment needs to get updated

|   Method name                   | Return type   | Description                                                                                     |
|---------------------------------|---------------|-------------------------------------------------------------------------------------------------|
| `replace(
    Statement,
    Statement)`  | `bool`        | Replace a given `Statement` (the first argument) with another `Statement` (the second argument), returns `true` if the replacement is successful, `false` otherwise |

TODO: Add an example of it being used here please

#### the `MTypeRewritable`

TODO: Description

|   Method name      | Return type   |     Description                             |
|--------------------|---------------|---------------------------------------------|
| `getType()`        | `string`      | Gets this entity's type                     |
| `setType(string)`  | `void`        | Sets this entity's type to the provided one |

TODO: Add an example of it being used here please

#### the `MCloneable`

**NOTE:** This one isn't even used yet anywhere that I know of, hence do not document yet

Anything which implements this can make a full deep clone of itself.

|   Method name    | Return type  |     Description                             |
|------------------|--------------|---------------------------------------------|
| `clone()`        | `Statement`  | Returns the deeply cloned `Statement`       |

TODO: Add an example of it being used here please


### the `MetaProcessor`

The `MetaProcessor` is the actual processing facility which can apply different types of AST manipulations to a given `Container`. It is run prior to type checking but after parsing. This makes sense as we want to do AST node manipulation _just_ after the parse tree has been constructed, then we can pass the changed program to the `TypeChecker` and it wouldn't know any different. For all the type checker knows, this is just the original program.


TODO: Document me



|   Method name    | Return type  |     Description                             |
|------------------|--------------|---------------------------------------------|
| `clone()`        | `Statement`  | Returns the deeply cloned `Statement`       |
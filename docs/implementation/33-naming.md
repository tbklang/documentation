## Naming

TODO: Insert things here about collision detection etc. (TODO: yeah,
later)

Once we have finish parsing we will effectively have a relationship
present between the AST nodes. The outermost `Container`-based node, the
*module* has a list of children AST nodes in it. This is in the form of
a `Statement[]`, one can imagine that you could loop through this array
to find a particular AST node of interest. These *statements* will be of
various different types, some will also implement the `Container`
interface, think of a class declared within a module, *that’s a a
container **in** another container*, meaning one could recurse down it.

Where does naming come into this whole picture though? That’s where we
look at the the `Entity`-type of AST nodes. These are effectively any
sort of *statement* which has a **name** associated with it. If we
combine the aforementioned recursive nature of traversing the AST tree
with name matching we can effectievly build a name-based lookup system
such that given any name we can look it up.

TODO: Add diagram in moleskin here

### The resolver

After we have parsed the tokens into a `Module`, this is passed to a new
instance of the `TypeChecker` (which you will read about next) but prior
to starting that process a new `Resolver` is created which takes in the
`TypeChecker` so it can access the `Module`. It then has the ability to
use this to do its resolution.

Before we get into how it all works let’s first see the API offered to
us by the resolver (in `source/`):

| Method name                                | Return type | Description                                                                           |
|--------------------------------------------|-------------|---------------------------------------------------------------------------------------|
| `generateNameBest(     Entity)`            | `string`    | Given an `Entity` this will return the absolute path to it                            |
| `generateName(     Container,     Entity)` | `string`    | Returns the path of the `Entity` relative to the `Container`                          |
| `isDescendant(     Container,     Entity)` | `bool`      | Checks if the given `Entity` can be found *somewhere* within the provided `Container` |

## Naming

TODO: Insert things here about collision detection etc.

Once we have finish parsing we will effectively have a relationship present between the AST nodes. The outermost `Container`-based node, the _module_ has a list of children AST nodes in it. This is in the form of a `Statement[]`, one can imagine that you could loop through this array to find a particular AST node of interest. These _statements_ will be of various different types, some will also implement the `Container` interface, think of a class declared within a module, _that's a a container **in** another container_, meaning one could recurse down it.

Where does naming come into this whole picture though? That's where we look at the the `Entity`-type of AST nodes. These are effectively any sort of _statement_ which has a **name** associated with it. If we combine the aforementioned recursive nature of traversing the AST tree with name matching we can effectievly build a name-based lookup system such that given any name we can look it up.

TODO: Add diagram in moleskin here

### The resolver

TODO: Talk about this here
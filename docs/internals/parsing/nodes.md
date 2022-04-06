Nodes
====

A parse tree consists of _"nodes"_ which link to each other to form an acylic structure
known as a tree (you can see one [here](/internals/parsing/generation)). This page
focuses in on the types of nodes that are implemented in the reference compiler.

## Base node

At the top of the node type hierachy is that of the `Statement`. Every instance of a parse
tree node is a _kind of_ `Statement`. This holds a lot of important base information
that is simply common to every node. What follows is a UML diagram of the structure
and then following that a description of each component.

``` mermaid
classDiagram
	class Statement {
		+ulong weighting
	}

```

#### Weighting

Weights are applied to each type of node. This is more of a _per-type_ than a
_per-node instance_ type of thing. It is used to provide ordering to the different
T program constructs, such as ordering a class declaration before that
(TODO: check if that is the ordering) of a variable declaration _even_ when the
variable declaration appears _before_ the class definition in the source file.

(TODO: check if this is correct) The lower the weight, the higher the precedence.

!!! note

	**TODO**: CHeck does weighting affect node structure when? Like when is sorting called?
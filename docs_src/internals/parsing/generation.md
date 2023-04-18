Parser tree generation
======================

TODO: Descrive visitor stuff here, recursive functions

Simply is an organization of the source code into a
code/in-memory form.

#### Example program

```c
module moduleName;
int x = 21;
int y = x+1;
```

#### Parser tree

```mermaid
flowchart TD
	modName(moduleName moduleInit) ---> intXDec
	modName(moduleName moduleInit) ---> intYDec
	
	intXDec(int x varDNode) ---> intXVarAssign
	intYDec(int y varDNode) ---> intYVarAssign

	intXVarAssign(varAssign) ---> varAssignX21
	intYVarAssign(varAssign) ---> varAssignYBinOp

	varAssignX21(21 expressionEval)
	varAssignYBinOp(x+1 expressionEval) ---> xEvalForBinOp
	varAssignYBinOp(x+1 expressionEval) ---> expressionLiteral1

	expressionLiteral1(1 expressionEval)
```

As you can see no checks are being done, like on x’s existence
or declaration order. It is this tree that is ran through whilst
constructing the [_dependency tree_](/internals/deps/generation).
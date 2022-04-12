Todo
====

### Expression nodes

- [ ] Maybe don't have toString increment counter all the time
	- **Note:** Just for clarity, not a bug as nothing relies on this number
	- See the BinaryOperatorExpression below and you will witness that the numbers increment despite the expression *LHS* and *RHS* being the same in the left-hand side dependency and right-hand side dependency respectively
	- ![[Pasted image 20220412111848.png]]
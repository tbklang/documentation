Todo
====

# Parsing

### Unary operators

- [ ] Add support for `&` (pointer generation)
	- [ ] Must only allow a `SymbolType.IDENT_TYPE` to be followed
		- [ ] Only allow variable accesses
		- [ ] Function names
		- [ ] Disallow function _calls_
		- [ ] Implement `isExpressionName(Expr)` to allow recursion for cases like:
			- `&(name)`
			- `&((name))`



# Code gen and type checking


### Unary operators

- [ ] Add typechecking
	- [ ] Handle `-` and `+` as arithmetic
	- [ ] Handle `*` as a pointer
- [ ] Codegen
	- [ ] For `-` and `+` leave as is
	- [ ] For `*` maybe generate a pointer access
		- [ ] ~~We might want to check a `cast(PointerDerefExpression)` instead, **before** the `cast(UnaryOperatorExpression)` (as it will always be true irrespective of the first - for all unary operators that is)~~
		- [ ] Check `getSymbol()` and use that to differentiate between mathematical unary operators and unary operators
- [x] Disallow `/`
	- [x] Disallow this within the parser
	- Completed in commit `cc2cdf2c30576dc174a8ca850018c160cc5f0e33` on `compiler_levels` branch

### Expression nodes

- [ ] Maybe don't have toString increment counter all the time
	- **Note:** Just for clarity, not a bug as nothing relies on this number
	- See the BinaryOperatorExpression below and you will witness that the numbers increment despite the expression *LHS* and *RHS* being the same in the left-hand side dependency and right-hand side dependency respectively
	- ![[Pasted image 20220412111848.png]]
## Mixins and embeddings

Mixins and embeddings allow one to include arbitrary code in the form of a string
literal or an external file respectively.

### String-based

If you wanted to include the code contained in the string `"int j=2; "` in
your code such that it would be parsed into the tokens `[int, k, =, 2, ;]`
then you can do so using the `mixin()` keyword which takes in a string literal.

An example piece of code would be the following:

```{.d .numberLines}
module str;

void main()
{
	mixin("int j=2 ");

    int f = mixin("1+1");
}
```

Which, during parsing, effectively becomes converted to:

```{.d .numberLines}
module str;

void main()
{
    int j = 2;

    int f = 1+1;
}
```

### File-based

If you wanted to include code that is in a seperate file, for example, a file
placed at `source/tlang/testing/mixins/decl.txt` (relative to the directory
the compiler was instantiated in), could contain the following text:

```{.numberLines}
int j = 2
```

Then if we use the `embed()` keyword as follows with:

```{.d .numberLines}
module file;

void main()
{
	embed("source/tlang/testing/mixins/decl.txt");
}
```

When parsed our code will effectively become:

```{.d .numberLines}
module file;

void main()
{
    int j = 2;
}
```
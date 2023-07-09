documentation
=============

Official TLang documentation

## Usage

Clone the repository and try running:

```bash
mkdocs serve
```

In the root of the repository, if you get an error you will need to install some PIP dependencies.

## Contributing

If you would like to edit the documentation then please edit the files in `docs_src/` (and **NOT** in `docs/`). The former folder
is used for the base documentation files and the latter is the result of the post-processing needed to be applied to the Markdown
files before they can be used for generating the LaTeX-based book or the Mkdocs website.

Once you have finished making your changes in the files in `docs_src/`, please then run the post-processing script:

```bash
./makemarkdown.sh
```

This should produce an updated file in `docs/` with the same name as the one you edited in `docs_src/`, **commit BOTH files** please.

Then you're done!
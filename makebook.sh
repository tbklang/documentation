#!/bin/bash

internalsPaths="
docs/internals/lexing/*.md
docs/internals/parsing/*.md
docs/internals/dependencies/*.md
docs/internals/codegen/*.md
"

# Generates LaTeX book and PDF
function generateBook()
{
    # Run twice because latex
    pandoc --toc docs/00-bookindex.md docs/01-dedication.md docs/introduction/*.md docs/language/*.md docs/implementation/* -s -t latex --highlight-style kate
    pandoc --toc docs/00-bookindex.md docs/01-dedication.md docs/introduction/*.md docs/language/*.md docs/implementation/* -s -t latex --highlight-style kate | pdflatex > /dev/null
    mv texput.pdf book.pdf

}

# Generates a single page AsciiDoc document and converts to HTML then
function doAsciiDoc()
{
    pandoc --toc docs/00-bookindex.md docs/01-dedication.md docs/introduction/*.md docs/language/*.md docs/implementation/* -s -t asciidoc --highlight-style kate > book.ad
    asciidoc -d book book.ad 
    mv book.html tlang.html
}

generateBook
doAsciiDoc
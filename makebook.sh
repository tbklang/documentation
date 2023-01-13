#!/bin/bash

internalsPaths="
docs/internals/lexing/*.md
docs/internals/parsing/*.md
docs/internals/dependencies/*.md
docs/internals/codegen/*.md
"

pandoc --toc docs/00-bookindex.md docs/01-dedication.md docs/introduction/*.md docs/language/*.md docs/implementation/* -s -t latex --highlight-style kate

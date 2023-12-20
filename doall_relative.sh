#!/bin/bash

# Generate the graphs
bash makegraphs.sh

# Generate the website
python3 -m mkdocs build -d $1

# Generate the book
#bash makebook.s

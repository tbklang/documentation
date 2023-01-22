#!/bin/bash

# Generate the graphs
bash makegraphs.sh

# Generate the website
python3 -m mkdocs build -d /home/pi/HDD/projects/tlang

# Generate the book
bash makebook.s

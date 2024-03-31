#!/bin/bash
echo "Now starting entrypoint..."

cd docs/

echo "Converting markdown..."
./makemarkdown.sh

echo "Converting markdown... [done]"


echo "Build the website now..."
python3 -m mkdocs build -d /website
echo "Build the website now... [done]"

echo "Building book..."
./makebook.sh
./makebook.sh
echo "Building book... [done]"

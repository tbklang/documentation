# Documentation generation helpers

# Generates LaTeX book and PDF
function generateBook()
{
    # Run twice because latex
    pandoc -F pandoc-plot -M plot-configuration=pandoc-plot-book.conf -f markdown --top-level-division=part --number-sections --toc docs_src/00-bookindex.md docs_src/01-dedication.md docs_src/introduction/*.md docs_src/language/*.md docs_src/implementation/* \
    														 -s -t latex --highlight-style kate
    pandoc -F pandoc-plot -f markdown --top-level-division=part --number-sections --toc docs_src/00-bookindex.md docs_src/01-dedication.md docs_src/introduction/*.md docs_src/language/*.md docs_src/implementation/* \
    														 -s -t latex --highlight-style kate  | pdflatex > /dev/null
    mv texput.pdf book.pdf
}

# Copies across UML documents
function doUML()
{
	mkdir docs/uml
	umlPDFs=$(ls uml/*.svg)
	for uml in $umlPDFs
	do
		cp $uml docs/$uml
		echo "UML copy for '$uml'"
	done
}

# Generates updated markdown based on sources
function generateMarkdown()
{
    # Site docs
    #
    # Copied over
    siteDocs="$(ls docs_src/*.md) $(ls docs_src/journal/*) docs_src/logo.png"
    for doc in $siteDocs
    do
        echo "Converting markdown for doc '$doc'..."
        # pandoc -F pandoc-plot -M plot-configuration=pandoc-plot.conf -f gfm -t gfm "$doc" -o "docs/$(echo $doc | cut -b 9-)"

		dest_doc="docs/$(echo $doc | cut -b 9-)"
        echo "Destination is: $dest_doc"
        cp -r $doc $dest_doc

        echo "Converting markdown for doc '$doc'... [done]"
    done

    # Documentation docs
    #
    # From markdown, filtered through pandoc-plot, to markdown
    docs="$(ls docs_src/introduction/*.md) $(ls docs_src/language/*.md $(ls docs_src/implementation/*.md))"
    for doc in $docs
    do
        echo "Converting markdown for doc '$doc'..."

        outputFile="docs/$(echo $doc | cut -b 9-)"

        pandoc -F pandoc-plot -M plot-configuration=pandoc-plot.conf -f markdown -t gfm "$doc" -o "$outputFile"

        echo "$(cat $outputFile | sed -e s/docs\\//\\/projects\\/tlang\\//)" > "$outputFile"
        cat "$outputFile"
        # break

        echo "Converting markdown for doc '$doc'... [done]"
    done
}

# Generates a single page AsciiDoc document and converts to HTML then
function doAsciiDoc()
{
    pandoc -F pandoc-plot -M plot-configuration=pandoc-plot-book.conf -f markdown --top-level-division=part --number-sections --toc docs_src/00-bookindex.md docs_src/01-dedication.md docs_src/introduction/*.md docs_src/language/*.md docs_src/implementation/* -s -t asciidoc --highlight-style kate > book.ad
    asciidoc -d book book.ad 
    mv book.html tlang.html
}

# Generate graphs
function generateGraphs()
{
    circoGraphs="$(ls docs/graphs/*.circo)"
    for graph in $circoGraphs
    do
        cat $graph | circo -Tpng -o$graph.png
        cat $graph | circo -Tsvg -o$graph.svg
    done

    dotGraphs="$(ls docs/graphs/*.dot)"
    for graph in $dotGraphs
    do
        cat $graph | dot -Tpng -o$graph.png
        cat $graph | dot -Tsvg -o$graph.svg
    done
}

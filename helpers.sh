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

# Generates updated markdown based on sources
function generateMarkdown()
{
    # Site docs
    #
    # From GitHub flavored markdown, filtered through pandoc-plot, to GitHub flavored markdown
    siteDocs="$(ls docs_src/*.md)"
    for doc in $siteDocs
    do
        echo "Converting markdown for doc '$doc'..."
        # pandoc -F pandoc-plot -M plot-configuration=pandoc-plot.conf -f gfm -t gfm "$doc" -o "docs/$(echo $doc | cut -b 9-)"
        cp $doc "docs/$(echo $doc | cut -b 9-)"

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

        pandoc -F pandoc-plot -M plot-configuration=pandoc-plot.conf -f markdown -t markdown "$doc" -o "$outputFile"

        echo "$(cat $outputFile | sed -e s/docs//)" > "$outputFile"
        cat "$outputFile"
        # break

        echo "Converting markdown for doc '$doc'... [done]"
    done
    #pandoc -F pandoc-plot -f markdown --top-level-division=part --number-sections --toc docs/00-bookindex.md docs/01-dedication.md docs/introduction/*.md docs/language/*.md docs/implementation/* \
    #														 -s -t markdown --highlight-style kate -o /tmp/bruh.md


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

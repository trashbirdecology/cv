#!/bin/bash
# usage: ./build_ses.sh file.Rmd  -> file.pdf + file.docx
set -e
f=${1%.Rmd}; T=$(mktemp -d)
pandoc "$1" -f markdown -s -H ses_preamble.tex -o $T/r.tex
sed -i '/lmodern/d; s/\\usepackage{unicode-math}.*/\\usepackage{fontspec}/' $T/r.tex
(cd $T && xelatex -interaction=nonstopmode r.tex >/dev/null && xelatex -interaction=nonstopmode r.tex >/dev/null) || grep -E "^!" $T/r.log
cp $T/r.pdf "$f.pdf"
pandoc "$1" -f markdown -o "$f.docx" 2>/dev/null || true
echo "pages: $(pdfinfo "$f.pdf" | awk '/Pages/{print $2}')"

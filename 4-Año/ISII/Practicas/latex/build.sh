latexmk -pdf $1.tex
mv $1.pdf ../
mv $1.tex ../
rm $1.*
cd ..
mv $1.tex latex
cd latex

doc := main.tex

.PHONY : all
all :
	latexmk -pdf $(doc)

.PHONY : clean
clean :
	git clean -fX

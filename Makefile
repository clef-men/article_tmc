.PHONY : all
all :
	@ latexmk -pdf -interaction=nonstopmode main.tex

.PHONY : clean
clean :
	@ git clean -fX

.PHONY : all
all :
	@ latexmk -pdf -interaction=nonstopmode main.tex

.PHONY : clean
clean :
	@ git clean -fX

# All this stuff belows assumes that the benchmark data has already
# been produced in the map-microbenchmarks/ subdirectory,
# see map-microbenchmarks/Makefile for more information.
#
# (The logic is roughly split as follows:
#  - map-microbenchmarks/ lets you run and visualize the result,
#    independently from anything LaTeX-related;
#  - the present makefile rules are for the hacks to turn these .svg
#    into LaTeX
# )

plots/core_bench.%.txt: map-microbenchmarks/data/core_bench.%.txt
	cp $< $@

.PHONY: plots-data
plots-data: plots/core_bench.4.txt plots/core_bench.5.txt

plots/plot.%.svg: map-microbenchmarks/data/plot.%.svg
	cp $< $@

plots/plot.%.pdf: plots/plot.%.svg Makefile
	inkscape -D $< -o $@ --export-latex
	# this creates both a .pdf and a .pdf_tex file
	# remove some unicode characters that pdflatex does not support
	sed -i 's/1000000/$$10^6$$/g' $@_tex
	sed -i 's/100000/$$10^5$$/g' $@_tex
	sed -i 's/10000/$$10^4$$/g' $@_tex
	sed -i 's/5×/5$$\\times$$/g' $@_tex

.PHONY: plots
plots: plots/plot.4.pdf plots/plot.5.pdf

CHECK := $(shell ls *.tex \
  | grep -vw -e "\(macros\|iris\|listings\)")

.PHONY: check
check:
	@ for f in $(CHECK) ; do \
	  aspell --mode=tex --lang=en_US --encoding=utf-8 \
	         --home-dir=. --personal=.aspell.en.pws \
	         check $$f ; \
	done

LATEXDIFF=latexdiff --allow-spaces --type=CCHANGEBAR --config "PICTUREENV=(?:(?:picture[\w\d*@]*)|(?:tikzpicture[\w\d*@]*)|(?:DIFnomarkup)|(?:mathpar)|(?:mathline)|(?:verbatim)|(?:tabular)|(?:figure)|(?:thebibliography))" --exclude-safecmd="ocaml"

.PHONY: diff.tex
diff.tex:
	if [ ! -d old-version ]; then git clone . old-version; fi
	cd old-version; git checkout popl25-submission
	$(LATEXDIFF) main.tex ./old-version/main.tex --flatten > diff.tex

diff.pdf: diff.tex
	latexmk -pdf -interaction=nonstopmode --bibtex diff.tex

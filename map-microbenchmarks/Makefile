.PHONY: pdf
pdf: data/plot.4.pdf data/plot.5.pdf

QUOTA=200ms

.PHONY: run4 run5
run4:
	set -x
	(cd ocaml4; dune build --root=. --profile=release)
	# notice that we use 'ulimit -s unlimited' to remove the native call stack limit
	# without it, the benchmark would crash on a Stack_overflow exception.
	(cd ocaml4; ulimit -s unlimited; ulimit -s; dune exec --root=. --context 4.14.0 --profile=release -- \
	 ./bench.exe -ascii -quota $(QUOTA)) | tee data/core_bench.4.txt
run5:
	set -x
	(cd ocaml5; dune build --root=. --profile=release)
	(cd ocaml5; dune exec --root=. --context=5.1.0 --profile=release -- \
	 ./bench.exe -ascii -quota $(QUOTA)) | tee data/core_bench.5.txt

data/results.%.txt: data/core_bench.%.txt
	(cd report; dune exec --root=. -- ./report.exe) < $< > $@

data/plot.%.svg: data/results.%.txt
	gnuplot \
	 -e 'set output "$@"' \
	 -e 'source="$<"' \
	 graph.gnuplot

.PHONY: view4 view5
view4: data/plot.4.svg
	ristretto $<
view5: data/plot.5.svg
	ristretto $<

.PHONY: clean
clean:
	(cd ocaml4; dune clean)
	(cd ocaml5; dune clean)
	(cd report; dune clean)
	rm -f data/results.[45].txt data/plot.[45].svg

.PHONY: pdf
pdf: data/plot.4.pdf data/plot.5.pdf

QUOTA=200ms
VIEWER=ristretto

# This Makefile is intentionally *not* written as a single full
# pipeline that runs the benchmarks and produces nice output, because
# the benchmarks are too long to run for this workflow to be pleasant
# in practice.
#
# You should
# - run `make run4`, `make run5` manually to run the benchs
#   this will save the benchmark data in readable textual format in
#   data/core_bench.{4,5}.txt
# - once you have the benchmark data, run `make svgs` to produce graphs,
#   and `make view4`, `make view5` to view them
#
# Use `make run4 QUOTA=5ms` for longer-running bench, less noise.
# Use `make view VIEWER=foo` is your svg viewer is the program 'foo'


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

data/plot.%.svg: data/results.%.txt graph.gnuplot
	gnuplot \
	 -e 'set output "$@"' \
	 -e 'source="$<"' \
	 graph.gnuplot

.PHONY: svgs
svgs: data/plot.4.svg data/plot.5.svg

.PHONY: view4 view5
view4: data/plot.4.svg
	$(VIEWER) $<
view5: data/plot.5.svg
	$(VIEWER) $<

.PHONY: clean
clean:
	(cd ocaml4; dune clean)
	(cd ocaml5; dune clean)
	(cd report; dune clean)
	rm -f data/results.[45].txt data/plot.[45].svg

Here are the changes that were proposed by our reviewers:

> Required revisions:
> 
>   include discussion of previous work on Scala
> 
> Recommended revisions:
> 
>   make it clearer in the paper why the TMC optimisation is an opt-in
>   implement the other improvements promised in the author response

Here is the list of notable changes we made so far.

## Required revisions

We include a discussion of the previous work on Scala/Oz, in section
9.1 (TMC support in compilers).

## Recommend revisions

In a new subsection 3.1.1, we explain why we implement TMC as an
opt-in optimization in OCaml, rather than opt-out.

## Other changes suggested by your reviews

We clarify that constructor compression is not formalized in the paper presentation, but that it is included in the mechanized development. (See the end of section 3.4.)

Note: we submitted an artifact to the Artifact Evaluation committee, that in particular contains a detailed description of the mapping from the paper claims to the Coq/Rocq mechanization.
  artifact: https://zenodo.org/records/13937565
  the detailed mapping: https://github.com/clef-men/camlcert/tree/popl2025?tab=readme-ov-file#link-to-the-popl25-publication

We explain (briefly) that List.map is a worst-case for TMC performance impact in the benchmark section (3.6).

Our discussion of the Koka related work mentions the relative gap in formality/precision of the two proofs. We contacted the authors of this paper to check that they are happy with the description of their work, and are working on their feedback and may iterate a bit during an eventual camera-ready preparation.

We tried to better explain the informal intuition under the formal statements in various places, as suggested by our reviewers. Notably:
- we explain in words the spec of map and map_dps on page 4
- we explain in words the similar spec of Section 4.2 on page 17
- we explain the BijInsert rule on page 17
- on page 18, when we introduce the relation judgment (es >= et <X> {Phi}),
  we give an informal intuition for what it means and explain that it is formally
  characterized in term of the simulation relation that is defined later
- we entirely rewrote the section on Simulation Closure to be clearer

In the related work, we more explicitly mention the potential usage of
our proof technique for compiler verification, and the interest in
trying to apply it (in Future work) in Compcert-inspired scenarios.


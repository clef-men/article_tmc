> POPL 2025 Paper #318 Reviews and Comments
> ===========================================================================
> Paper #318 Tail Modulo Cons, OCaml, and Relational Separation Logic
> 
> 
> Review #318A
> ===========================================================================
> 
> Overall merit
> -------------
> 2. Weak reject
> 
> Reviewer expertise
> ------------------
> 4. Expert
> 
> Paper summary
> -------------
> 
> The paper starts with a gentle, example-driven introduction to
> tailrecursion modulo cons (TMC). It then explains the
> contributions. This paper's main construction is the implementation of
> TMC (as a user triggerable optimisation) in the OCaml compiler, and
> the design choices and benchmarking to do with this implementation in
> the OCaml compiler. The second contribution is a correctness proof in
> Coq stating that the TMC optimisation does not change any observable
> behaviour of the program (including divergence etc).

> The proof was done in Simuliris, and might be the first code
> transforming function/relation to have been proved correct in
> Simuliris.

Our wording is defensive because it is difficult to be aware of all
publications and ongoing work on simulations in separation logic, but
our claim to novelty was recently confirmed on the (public) Iris
Mattermost communication platform by Robbert Krebbers, one of the Iris
maintainers. We quote the discussion:

> Abhishek Anand:
> [...]
> 2. is there some existing work using iris for formulating and proving correctness of compilers producing concurrent code?
>
> Michael Sammler:
> Regarding 2, the only work I know that uses Iris in a compiler proof is the code generation pass from DimSum (https://gitlab.mpi-sws.org/iris/dimsum/-/blob/master/dimsum_examples/compiler/codegen.v?ref_type=heads), but the setup there is quite non-standard (e.g. it does not use the standard wp, but is based on the "satisfiable" assertion and DimSum refinements). I am not sure if any of the approaches of proving refinements using Iris (e.g. ReLoC) has been used to verify a compiler.
>
> Robbert Krebbers:
> Re (2), indeed, I do not think any of the ReLoC or Simuliris variants have been used to verify a compiler. Only refinements of very tricky concrete programs.

(One can reasonably ask why using the same technique to study
a different object is a contribution in itself. We answer in our
presentation that this new, important application area revealed
expressivity limitations in Simuliris, and required our contribution
of an extension with abstract protocols, which are likely to be useful
to many other proofs and people.)

> Finally, this work in Simuliris, required the authors to extend
> Simuliris with support for user-specified different calling
> conventions (in order to manage TMC's destination-passing style).
> 
> Section 2 presents TMC on a idealised language that is intended for
> explaining TMC (and is quite close to the Coq formalisation). The
> language idealised in various ways, but particularly eye catching is
> that it has only pairs and cons cells and as a result only need
> indexing up to 2. TMC is modelled as an inductive relation which
> includes all possible TMC optimisations. This relation is realised as
> a function, i.e. a function has been defined which will only produce
> output that fits the relation.
> 
> Section 3 describes the implementation in the OCaml compiler. The user
> is given control over where TMC should be attempted through source
> level annotations. This part of the paper discusses some choices on
> where to apply the optimisation. It touches a tweak to the algorithm
> so that nested constructors don't create the code that comes out of
> a naive execution of the TMC transformation relation of
> Section 2. Section 3.3 points out that TMC is most naturally
> implemented as two passes.
> 
> The rest of the paper consist of shorter section. Section 4 gives
> a handwavy explanation of the specification of TMC. It uses notions of
> relational Hoare/separation logic without explaining what they
> mean. Section 5 outlines the rules of the relational separation
> logic. Section 6 describes how different calling conventions can be
> modelled as abstract protocols in the formalisation. Section
> 8 describes the soundness of the inference rules of the program logic.
> 
> The paper ends with an extensive and well written related work section.
> 
> Comments for authors
> --------------------
> 
> This paper is clearly on topic for POPL and the work itself
> (implementation of TMC in the OCaml compiler and a verification of an
> idealised version of the implementation) seem solid.
> 
> My main concerns with this paper are: (1) novelty and significance,
> and (2) my opinion that there is a nicer/neater way to formalise TMC.
> 
> Regarding (1):
> 
> - As the introduction clearly states, TMC has been implemented in many
>   systems before (from the 1970s onwards). It is perhaps not very well
>   known, but still it is far from new.
> 
> - The work by Daan Leijen and Anton Lorenzen published at POPL 2023
>   significantly diminishes the novelty/significance of this paper. It
>   is unfortunate for the authors of this submission that Leijen and
>   Lorenzen developed such a neat treatment of TMC in parallel to this
>   work.

We would distinguish several levels of rigour when presenting an
algorithm in scientific publications in a given domain:

1. Domain experts present their informal reasoning, their intution for
   the correctness of the algorithm.

2. A pen-and-paper mathematical proof.

3. A proof mechanized in a proof assistant.

Going from one level to the next is in general a significant
achievement, which can often justify a publication if it involves new
techniques or insights. (Sometimes we are lucky and it turns out to be
very easy, and then it's not clearly a contribution.)

We would argue that the Leijen and Lorenzen correctness argument is at
level "2-", in-between a pen-and-paper proof and an informal
argument -- it could be described as "mostly-formal". If it was fully
at level 2, then it should be easy to answer the following questions
about their proof:

- What is the correctness statement for the TMC transformation?

- What is the source and target language of the TMC transformation
  they prove correct?

- Are they pure or impure, do they support non-termination,
  non-determinism, mutable state?

  (All these sub-questions are important to understand if they can be
  considered to reasonably model a simplified fragment of OCaml.)

We claim that answering these questions about their soundness argument
is not at all obvious. Referring directly to their POPL papers
( https://dl.acm.org/doi/10.1145/3571233 ):

- The authors point out that they assume that terms are well-typed and
  never get stuck. This assumption is too strong to model OCaml or any
  other mainstream programming language (which are full of
  dynamic errors, except for proof assistants).

- Most of their proofs (sections 3 and 4) are conducted with respect
  to an equivalence relation defined on page 5, which is simply that
  the two terms reduce to the same value or both diverge: "either
  e1 →* v and e2 →∗ v, or both e1 ⇑ and e2 ⇑" This can only work in
  a pure calculus (for example, diverging terms that perform different
  side-effects should not be considered equivalent). This notion of
  equivalence cannot work in presence of side-effects, non-determinism
  or mutable state. They remark: "During reasoning, we often use the
  rule that when e2 is terminating, then (𝜆x.e1)e2 ≃ e1[x:=e2]".

  (In contrast, we (1) use untyped terms and show preservation of
  failure, (2) model a non-deterministic, stateful language, and we
  (3) use a standard notion of behavioral refinement that can scale to
  less idealized settings. All of these choices are important to claim
  relevance to practical instances of TMC in production programming
  languages, and they each make program reasoning sensibly more
  difficult.)

- Section 5.2 discusses how to realize linear contexts with in-place
  update, and it moves to an abstract machine with a heap and
  a term. In that setting the paper establishes equations that have
  been proven sufficient for soundness in previous sections, in the
  pure (but non-terminating) setting. It is not at all clear to us
  that the two parts of the argument can be rigorously combined to
  establish a complete result of correctness of TMC with imperative
  context updates.

In our opinion, the value of this independent discussion of TMC is in
providing a clear exposition of the TMC transformation, in a nice,
general conceptual setting that also encompasses many other variants
of the transformation. This is neat, and an excellent paper to read to
understand TMC. Presumably the authors chose to carefully balance the
amount of formal details and the clarity/intuitiveness of the
calculation they present, and favored clarity/simplicty overally. The
result is a useful contribution, but we would not consider it a fully
rigorous pen-and-paper proof of soundness of the TMC transformation,
and we believe that there is a large gap from their argument to
a proof that can be considered to model a relevant fragment of OCaml,
even just on paper. Providing a fully mechanized proof is yet another
level.

Note: there are of course other contributions in the Koka publication,
in particular their discussion of how to combine TMC with multishot
delimited continuations, which (is not relevant in our OCaml
setting and) is notable and of independent interest.

> - Part of this work has been published before. This raises the
>   question whether this submission has too much overlap with
>   a previous publication. The authors make good points in Appendix
>   A and I think it makes sense to combine the implementation (topic of
>   previous publication) with the correctness proofs (new to
>   this work). However, my opinion is that the new technical work of
>   this paper (and its presentation) needs to be at the level that
>   carries enough weight on its own to warrant publication at POPL. At
>   the moment it does not quite reach that level, see also (2).

We have a different opinion, we believe that publishing an early
version of our work in a workshop-level national venue should not
prevent a part of our contributions to be considered
(the implementation of TMC in OCaml and its evaluation – including an
evaluation of adoption that is entirely new in the current paper).

However, we claim that even according to the reviewer's stricter
standards, our submission carries enough weight to be presented at
POPL:

- this is the first rigorous proof of correctness of the TMC transformation
  that could scale to an impure programming language

- our proof is fully mechanized

- the proof technique (a relational separation program logic,
  justified by an adequate simulation) is novel for a compiler
  transformation, and required an extension of the state of the work
  on adequate simulations in Iris.

> Regarding (2):
> 
> - In my opinion, the approach taken in Leijen and Lorenzen in their
>   POPL 2023 paper is neater. Their notion of context with operations
>   comp and app seems cleaner and they have a nice separation of
>   concerns, where the algorithm-level reasoning can consider contexts
>   (data with a hole in it) and then the efficient implementation is
>   a separate concern that relies on the uniqueness of the context.
> 
> - I suspect that even a direct compiler proof might result in
>   a simpler presentation than the presentation given in this paper, if
>   one designs the semantics of the intermediate language carefully
>   enough. The compiler verification could be made fairly neat by using
>   mutable Leijen and Lorenzen inspired contexts in the store, and have
>   the intermediate language support efficient mutating comp and app
>   operations on such values. The intermediate language could have
>   a finalise operation that is implemented as a no-op, but, in the
>   semantics, copies the mutable value to an immutable value (such as
>   a normal list, tree etc.) and poisons the store locations where the
>   context was (making a program crash if one of its store location is
>   ever dereferenced, and thus meaning that a high-level proof suffices
>   to show that, even if such stray location could be around, they will
>   never be used). A separation logic enthusiast might say: but you
>   need to know that store locations for context are not shared/aliased
>   and separation logic is great for that! Yes, but it is actually
>   quite easy to state global properties as invariants in compiler
>   proofs, particularly if the intermediate language is designed with
>   this in mind.

It is difficult to comment on the reviewer's sketch for an entirely
different proof method -- maybe it would indeed be simpler,
but it seems hard to know without writing the details down. From
a distance, we can make the following comments:

- The code transformation we implemented in the OCaml compiler goes
  from the Lambda intermediate representation (IR) to itself, and this
  IR does not include TMC-specific constructs. We could use
  a TMC-specific IR as an intermediate step in the proof (present the
  work as two passes, one going to a TMC-specific IR and then
  a lowering back to the usual IR), but we would need to prove both
  steps correct, in particular a step that goes into a language
  without TMC-specific support.

- The more difficult/technical part of our work is to show that our
  program logic is sound. But this is a program logic for
  a TMC-independent IR. We could implement a variety of other
  optimizations on this IR and reuse the program logic -- in the paper
  we discuss inlining, and a few variants of TMC on integers. In
  particular, if someone tried to scale our methology
  (relational program separation logic) to a fully verified compiler,
  they would already have a program logic for their important IRs.

  So when we discuss the relative difficulty of proving TMC correct,
  we could compare the argument proposed by the reviewer with our
  proof of lemmas 7.1 and 7.2, which prove that the result of the TMC
  transform is related to its input by our program logic. And those
  proofs are, in fact, relatively simple -- about 300 lines of
  straight-line Coq code, which could be factorized further with more
  automation. It is a single induction that applies the relevant program
  logic steps in each case.

> Clarity of presentation:
> 
> Regarding presentation, the first half and the last two pages of this
> paper are a pleasure to read. The other parts leave some room for
> improvement, see the summary and minor comments.
> 
> Minor comments
> 
> Lines 183-184: at this point in the paper this syntax is a bit of
> a mystery. I can guess what it means but it's a little annoying that
> there isn't even a short explanation.
> 
> Line 268: you say the equality is untyped, that makes sense in
> a n untyped language, but you could also mention whether equality is
> recursive in some way and what happens when equality is applied to
> values of different "types", e.g. "1" and "true".
> 
> Line 371: "e_s ~~> d_t" -- perhaps you mean "e_s ~~> e_t"
> 
> Line 375: same as above
> 
> Line 423: punctuation "argument. passing"
> 
> Line 594: "some implementations" -- please provide references
> 
> Line 641: "consider this strange function: element in a list:"
> 
> Line 647: "would two location"
> 
> Line 661: It remains annoyingly unsaid whether this constructor
> compression fits neatly into the existing TMC transformation relation
> or whether the compression steps outside of that. If there is
> a comment about this later in the paper, then please provide a forward
> reference here.

Constructor compression is outside the relation defined in
Section 2. It is not hard to extend the presentation to support it, we
would:
- index the dps transformation on a stack of constructor contexts
- change the DPSBlock[12] rules to push the block context into the stack
  in the recursive call, instead of creating a new destination right away
- add a new DPSCtxReify rule that turns a non-empty stack of contexts into
  a destination

This is exactly the approach we use in the Coq formalization, see
mechanization/theories/tmc_2/definition.v, where the inductive
relation `tmc_expr_dps` captures the rewrite relation
(with constructor compression), with a parameter of type `tmc_ctx`
represents the stack of constructor applications, as a list of context
frames.

We decided to not include this in the paper for reasons of space, but
we could present it in an appendix if the reviewer believes that it is
important to have it in LaTeX in addition to Coq. (We would welcome
feedback on this in the final review comments.)

> Line 769: "an assumed extension" -- what do you mean by "assumed" here?
> 
> Line 777: "the ready may" -- reader?
> 
> Line 793: it's frustrating that I don't know what this means. For
> example, I guess that the precondition applies to both expressions,
> which seems odd because
> 
> Line 822: "a source expression with a target expression under
> a postcondition" -- I wish the authors gave a definition of what this
> means.
> 
> Line 999: You claim that you prove the specification from Section 4 in
> this section, but the content of this section hardly suffices as
> a proof.

The full details of the proof are in the Coq formalization that
accompanies the article, was submitted as supplementary material, and
would of course be included along with the publication if it was
accepted.

We initially wrote a sketch of the proof in our early writings on this
work, but we found the result rather un-informative: it is an
induction, and each case is proved by a list of reasoning rules in the
program logic, which are the relatively obvious ones given the syntax
of the two terms to relate -- a domain expert could easily reconstruct
the full details from the presentation in the paper. The more
technical aspects of the proof are in the soundness argument and
adequacy for the program logic itself.

We believe that the limited space in the paper is better spent on
giving justifications, intuitions and examples than getting into the
technical aspects of the proof. On the other hand, we did make sure
that the paper presents the *statements* that we establish as
completely as possible, in particular the definition of the simulation
relation is given (and discussed) in full.

If the reviewer would like us to include more details on the proof, at
the cost of removing or shrinking some sections of the current paper,
we welcome specific feedback on what to complete and what to remove.

> Line 1026: You cite the Simuliris paper a few too many times. It's
> enough to cite it the first time Simuliris is mentioned.
> 
> Line 1144: "contibuations"
> 
> 
> 
> Review #318B
> ===========================================================================
> 
> Overall merit
> -------------
> 3. Weak accept
> 
> Reviewer expertise
> ------------------
> 4. Expert
> 
> Paper summary
> -------------
> 
> This paper presents a program optimization called tail modulo
> constructor (TMC) transformation that brings the benefits of tail
> recursion to situations where the tail position is a sequence of
> constructor applications around a recursive call. The paper describes
> the OCaml implementation of this transformation, specifies the
> transformation, and proves it correct using Coq + Iris, extending the
> Simuliris approach to support alternative calling conventions.
> 
> Comments for authors
> --------------------
> Strengths:
> 
> + The presented optimization is undoubtedly useful across a broad range of use cases. 
> 
> + The correctness proof using Iris is solid and the paper presents
>   solid insights into how to use Iris for similar correctness proofs.
> 
> + The related work and prior work is described fairly.
> 
> Weaknesses:
> 
> - The empirical evaluation in Section 3.6 only considers the
>   performance of map. It would be nice to see a more wide-ranging
>   empirical evaluation.

For integration into OCaml, the important aspect to evaluate
experimentally was to see if we could match the performance of the
standard, non-tail-recursive version of a function with a TMC version
(unlike accumulator-passing versions which are notably slower). This
was a sticking point in the OCaml community, as the List.map function
from the standard library was kept non-tail-recursive for performance
reasons -- creating issues with stack overflows -- and switched to
a tail-recursive version thanks to our work.

To compare the performance of TMC with the non-tail-recursive version,
List.map is a worst case, because it performs almost no work except
for the recursive call and constructor application. (This assumes that
the mapped function is also fast, we used just an integer increment in
our benchmark for this reason.) If we compare a function that does
more work on each iteration, we will see smaller differences between
the various versions, as the recursive-call logic will take a smaller
portion of the runtime.

Does the reviewer has a specific question in mind that could be
answered by measuring the impact on other functions?

When adopting TMC in the standard library implementation, OCaml
maintainers benchmarked some of the modified functions to ensure that
the performance level was maintained, and they were able to generally
reproduce the results of List.map: adding one level of unfolding was
sometimes necessary to recover the same performance level as the
non-tail-recursive version, but the result behaves much better than
other tail-recursive implementations (see for example
https://github.com/ocaml/ocaml/pull/11402 and
https://github.com/ocaml/ocaml/pull/12869 ).

> - This paper contributes a definitive account of this optimization,
>   going beyond the prior publications on TMC for OCaml (as described
>   in the appendix), but given that TMC has already been introduced in
>   a number of prior languages, it isn't 100% clear to me that this
>   paper merits broader dissemination at POPL. I am leaning positive
>   due to the metatheoretic contributions of the paper but can't be
>   enthusiastic here.

Our impression is that POPL favours mathematically-rigorous
programming languages research, where algorithms proposed come with
a clear specification (what it means for them to be correct) and
a mathematical proof of correctness with respect to this
specification. There is very few prior work on TMC that passes this
bar; we don't know of any previous publication on providing a rigorous
specification for the TMC transformation except for the
Leijen&Lorenzen work, which happened in parallel to ours, and only
provides a mostly-formal correctness argument.

> Detailed comments:
> 
> - When describing the fields of memory blocks in the text at the
>   bottom of page 6, it would be good to mention how indices work
>   (the tag itself is the zeroth index).
> 
> - "we introduce a separate, deterministic block construction
>   [t, e1, e2] construction" -- "construction" is doubled here
> 
> - Is it only memory blocks that have unspecified evaluation order, or
>   also other n-ary constructs like field projection, assignment, etc?
> 
> - "Formally, the subset is determined by the domain..." -- the subset
>   of what? This part could be clearer.
> 
> - "the ready may" spelling
> 
> - Given the analysis in Section 3.2 and Section 4, why can't the OCaml
>   compiler apply this transformation automatically in some cases?
>   I understand there are subtleties to be analyzed in some cases, but
>   is there not a class where the optimization is obviously helpful?

There are at least two reasons why we are not in favor of applying the
optimization implicitly/automatically:

1. The transformation duplicates code, and it could in theory result
   in an exponential code size blowup when TMC-able functions are
   nested within each other. The opt-in approach keeps the code size
   increase to a minimum, to functions that the programmer considers
   important to optimize.
   
   We could of course rephrase the optimization to not duplicate code,
   by making the "direct-style" version a short wrapper that allocates
   an initial destination. But this means that the optimization can
   then introduce allocations where there previously were not, and
   some industrial OCaml users are very sensitive to the ability to
   control precisely where allocations happen, to avoid latency in
   certain critical sections.
   
2. The risk of regressions in user code would be significantly,
   significantly higher if we applied the transformation
   automatically. There are millions of lines of OCaml code out there,
   and we have no idea which portion would be transformed. Doing this
   implicitly would risk running into compile-time, runtime or
   correctness issues that we have not foreseen (we introduce a new
   non-trivial optimization pass, which may contain mistakes¹), it
   would have been much harder to convince OCaml maintainers to
   include this feature if it was opt-out.

¹: since its inclusion we did find one bug, where the TMC pass would
   generate wrong code in its interaction with the `try...with`
   construct.
   
After a few more years of experience of opt-in TMC in OCaml codebase,
we could possibly discuss enabling the transformation by default in
some cases, but we are not there yet. (The reviewer suggests that
maybe it could be automatically applied to only a subset of
optimizable function. One restriction we certainly want to have is
that we would only implicitly optimize constructor applications where
only the TMC-call argument can perform an observable side-effect --
all other arguments are syntactic values -- to guarantee that we do
not change the evaluation order of side-effects in the
transformed program.)
   
> - Line 647: "would two location and performs two writes" seems to be
>   missing some wors
> 
> - "constrast" spelling
> - "contibuations" spelling
> 
> - "John Clements’ work on stack-based security in presence of tail
>   calls" needs a citation
> 
> - many of the citations in the related work section are
>   mis-formatted -- they should use \cite rather than \citet
> 
> - "parametrize" spelling
> 
> 
> 
> Review #318C
> ===========================================================================
> 
> Overall merit
> -------------
> 3. Weak accept
> 
> Reviewer expertise
> ------------------
> 3. Knowledgeable
> 
> Paper summary
> -------------
> This paper presents a tail-recursion modulo cons optimization for OCaml, its implementation, and a mechanized proof of correctness of that transformation on simplified core language.
> 
> Comments for authors
> --------------------
> (I am reviewing this paper under the assumption that republication concerns do not apply)
> 
> Great:
> 
> - It's good to see a revival of TMC optimizations after 25 years of collective amnesia.
> 
> - There's a mechanized proof.
> 
> - The paper is quite readable.
> 
> Not so great:
> 
> - Even after reading the paper, I don't understand why TMC isn't done
>   automatically by the OCaml compiler when it's not ambiguous.  It
>   also seems limiting: for example, how can I tell OCaml that my
>   `filter` implementation, written as a `fold`, should be optimized?
>   The general fold cannot be optimized, but once specialized to
>   a specific function it often can.
> 
> - The formalization is based on a simplified model.  Could this proof
>   be done on top of CFML or Melocoton?

CFML can be used to prove the correctness of a given OCaml program by
computing a shallow embedding in Coq, so we could directly show the
specifications of destination-passing-style versions of select
programs. But it is not clear how it could be used to prove the
correctness of a program transformation, because it computes a shallow
embedding of each program.

Melocoton does not cover a large fragment of OCaml, it seems just as
simplified as our own language (it only contains pairs and not general
tuples, offers no built-in support for pattern-matching, etc.).

If we wanted to have a verified proof for a realistic language, we
could:

- Work within the CakeML project

- Scale our simplified IR to a larger fragment of the relevant OCaml
  intermediate representation, Lambda. One possible approach would be
  to reuse the formlization of Malfunction (a well-specified fragment
  of the Lambda IR) developped by the MetaCoq project to reason about
  extraction of Coq programs
  ( https://github.com/yforster/coq-verified-extraction/blob/coq-8.19/theories/Malfunction.v ).
  Their formalization lacks records/variants/blocks with mutable
  fields, but it has mutable arrays so the necessary building blocks
  are in place, and one could extend it and then define a separation
  program logic on top of it.

> - The formalization didn't give me a good sense of what bit of
>   reusable knowledge I should gain from it. It would help me to get
>   a clear statement of what is tricky about this proof.

We would emphasize two aspects:

1. Proving correctness of transformations of general recursive
   functions requires co-inductive reasoning, and this is hard -- both
   on paper and within a proof assistant. In the final presentation of
   our work, the coinductive reasoning is hidden in the proof of the
   "Simulation Closure" property, and so that part was fairly
   difficult to work out.
   
2. In general, working out adequate notions of simulation in Iris is
   hard. The paper only presents the final version that does work, and
   things may seem simple, but it is really non-trivial.
   
   Iris is pleasant to use to reason about impure programs because it
   provides powerful logical connectives (the "later" modality hide
   step-indexing, other modalities hide complex reasoning on state
   update, etc.). But one has to constantly ensure that definitions
   given in Iris have the sense we expect in a standard meta-theory,
   and it requires expertise and hard work. Simuliris did a lot of the
   hard lifting by providing a first adequate notion of simulation in
   Iris, and everyone that can reuse their work as-is benefits. We had
   to extend it to support relating functions with different calling
   conventions, this was "tricky", and many other people could reuse
   this contribution -- possibly with their own extensions.

> Other comments:
> 
> - I'm not sure whether using SimulIris for something it hadn't been
>   used for before really qualifies as a contribution.

Iris is ground-breaking because it makes reasoning on higher-order,
impure programs much, much easier than what we could do before. The
last decade has seen results proved using Iris that were out of reach
of the previous
seventy-pages-of-step-indexing-pen-and-paper-proofs-in-an-appendix
methology. But so far most successes of Iris have been in establishing
*unary* properties of a program -- it does not crash -- rather than
*binary* relations between programs -- they are equivalent.

There is little previous work on relational verification of program
transformations in Iris, and the approach in this previous work is to
use a *unary* program logic (the `wp` predicate in Iris) on the target
program, and only talk about the source program inside the pre- and
post-conditions. This is relatively simple if the source program is in
a pure language whose programs can be computed inside the logic, but
it is difficult to scale this approach to impure source languages --
see the related work of [Tassarotti, Jung, Harper, 2018], which relies
on subtle extensions to the Iris logic that have not been integrated
in the Iris mainline. Designing and justifying a program logic in this
style is very difficult, it requires substantial Iris expertise. In
contrast, designing a relational program logic justified by
a simulation relation is much easier, and the same notion of
simulation can be reused among many different languages, operational
semantics, and program logics. We believe that this approach can open
the door for notable progress on relation program verification for
impure higher-order languages. Demonstrating this technique, and
improving the Simuliris relation to enable it, is a contribution.

Today the standard approach in mechanized compiler verification
(eg. compcert) is to directly establish a Coq-level simulation between
the source and target programs, which can be very tedious. We believe
that adding Iris (or another powerful separation logic) into the mix
could provide noticeable benefits. We certainly do not claim to have
covered all aspects of compiler verification -- to test scalability
one would need to prove a lowering pass between languages with
different memory models -- but we believe that further work in this
promising direction could happen on top of our work, and in particular
benefit from our notion of abstract protocols.

> - TMC of a style very similar to that in this paper was implemented in
>   Scala about 10 years ago; it would be good to see a discussion
> 
>   - A new concurrency model for Scala based on a declarative dataflow
>     core. Sébastien Doeraene, Peter Van Roy.

We were not aware of this work, thanks! On first skim it appears based
in an implementation of Scala on top of the Oz virtual machine, which
presumably has the downside of coming with a significant performance
cost (compared to the usual JVM backend). Besides the obvious
engineering-effort differences, this approach is similar to our
discussion of Prolog in that it introduces "dataflow values" (an Oz
generalization of Prolog unification variables) pervasively in the
computation, which adds a noticeable constant-factor overhead.

> - Reading the proof, I wondered whether CPS conversion would be
>   a useful intermediate proof step.  Couldn't we see the process of
>   passing the destination as an optimization of passing a continuation
>   that writes to that destination?  Wouldn't that allow a refactoring
>   of the proof into two steps, one that is usual CPS and the other
>   that specializes to a specific kind of continuation and hence can
>   inline it?

As we briefly discussed in the Koka part of the Related Work, the
program transformation that one gets with this approach -- which is
close in spirit to the discussion in Minamide's 98 paper -- is not the
same as the one we propose, because a continuation (or a context with
a hole) is identified by *two* values, the continuation function
itself (or the pointer to the allocated constructor) and the place in
the continuation where its input is plugged (or the pointer to
the hole), whereas our destination-passing-style transformation only
propagates *one* value, the hole. To get our transformation, we would
need to follow the specialization of CPS with a third transformation,
that removes constant parameters from nests of recursive
functions. This is indeed a feasible approach, but it is unclear that
the proof would be simpler than our one-pass approach.

> Small things:
> 
> - I don't understand why the second version of the example program
>   (26-35) is given. Is it relevant to TMC?

I followed this suggestion and removed the "let y = f x in y :: map xs" version.

> - Missing citation for prolog TMC:
> 
>   - An improved Prolog implementation which optimizes tail
>     recursion. Warren, D. H. 1980. (although unfortunately this one
>     doesn't seem available online?)

I (Gabriel) do not want to cite a paper that I have not been able to
read. From the title it seems that this may be able tail-calls in
Prolog, which are not really related to the TMC transformation in
Prolog. In looking for this reference, I found a 1984 paper on TMC in
Prolog that might worth citing -- but then I'm not clear on the fact
that this is important, we don't mention all the papers that talk
about manual TMC transformation, we are trying to cite only the
historically older ones, why would the fact that it targets Prolog
make it any different?

The Prolog paper on TMC:

  Optimizing almost-tail-recursive prolog programs
  Saumya K. Debray
  FPCA 1985
  https://link.springer.com/chapter/10.1007/3-540-15975-4_38

> - Line 376, should it say `e_t`?

done

> - 587 isn't "non-determinism" a run-time notion?

clarified that this is about several possible transformation choices

> - 627 isn't it too bad that good performance should only be offered to
>   expert users?

We should discuss (probably at some other place) headfront why we made
TMC opt-in instead of opt-out.


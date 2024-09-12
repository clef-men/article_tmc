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
> behaviour of the program (including divergence etc). The proof was
> done in Simuliris, and might be the first code transforming
> function/relation to have been proved correct in Simuliris.  Finally,
> this work in Simuliris, required the authors to extend Simuliris with
> support for user-specified different calling conventions (in order to
> manage TMC's destination-passing style).
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
> 
> - Part of this work has been published before. This raises the
>   question whether this submission has too much overlap with
>   a previous publication. The authors make good points in Appendix
>   A and I think it makes sense to combine the implementation (topic of
>   previous publication) with the correctness proofs (new to
>   this work). However, my opinion is that the new technical work of
>   this paper (and its presentation) needs to be at the level that
>   carries enough weight on its own to warrant publication at POPL. At
>   the moment it does not quite reach that level, see also (2).
> 
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
> 
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
> 
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
> 
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
> 
> - This paper contributes a definitive account of this optimization,
>   going beyond the prior publications on TMC for OCaml (as described
>   in the appendix), but given that TMC has already been introduced in
>   a number of prior languages, it isn't 100% clear to me that this
>   paper merits broader dissemination at POPL. I am leaning positive
>   due to the metatheoretic contributions of the paper but can't be
>   enthusiastic here.
> 
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
>   
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
> 
> - The formalization didn't give me a good sense of what bit of
>   reusable knowledge I should gain from it.  It would help me to get
>   a clear statement of what is tricky about this proof.
> 
> Other comments:
> 
> - I'm not sure whether using SimulIris for something it hadn't been
>   used for before really qualifies as a contribution.
> 
> - TMC of a style very similar to that in this paper was implemented in
>   Scala about 10 years ago; it would be good to see a discussion
> 
>   - A new concurrency model for Scala based on a declarative dataflow
>     core. Sébastien Doeraene, Peter Van Roy.
> 
> - Reading the proof, I wondered whether CPS conversion would be
>   a useful intermediate proof step.  Couldn't we see the process of
>   passing the destination as an optimization of passing a continuation
>   that writes to that destination?  Wouldn't that allow a refactoring
>   of the proof into two steps, one that is usual CPS and the other
>   that specializes to a specific kind of continuation and hence can
>   inline it?
> 
> Small things:
> 
> - I don't understand why the second version of the example program
>   (26-35) is given. Is it relevant to TMC?
> 
> - Missing citation for prolog TMC:
> 
>   - An improved Prolog implementation which optimizes tail
>     recursion. Warren, D. H. 1980. (although unfortunately this one
>     doesn't seem available online?)
> 
> - Line 376, should it say `e_t`?
> 
> - 587 isn't "non-determinism" a run-time notion?
> 
> - 627 isn't it too bad that good performance should only be offered to
>   expert users?

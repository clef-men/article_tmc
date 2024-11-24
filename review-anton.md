> l. 272: “let y = fn x” but the function is called “f”

done

> l. 300: I first read “d_s . p_s” as a field access; a space might help here.
>   Similarly, I think this would be clearer with parens around the /\ term.

done

> l. 493: “transformatin”

done

TODO:
> l. 664: “we reify the current stack” — this was confusing to me at first;
>   you mean to say “we do not perform compression across if-statements“, right?
>
> Fig 9: This is figure unreadable in grayscale (eg. in print).
> 
> Fig 9: “Time relative to naive tail-recursive version”: This always struck
>   me as a weird measure; why don’t you use “nanoseconds per element”
>   or "total list elements processed in 5 seconds" to label the axis?
>   (In our POPL paper we keep the total number of elements processed in
>   the benchmark stable across all list sizes to achieve the same effect)
> 
> l. 1169: Sobel and Friedman should be cited in this context, but your
>   citation makes it seem like they wrote a TMC pass. Instead, their
>   technique is more similar to the accumulator-passing style.
> 
> l. 1183: "The start of the list remains constant over all recursive calls"
>   This is only true with linear continuations. In Koka, it can be necessary
>   to copy the list and then the start would change; this is the primary reason
>   why we do not perform that optimization.
> 
> l. 1189: "when use untyped terms"
> 
> —
> 
> l. 138: TMC was also implemented in OPAL (see bottom of page 11 of
> https://link.springer.com/chapter/10.1007/3-540-57840-4_34)
> 
> l: 165: There is also a large literature on verifying examples of TMC.
> Many projects verify imperative code that could have been the outcome
> of a TMC transformation using magic wands to represent
> destinations into which results are written. Arthur Charguéraud comes to
> mind (https://dl.acm.org/doi/10.1145/2854065.2854068), but also
> list segments (https://doi.org/10.1007/978-3-319-24953-7_7).
> Today, this technique seems standard and is mentioned eg. in the
> viper tutorial https://viper.ethz.ch/tutorial/#magic-wands
> where they verify the kind of `append` function that TMC produces.
> 
> l. 799: An interesting aspect of this is that TRMC can change the
> space usage of the program to the worse. 
> Of course, this does not happen in practice, since we also remove
> stack space and the extra increase in heap space is at most a few
> cells per eliminated function call. In https://dl.acm.org/doi/pdf/10.1145/3547634,
> we call an optimization “frame-limited” if its extra heap-space increase
> at any point during execution is a constant multiple of the number of
> stack frames at that point. As we briefly remark (page 10), this describes
> a space bound for TRMC if you consider the number of stack frames
> in the _unoptimised_ program (since TRMC also removes stack frames).
> 
> l. 962: “The APS transformation is a variant of the TMC transformation”.
> A view that I have found quite helpful is that APS and TMC are both
> instances of a selective CPS-transformation: what we really do in our
> POPL paper is to CPS-transform all recursive calls and then choose
> a better representation for the closures. Indeed, one way you can
> think of the example on line 587, is that you are performing a mini
> ANF-pass that moves tail-contexts out of constructors.
> 
> l. 1162: Recently, we have started to use “constructor contexts” in Koka,
> which are very similar to the linear functions of Minamide
> (https://dl.acm.org/doi/pdf/10.1145/3656398). However, we do not require
> a linear type system: The restriction that there can only be one hole
> in a constructor context is a simple syntactic restriction and if the
> constructor context is used more than once, we simply copy it (just as we
> already did in our implementation of TRMC). This is very convenient
> in practice, since it means that we can make many functions tail-recursive
> by hand, even if our TRMC transformation does not support them
> (eg. `partition`). In OCaml, constructor contexts could be implemented using
> the new modal uniqueness types (https://dl.acm.org/doi/pdf/10.1145/3674642).
> 
> Another interesting direction are constructor contexts with multiple
> holes. Thomas Bagrel wrote such a system for Haskell
> (https://inria.hal.science/hal-04406360/document) and sent an article
> to POPL, but I don’t know the outcome of that. Conor McBride has been
> thinking about these ideas for a while as well; with an incomplete draft
> at https://personal.cis.strath.ac.uk/conor.mcbride/pub/Holes/Holes.pdf
> which I believe inspired https://arxiv.org/pdf/1807.04085.
> 
> An interesting observation we made recently is that TMC can explain
> the top-down algorithms in imperative algorithm textbooks.
> While many textbooks present top-down insertion or deletion procedures
> from binary trees, it is unclear how to come up with them in the first place. 
> In https://dl.acm.org/doi/pdf/10.1145/3674642 we show that several
> classic top-down insertion algorithms on binary trees are the result
> of a TMC transformation from the obvious functional version
> (and then slightly optimized to reduce the number of assignments).
> As such, they can be shown equivalent to the functional version using the
> typical magic-wand based techniques in Iris (https://github.com/koka-lang/AddressC).

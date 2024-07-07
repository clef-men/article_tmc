GCC performs an accumulator-passing optimization where contexts are
affine functions (a + m*□). See gcc/tree-tailcall.c and in particular
the following comment:

https://gitlab.com/gnutools/gcc/-/blob/ce34fcc572a0dceebcffef76e98064546feebb38/gcc/tree-tailcall.cc#L47-105

```
   In addition to the standard tail recursion elimination, we handle the most
   trivial cases of making the call tail recursive by creating accumulators.
   For example the following function

   int sum (int n)
   {
     if (n > 0)
       return n + sum (n - 1);
     else
       return 0;
   }

   is transformed into

   int sum (int n)
   {
     int acc = 0;

     while (n > 0)
       acc += n--;

     return acc;
   }

   To do this, we maintain two accumulators (a_acc and m_acc) that indicate
   when we reach the return x statement, we should return a_acc + x * m_acc
   instead.  They are initially initialized to 0 and 1, respectively,
   so the semantics of the function is obviously preserved.  If we are
   guaranteed that the value of the accumulator never change, we
   omit the accumulator.

   There are three cases how the function may exit.  The first one is
   handled in adjust_return_value, the other two in adjust_accumulator_values
   (the second case is actually a special case of the third one and we
   present it separately just for clarity):

   1) Just return x, where x is not in any of the remaining special shapes.
      We rewrite this to a gimple equivalent of return m_acc * x + a_acc.

   2) return f (...), where f is the current function, is rewritten in a
      classical tail-recursion elimination way, into assignment of arguments
      and jump to the start of the function.  Values of the accumulators
      are unchanged.

   3) return a + m * f(...), where a and m do not depend on call to f.
      To preserve the semantics described before we want this to be rewritten
      in such a way that we finally return

      a_acc + (a + m * f(...)) * m_acc = (a_acc + a * m_acc) + (m * m_acc) * f(...).

      I.e. we increase a_acc by a * m_acc, multiply m_acc by m and
      eliminate the tail call to f.  Special cases when the value is just
      added or just multiplied are obtained by setting a = 0 or m = 1.
```

Notice that this is only used for self-recursion, not arbitrary
tailcalls or mutually-recursive functions: the optimization is
performend only when it does not require introducing a new/distinct
calling convention for the same function.


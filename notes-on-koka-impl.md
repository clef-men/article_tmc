Current version:
  https://github.com/koka-lang/koka/blob/b8cea633c1f52f6e6fe6e8ad545d012c2328371a/src/Core/CTail.hs

Worker-wrapper transform with a dummy allocation, to avoid code duplication.

This seems to only support self-recursion, and not mutual recursion:
see the `hasCTailCall` condition in `ctailDefGroup`.

Supports contexts of the form `T[C*[f x]]`, but not `(TC)*[f x]`:
see ctailTryArg.

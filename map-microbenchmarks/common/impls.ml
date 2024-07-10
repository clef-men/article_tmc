module Naive_nontail = struct
  let rec map f = function
    | [] -> []
    | x :: xs ->
      let y = f x in
      y :: map f xs
end

module Naive_tail = struct
  let rec rev_append xs acc = match xs with
    | [] -> acc
    | x :: xs -> rev_append xs (x :: acc)

  let rec rev_map f xs acc = match xs with
    | [] -> acc
    | x :: xs -> rev_map f xs (f x :: acc)

  let map f xs = rev_append (rev_map f xs []) []
end

module Base = struct
  (* This implementation can be found in most versions of Base,
     until they switched to [@tail_mod_cons] in July 2023
     (v0.17~preview.128.30+99, 02cf612470d5d37e0e9a704cdcecd5306ff196b7)
  
     The code below was extracted from the Base commit immediately earlier
     (v0.17~preview.128.27+392, 15321e7e3442543ae784fd0ba48171bef348e35c),
     it was introduced in August 2020
     (2c926a288a3a013d269f747efc8938d12c26b1a2), refining a slightly simpler,
     earlier implementation, where count_map would move to (rev (rev_map f xs))
     when reaching its limit. *)
  
  let max_non_tailcall =
    match Sys.backend_type with
    | Sys.Native | Sys.Bytecode -> 1_000
    (* We don't know the size of the stack, better be safe and assume it's small. This
       number was taken from ocaml#stdlib/list.ml which is also equal to the default limit
       of recursive call in the js_of_ocaml compiler before switching to trampoline. *)
    | Sys.Other _ -> 50
  ;;
  
  let rec nontail_map t ~f:(f [@local]) =
    match t with
    | [] -> []
    | x :: xs ->
      let y = f x in
      y :: nontail_map xs ~f
  ;;
  
  (* An ordinary tail recursive map builds up an intermediate (reversed) representation,
     with one heap allocated object per element. The following implementation instead chunks
     9 objects into one heap allocated object, reducing allocation and performance costs
     accordingly. Note that the very end of the list is done by the stdlib's map
     function. *)
  let tail_map xs ~f:(f [@local]) =
    let rec rise ys = function
      | [] -> ys
      | (y0, y1, y2, y3, y4, y5, y6, y7, y8) :: bs ->
        rise (y0 :: y1 :: y2 :: y3 :: y4 :: y5 :: y6 :: y7 :: y8 :: ys) bs
    in
    let rec dive bs = function
      | x0 :: x1 :: x2 :: x3 :: x4 :: x5 :: x6 :: x7 :: x8 :: xs ->
        let y0 = f x0 in
        let y1 = f x1 in
        let y2 = f x2 in
        let y3 = f x3 in
        let y4 = f x4 in
        let y5 = f x5 in
        let y6 = f x6 in
        let y7 = f x7 in
        let y8 = f x8 in
        dive ((y0, y1, y2, y3, y4, y5, y6, y7, y8) :: bs) xs
      | xs -> rise (nontail_map ~f xs) bs
    in
    let res = dive [] xs in
    res
  ;;
  
  let rec count_map ~f:(f [@local]) l ctr =
    match l with
    | [] -> []
    | [ x1 ] ->
      let f1 = f x1 in
      [ f1 ]
    | [ x1; x2 ] ->
      let f1 = f x1 in
      let f2 = f x2 in
      [ f1; f2 ]
    | [ x1; x2; x3 ] ->
      let f1 = f x1 in
      let f2 = f x2 in
      let f3 = f x3 in
      [ f1; f2; f3 ]
    | [ x1; x2; x3; x4 ] ->
      let f1 = f x1 in
      let f2 = f x2 in
      let f3 = f x3 in
      let f4 = f x4 in
      [ f1; f2; f3; f4 ]
    | x1 :: x2 :: x3 :: x4 :: x5 :: tl ->
      let f1 = f x1 in
      let f2 = f x2 in
      let f3 = f x3 in
      let f4 = f x4 in
      let f5 = f x5 in
      f1
      :: f2
      :: f3
      :: f4
      :: f5
      :: (if ctr > max_non_tailcall then tail_map ~f tl else count_map ~f tl (ctr + 1))
  ;;
  
  let map f l = count_map ~f l 0
end

module Containers = struct
  (* This implementation from Containers remains available for OCaml versions strictly
     older than 4.14 (at which point TRMC became available).
     (Current version: 99bfa200afb6a28edae55ce4158c002e3a16e24f, May 2024.)
  *)
  
  let direct_depth_default_ = 1000
  
  let tail_map f l =
    (* Unwind the list of tuples, reconstructing the full list front-to-back.
       @param tail_acc a suffix of the final list; we append tuples' content
       at the front of it *)
    let rec rebuild tail_acc = function
      | [] -> tail_acc
      | (y0, y1, y2, y3, y4, y5, y6, y7, y8) :: bs ->
        rebuild
          (y0 :: y1 :: y2 :: y3 :: y4 :: y5 :: y6 :: y7 :: y8 :: tail_acc)
          bs
    in
    (* Create a compressed reverse-list representation using tuples
       @param tuple_acc a reverse list of chunks mapped with [f] *)
    let rec dive tuple_acc = function
      | x0 :: x1 :: x2 :: x3 :: x4 :: x5 :: x6 :: x7 :: x8 :: xs ->
        let y0 = f x0 in
        let y1 = f x1 in
        let y2 = f x2 in
        let y3 = f x3 in
        let y4 = f x4 in
        let y5 = f x5 in
        let y6 = f x6 in
        let y7 = f x7 in
        let y8 = f x8 in
        dive ((y0, y1, y2, y3, y4, y5, y6, y7, y8) :: tuple_acc) xs
      | xs ->
        (* Reverse direction, finishing off with a direct map *)
        let tail = List.map f xs in
        rebuild tail tuple_acc
    in
    dive [] l
  
  let map f l =
    let rec direct f i l =
      match l with
      | [] -> []
      | [ x ] -> [ f x ]
      | [ x1; x2 ] ->
        let y1 = f x1 in
        [ y1; f x2 ]
      | [ x1; x2; x3 ] ->
        let y1 = f x1 in
        let y2 = f x2 in
        [ y1; y2; f x3 ]
      | _ when i = 0 -> tail_map f l
      | x1 :: x2 :: x3 :: x4 :: l' ->
        let y1 = f x1 in
        let y2 = f x2 in
        let y3 = f x3 in
        let y4 = f x4 in
        y1 :: y2 :: y3 :: y4 :: direct f (i - 1) l'
    in
    direct f direct_depth_default_ l
end

module Batteries = struct
  (* Something like this has been in Batteries from the start,
     imported from extlib (implemented by Brian Hurt in 2003,
     extlib SVN commit trunk@113).

     This version was taken from a relatively recent checkout of
     Batteries, f879df6cee4fc384313708501375a2fc655a04ae from December
     2023. *)

  type 'a mut_list =  {
    hd: 'a;
    mutable tl: 'a list
  }

  external inj : 'a mut_list -> 'a list = "%identity"
  
  module Acc = struct
    let dummy () =
      { hd = Obj.magic (); tl = [] }
    let create x =
      { hd = x; tl = [] }
    let accum acc x =
      let cell = create x in
      acc.tl <- inj cell;
      cell
  end

let map f = function
  | [] -> []
  | h :: t ->
    let rec loop dst = function
      | [] -> ()
      | h :: t ->
        loop (Acc.accum dst (f h)) t
    in
    let r = Acc.create (f h) in
    loop r t;
    inj r
end


module TMC = struct
  let[@tail_mod_cons] rec map f = function
    | [] -> []
    | x :: xs -> f x :: (map[@tailcall]) f xs
end

module TMC_unrolled = struct
  let[@tail_mod_cons] rec map f = function
    | [] -> []
    | [ x ] -> [ f x ]
    | [ x1; x2 ] ->
      let y1 = f x1 in
      let y2 = f x2 in
      [ y1; y2 ]
    | [ x1; x2; x3 ] ->
      let y1 = f x1 in
      let y2 = f x2 in
      let y3 = f x3 in
      [ y1; y2; y3 ]
    | x1 :: x2 :: x3 :: x4 :: xs ->
      let y1 = f x1 in
      let y2 = f x2 in
      let y3 = f x3 in
      let y4 = f x4 in
      y1 :: y2 :: y3 :: y4 :: (map[@tailcall]) f xs
end

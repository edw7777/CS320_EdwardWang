(* ************************************************ *)
#use "./../../../../classlib/OCaml/MyOCaml.ml";;
(*
Q2-7: 10 points

The following implementation of list_append is not tail-recursive.
Please give an implementation of list_append that is tail-recursive.

Note that you can only use pattern matching and list_foldleft in your
implementation.
 
let rec
list_append(xs: 'a list)(ys: 'a list) =
match xs with
  [] -> ys | x1 :: xs -> x1 :: list_append(xs)(ys)
*)

(* ************************************************ *)

let list_append_tail_recursive(xs: 'a list)(ys: 'a list): 'a list =
  let append_element acc x = x :: acc in
  list_foldleft(ys) xs append_element

  
let xs = [1; 2; 3]
let ys = [4; 5; 6]
let result = list_append_tail_recursive xs ys;;
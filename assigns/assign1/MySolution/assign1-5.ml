#use "./../../../classlib/OCaml/MyOCaml.ml";;
let
string_append
(cs1:string)
(cs2:string): string =
string_make_fwork
(fun work ->
 (string_foreach(cs1)(work); string_foreach(cs2)(work)))
(*
assign1-5: 20 points

A sequence of chars is ascending if any char in
the sequence is less than or equal to the following
one (when the following one does exist).
Given a string cs, please implement a function
that find the longest ascending subsequence of [cs].
If there are more than one such sequences, the left
most one should be returned.

fun string_longest_ascend(xs: string): string

For instance, given "1324561111", the function
string_longest_ascend returns "13456"

For instance, given "1234561111", the function
string_longest_ascend returns "123456"

For instance, given "1234511111", the function
string_longest_ascend returns "111111".
*)  
let rec helper (xs: string) (current_index: int) (prev_index): string = 
  if current_index == string_length(xs) then "" else
    if prev_index == -1 || string_get_at(xs) (prev_index) <= string_get_at(xs) (current_index) then 
      let take = helper(xs) (current_index+1) (current_index) in
      let notake = helper(xs) (current_index+1) (prev_index) in
      if string_length(take) < string_length(notake) then notake else string_append(str(string_get_at(xs) (current_index))) (take)
    else
      helper(xs) (current_index+1) (prev_index)
      

let string_longest_ascend(xs: string): string = 
  if string_length(xs) == 0 then "" else helper (xs) (0) (-1)

let test = string_longest_ascend("1324561111");;
#use "./../../../classlib/OCaml/MyOCaml.ml";;

(*

Please implement the interp function following the
specifications described in CS320_Fall_2023_Project-1.pdf

Notes:
1. You are only allowed to use library functions defined in MyOCaml.ml
   or ones you implement yourself.
2. You may NOT use OCaml standard library functions directly.

*)

type const = 
   | Int of int
   | Bool of bool
   | Unit

type com = 
   | Push of const
   | Pop
   | Trace
   | Add
   | Sub
   | Mul
   | Div
   | And
   | Or
   | Not
   | Lt
   | Gt

type coms = com list

let isEmpty (stack: string) : bool=
   if string_length(stack) == 0 then true else false

let ws : unit parser =
   (many whitespace) >| () 

let ws1 : unit parser =
   (many1 whitespace) >| () 
let parse_num : int parser=
(  let* _ = char('-') in
  let* x = natural in let* _ = ws in pure(-1*x)
)
<|>
(
   let* x = natural in let* _ = ws in pure(x)
)

let parse_bool : const parser=
   (let* _ = char('T') in
   let* _ = char('r') in
   let* _ = char('u') in
   let* _ = char('e') in
   let* _ = ws in
   pure( (Bool (true)))
   )
   <|>
   (let* _ = char('F') in
   let* _ = char('a') in
   let* _ = char('l') in
   let* _ = char('s') in
   let* _ = char('e') in
   let* _ = ws in
   pure( (Bool (false)))
   )

let parse_unit : const parser =
   let* _ = char('U') in
   let* _ = char('n') in
   let* _ = char('i') in
   let* _ = char('t') in
   let* _ = ws in
   pure( (Unit))

let parse_constant () : const parser =
   (
   let* int = parse_num in
   pure (Int (int))
   )
   <|>
   (
   parse_bool
   )
   <|> 
   (
   parse_unit
   )

let com_parse() : com parser =
   (
      let* _ = ws in
   let* _ = char('P') in
   let* _ = char('u') in
   let* _ = char('s') in
   let* _ = char('h') in
   let* _ = ws1 in
   let* push = parse_constant() in
   let* _ = char(';') in
   let* _ = ws in
   pure(Push (push))
   )
   <|>
   (
      let* _ = ws in
   let* _ = char('P') in
   let* _ = char('o') in
   let* _ = char('p') in
   let* _ = char(';') in
   let* _ = ws in
   pure(Pop)
   )
   <|>
   (
      let* _ = ws in
   let* _ = char('T') in
   let* _ = char('r') in
   let* _ = char('a') in
   let* _ = char('c') in
   let* _ = char('e') in
   let* _ = char(';') in
   let* _ = ws in
   pure(Trace)
   )
   <|>
   (
      let* _ = ws in
      let* _ = char('A') in
      let* _ = char('d') in
      let* _ = char('d') in
      let* _ = char(';') in
      let* _ = ws in
      pure(Add)
   )
   <|>
   (
      let* _ = ws in
      let* _ = char('S') in
      let* _ = char('u') in
      let* _ = char('b') in
      let* _ = char(';') in
      let* _ = ws in
      pure(Sub)
   )
   <|>
   (
      let* _ = ws in
      let* _ = char('M') in
      let* _ = char('u') in
      let* _ = char('l') in
      let* _ = char(';') in
      let* _ = ws in
      pure(Mul)
   )
   <|>
   (
      let* _ = ws in
      let* _ = char('D') in
      let* _ = char('i') in
      let* _ = char('v') in
      let* _ = char(';') in
      let* _ = ws in
      pure(Div)
   )
   <|>
   (
      let* _ = ws in
      let* _ = char('A') in
      let* _ = char('n') in
      let* _ = char('d') in
      let* _ = char(';') in
      let* _ = ws in
      pure(And)
   )
   <|>
   (
      let* _ = ws in
      let* _ = char('O') in
      let* _ = char('r') in
      let* _ = char(';') in
      let* _ = ws in
      pure(Or)
   )
   <|>
   (
      let* _ = ws in
      let* _ = char('N') in
      let* _ = char('o') in
      let* _ = char('t') in
      let* _ = char(';') in
      let* _ = ws in
      pure(Not)
   )
   <|>
   (
      let* _ = ws in
      let* _ = char('L') in
      let* _ = char('t') in
      let* _ = char(';') in
      let* _ = ws in
      pure(Lt)
   )
   <|>
   (
      let* _ = ws in
      let* _ = char('G') in
      let* _ = char('t') in
      let* _ = char(';') in
      let* _ = ws in
      pure(Gt)
   )
   
let coms_parse() : com list parser = many(com_parse())

let toString(input : const): string =
   match input with
   | Bool(false) -> "False"
   | Bool(true) -> "True"
   | Unit -> "Unit"
   | Int(x) -> string_of_int(x)


let is_int(x : const) : bool =
match x with
   | Int (x) -> true
   | _ -> false

let is_bool(x : const) : bool =
match x with
   | Bool (x) -> true
   | _ -> false

let parse(s:string) : com list option =
let cs = string_listize s in
match coms_parse()(cs) with
| Some (e, []) -> Some e
| _ -> None

(* let test = parse ("Push Unit;
Push Unit;
Trace;");; 
*)
(*Some [Push (Bool false); Push (Int 3); Gt]*)

let to_int(input: const) : int =
match input with
| Int(x) -> x

let to_bool(input: const) : bool =
match input with
| Bool(x) -> x

let rec big_interp (s: com list) (stack : const list) (trace: string list) : string list=
   (match s with
   | [] -> trace
   | comhead :: comtail -> (match comhead with
      | Push (x) -> big_interp(comtail)(x :: stack)(trace)
      | Pop -> (match stack with
               | [] -> "Panic"::trace
               | stackhead :: stacktail -> big_interp(comtail)(stacktail)(trace)
      )
      | Trace -> (match stack with
               | [] -> "Panic"::trace
               | stacktracehead :: stacktracetail -> big_interp(comtail)(Unit::stacktracetail)(toString(stacktracehead)::trace)
      )
      | Add -> (match stack with
               | [] -> "Panic"::trace
               | x :: [] -> "Panic"::trace
               | x :: y :: _ when not (is_int x) || not (is_int y) -> "Panic"::trace
               | x :: y :: stackrest -> let result = to_int(x)+to_int(y) in big_interp(comtail)(Int(result)::stackrest)(trace)
      )
      | Sub -> (match stack with
               | [] -> "Panic"::trace
               | x :: [] -> "Panic"::trace
               | x :: y :: _ when not (is_int x) || not (is_int y) -> "Panic"::trace
               | x :: y :: stackrest -> let result = to_int(x)-to_int(y) in big_interp(comtail)(Int(result)::stackrest)(trace)
      )
      | Mul -> (match stack with
               | [] -> "Panic"::trace
               | x :: [] -> "Panic"::trace
               | x :: y :: _ when not (is_int x) || not (is_int y) -> "Panic"::trace
               | x :: y :: stackrest -> let result = to_int(x)*to_int(y) in big_interp(comtail)(Int(result)::stackrest)(trace)
      )
      | Div -> (match stack with
               | [] -> "Panic"::trace
               | x :: [] -> "Panic"::trace
               | x :: y :: _ when not (is_int x) || not (is_int y) || to_int y == 0 -> "Panic"::trace
               | x :: y :: stackrest -> let result = to_int(x)/to_int(y) in big_interp(comtail)(Int(result)::stackrest)(trace)
      )
      | And -> (match stack with
               | [] -> "Panic"::trace
               | x :: [] -> "Panic"::trace
               | x :: y :: _ when not (is_bool x) || not (is_bool y) -> "Panic"::trace
               | x :: y :: stackrest -> let result = to_bool(x) && to_bool(y) in big_interp(comtail)(Bool(result)::stackrest)(trace)
      )
      | Or -> (match stack with
               | [] -> "Panic"::trace
               | x :: [] -> "Panic"::trace
               | x :: y :: _ when not (is_bool x) || not (is_bool y) -> "Panic"::trace
               | x :: y :: stackrest -> let result = to_bool(x) || to_bool(y) in big_interp(comtail)(Bool(result)::stackrest)(trace)
      )
      | Not -> (match stack with
               | [] -> "Panic"::trace
               | x :: _ when not (is_bool x) -> "Panic"::trace
               | x :: stackrest -> let result = not(to_bool(x)) in big_interp(comtail)(Bool(result)::stackrest)(trace)
      )
      | Lt -> (match stack with
               | [] -> "Panic"::trace
               | x :: [] -> "Panic"::trace
               | x :: y :: _ when not (is_int x) || not (is_int y) -> "Panic"::trace
               | x :: y :: stackrest -> let result = (to_int(x)<to_int(y)) in big_interp(comtail)(Bool(result)::stackrest)(trace)
      )
      | Gt -> (match stack with
               | [] -> "Panic"::trace
               | x :: [] -> "Panic"::trace
               | x :: y :: _ when not (is_int x) || not (is_int y) -> "Panic"::trace
               | x :: y :: stackrest -> let result = (to_int(x)>to_int(y)) in big_interp(comtail)(Bool(result)::stackrest)(trace)
      )
   
   ))

let interp (s : string) : string list option = (* YOUR CODE *)
   let parsed = parse(s) in
   match parsed with
   | None -> None
   | Some (x) -> Some (big_interp(x)([])([]))

let test = interp ("Push 0;
Push 6;
Div;
Trace;
");;

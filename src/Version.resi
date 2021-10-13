type t

let upgrade: (t, Transaction.t => unit) => t
let stores: (t, Js.Array.t<(string, string)>) => t

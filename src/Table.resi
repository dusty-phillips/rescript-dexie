type t<'item, 'id> = {name: string}

let add: (t<'item, 'id>, 'item) => Promise.t<'id>

let getById: (t<'item, 'id>, 'id) => Promise.t<option<'item>>

let getByCriteria: (t<'item, 'id>, Js.t<'a>) => Promise.t<option<'item>>

let bulkAdd: (t<'item, 'id>, array<'item>) => Promise.t<array<'id>>

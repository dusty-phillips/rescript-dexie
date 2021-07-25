type t<'item, 'id> = {name: string}

let add: (t<'item, 'id>, 'item) => Promise.t<'id>

let bulkAdd: (t<'item, 'id>, array<'item>) => Promise.t<array<'id>>

let bulkDelete: (t<'item, 'id>, array<'id>) => Promise.t<unit>

let count: t<'item, 'id> => Promise.t<int>

let delete: (t<'item, 'id>, 'id) => Promise.t<unit>

let getById: (t<'item, 'id>, 'id) => Promise.t<option<'item>>

let getByCriteria: (t<'item, 'id>, Js.t<'a>) => Promise.t<option<'item>>

let put: (t<'item, 'id>, 'item) => Promise.t<'id>

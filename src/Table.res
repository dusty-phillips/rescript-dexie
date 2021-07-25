type t<'item, 'id> = {name: string}

type bulkAddOptions = {allKeys: bool}

@send
external bulkAdd_binding: (t<'item, 'id>, array<'item>, bulkAddOptions) => Promise.t<'idorarray> =
  "bulkAdd"

@send
external add: (t<'item, 'id>, 'item) => Promise.t<'id> = "add"

@send
external bulkDelete: (t<'item, 'id>, array<'id>) => Promise.t<unit> = "bulkDelete"

@send
external count: t<'item, 'id> => Promise.t<int> = "count"

@send external delete: (t<'item, 'id>, 'id) => Promise.t<unit> = "delete"

@send
external getById: (t<'item, 'id>, 'id) => Promise.t<option<'item>> = "get"

@send
external getByCriteria: (t<'item, 'id>, Js.t<'a>) => Promise.t<option<'item>> = "get"

@send
external put: (t<'item, 'id>, 'item) => Promise.t<'id> = "put"

let bulkAdd = (table: t<'item, 'id>, items: array<'item>): Promise.t<array<'id>> => {
  table->bulkAdd_binding(items, {allKeys: true})
}

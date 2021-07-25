type t<'item, 'id> = {name: string}

type bulkAddOptions = {allKeys: bool}

@send
external bulkAdd_binding: (t<'item, 'id>, array<'item>, bulkAddOptions) => Promise.t<'idorarray> =
  "bulkAdd"

@send
external add: (t<'item, 'id>, 'item) => Promise.t<'id> = "add"

@send
external getById: (t<'item, 'id>, 'id) => Promise.t<option<'item>> = "get"

@send
external getByCriteria: (t<'item, 'id>, Js.t<'a>) => Promise.t<option<'item>> = "get"

let bulkAdd = (table: t<'item, 'id>, items: array<'item>): Promise.t<array<'id>> => {
  table->bulkAdd_binding(items, {allKeys: true})
}

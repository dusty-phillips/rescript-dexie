type t<'item, 'id> = {name: string}

type bulkOptions = {allKeys: bool}

@send
external bulkAdd_binding: (t<'item, 'id>, array<'item>, bulkOptions) => Promise.t<'idorarray> =
  "bulkAdd"

@send
external bulkPut_binding: (t<'item, 'id>, array<'item>, bulkOptions) => Promise.t<'idorarray> =
  "bulkPut"

@send
external add: (t<'item, 'id>, 'item) => Promise.t<'id> = "add"

@send
external bulkDelete: (t<'item, 'id>, array<'id>) => Promise.t<unit> = "bulkDelete"

@send
external bulkGet: (t<'item, 'id>, array<'id>) => Promise.t<array<option<'item>>> = "bulkGet"

@send
external count: t<'item, 'id> => Promise.t<int> = "count"

@send external delete: (t<'item, 'id>, 'id) => Promise.t<unit> = "delete"

@send
external findeByCriteria: (t<'item, 'id>, Js.t<'a>) => Promise.t<Collection.t<'item>> = "where"

@send
external getById: (t<'item, 'id>, 'id) => Promise.t<option<'item>> = "get"

@send
external getByCriteria: (t<'item, 'id>, Js.t<'a>) => Promise.t<option<'item>> = "get"

@send
external put: (t<'item, 'id>, 'item) => Promise.t<'id> = "put"

@send
external update: (t<'item, 'id>, 'id, Js.t<'a>) => Promise.t<int> = "update"

let bulkAdd = (table: t<'item, 'id>, items: array<'item>): Promise.t<array<'id>> => {
  table->bulkAdd_binding(items, {allKeys: true})
}

let bulkPut = (table: t<'item, 'id>, items: array<'item>): Promise.t<array<'id>> => {
  table->bulkPut_binding(items, {allKeys: true})
}

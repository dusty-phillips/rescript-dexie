module MakeTable = (Schema: Schema.SchemaItem) => {
  type t = Schema.t
  type id = Schema.id
  type table = {name: string}

  type bulkOptions = {allKeys: bool}

  %%private(
    @send
    external bulkAdd_binding: (table, array<t>, bulkOptions) => Promise.t<'idorarray> =
      "bulkAdd"
  )

  %%private(
    @send
    external bulkPut_binding: (table, array<t>, bulkOptions) => Promise.t<'idorarray> =
      "bulkPut"
  )

  @send
  external add: (table, t) => Promise.t<id> = "add"

  @send
  external bulkDelete: (table, array<id>) => Promise.t<unit> = "bulkDelete"

  @send
  external bulkGet: (table, array<id>) => Promise.t<array<option<t>>> = "bulkGet"

  @send
  external count: table => Promise.t<int> = "count"

  @send external delete: (table, id) => Promise.t<unit> = "delete"

  @send
  external findeByCriteria: (table, Js.t<'a>) => Collection.t<t> = "where"

  @send
  external getById: (table, id) => Promise.t<option<t>> = "get"

  @send
  external getByCriteria: (table, Js.t<'a>) => Promise.t<option<t>> = "get"

  @send
  external put: (table, t) => Promise.t<id> = "put"

  @send
  external update: (table, id, Js.t<'a>) => Promise.t<int> = "update"

  @send
  external where: (table, string) => Where.t<t> = "where"

  let bulkAdd = (table: table, items: array<t>): Promise.t<array<id>> => {
    table->bulkAdd_binding(items, {allKeys: true})
  }

  let bulkPut = (table: table, items: array<t>): Promise.t<array<id>> => {
    table->bulkPut_binding(items, {allKeys: true})
  }

  %%private(@send external table_binding: (Database.t, string) => table = "table")
  let table: Database.t => table = database => database->table_binding(Schema.tableName)
}

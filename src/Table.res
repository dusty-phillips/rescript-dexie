type schemaTableName = string

module type SchemaItem = {
  type t
  type id
  let tableName: schemaTableName
}

module type MakeTableType = (Schema: SchemaItem) =>
{
  type t = Schema.t
  type id = Schema.id
  let add: (Database.t, t) => promise<id>
  let bulkAdd: (Database.t, array<t>) => promise<array<id>>
  let bulkPut: (Database.t, array<t>) => promise<array<id>>
  let bulkDelete: (Database.t, array<id>) => promise<unit>
  let bulkGet: (Database.t, array<id>) => promise<array<option<t>>>
  let count: Database.t => promise<int>
  let delete: (Database.t, id) => promise<unit>
  let findByCriteria: (Database.t, Js.t<'a>) => Collection.t<t>
  let getById: (Database.t, id) => promise<option<t>>
  let getByCriteria: (Database.t, Js.t<'a>) => promise<option<t>>
  let put: (Database.t, t) => promise<id>
  let update: (Database.t, id, Js.t<'a>) => promise<int>
  let where: (Database.t, string) => Where.t<t>
  let toArray: Database.t => promise<array<t>>
}

module MakeTable: MakeTableType = (Schema: SchemaItem) => {
  type t = Schema.t
  type id = Schema.id

  module Bindings = {
    type bulkOptions = {allKeys: bool}
    type table = {name: string}
    // Private Bindings module creates the Javascript bindings, expecting a table.
    // The public bindings accept a Dexie instance
    @send external table: (Database.t, string) => table = "table"
    @send
    external add: (table, t) => promise<id> = "add"
    @send
    external bulkAdd: (table, array<t>, bulkOptions) => promise<'idorarray> = "bulkAdd"
    @send
    external bulkPut: (table, array<t>, bulkOptions) => promise<'idorarray> = "bulkPut"
    @send
    external bulkDelete: (table, array<id>) => promise<unit> = "bulkDelete"
    @send
    external bulkGet: (table, array<id>) => promise<array<option<t>>> = "bulkGet"
    @send
    external count: table => promise<int> = "count"
    @send external delete: (table, id) => promise<unit> = "delete"
    @send
    external findByCriteria: (table, Js.t<'a>) => Collection.t<t> = "where"
    @send
    external getById: (table, id) => promise<option<t>> = "get"
    @send
    external getByCriteria: (table, Js.t<'a>) => promise<option<t>> = "get"
    @send
    external put: (table, t) => promise<id> = "put"
    @send
    external update: (table, id, Js.t<'a>) => promise<int> = "update"
    @send
    external where: (table, string) => Where.t<t> = "where"
    @send
    external toArray: table => promise<array<t>> = "toArray"
  }

  let add = (dexie: Database.t, item: t): promise<id> => {
    dexie->Bindings.table(Schema.tableName)->Bindings.add(item)
  }

  let bulkAdd = (dexie: Database.t, items: array<t>): promise<array<id>> => {
    dexie->Bindings.table(Schema.tableName)->Bindings.bulkAdd(items, {allKeys: true})
  }

  let bulkPut = (dexie: Database.t, items: array<t>): promise<array<id>> => {
    dexie->Bindings.table(Schema.tableName)->Bindings.bulkPut(items, {allKeys: true})
  }
  let bulkDelete = (dexie: Database.t, items: array<id>): promise<unit> => {
    dexie->Bindings.table(Schema.tableName)->Bindings.bulkDelete(items)
  }
  let bulkGet = (dexie: Database.t, ids: array<id>): promise<array<option<t>>> => {
    dexie->Bindings.table(Schema.tableName)->Bindings.bulkGet(ids)
  }
  let count = (dexie: Database.t): promise<int> => {
    dexie->Bindings.table(Schema.tableName)->Bindings.count
  }
  let delete = (dexie: Database.t, id: Schema.id): promise<unit> => {
    dexie->Bindings.table(Schema.tableName)->Bindings.delete(id)
  }
  let findByCriteria = (dexie: Database.t, criteria: Js.t<'a>): Collection.t<t> => {
    dexie->Bindings.table(Schema.tableName)->Bindings.findByCriteria(criteria)
  }
  let getById = (dexie: Database.t, id: id): promise<option<t>> => {
    dexie->Bindings.table(Schema.tableName)->Bindings.getById(id)
  }
  let getByCriteria = (dexie: Database.t, criteria: Js.t<'a>): promise<option<t>> => {
    dexie->Bindings.table(Schema.tableName)->Bindings.getByCriteria(criteria)
  }
  let put = (dexie: Database.t, item: t): promise<id> => {
    dexie->Bindings.table(Schema.tableName)->Bindings.put(item)
  }
  let update = (dexie: Database.t, id: id, patch: Js.t<'a>): promise<int> => {
    dexie->Bindings.table(Schema.tableName)->Bindings.update(id, patch)
  }
  let where = (dexie: Database.t, fieldName: string): Where.t<t> => {
    dexie->Bindings.table(Schema.tableName)->Bindings.where(fieldName)
  }
  let toArray = (dexie: Database.t): promise<array<t>> => {
    dexie->Bindings.table(Schema.tableName)->Bindings.toArray
  }
}

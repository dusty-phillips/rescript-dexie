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
  let add: (Database.t, t) => Promise.t<id>
  let bulkAdd: (Database.t, array<t>) => Promise.t<array<id>>
  let bulkPut: (Database.t, array<t>) => Promise.t<array<id>>
  let bulkDelete: (Database.t, array<id>) => Promise.t<unit>
  let bulkGet: (Database.t, array<id>) => Promise.t<array<option<t>>>
  let count: Database.t => Promise.t<int>
  let delete: (Database.t, id) => Promise.t<unit>
  let findByCriteria: (Database.t, Js.t<'a>) => Collection.t<t>
  let getById: (Database.t, id) => Promise.t<option<t>>
  let getByCriteria: (Database.t, Js.t<'a>) => Promise.t<option<t>>
  let put: (Database.t, t) => Promise.t<id>
  let update: (Database.t, id, Js.t<'a>) => Promise.t<int>
  let where: (Database.t, string) => Where.t<t>
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
    external add: (table, t) => Promise.t<id> = "add"
    @send
    external bulkAdd: (table, array<t>, bulkOptions) => Promise.t<'idorarray> = "bulkAdd"
    @send
    external bulkPut: (table, array<t>, bulkOptions) => Promise.t<'idorarray> = "bulkPut"
    @send
    external bulkDelete: (table, array<id>) => Promise.t<unit> = "bulkDelete"
    @send
    external bulkGet: (table, array<id>) => Promise.t<array<option<t>>> = "bulkGet"
    @send
    external count: table => Promise.t<int> = "count"
    @send external delete: (table, id) => Promise.t<unit> = "delete"
    @send
    external findByCriteria: (table, Js.t<'a>) => Collection.t<t> = "where"
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
  }

  let add = (dexie: Database.t, item: t): Promise.t<id> => {
    dexie->Bindings.table(Schema.tableName)->Bindings.add(item)
  }

  let bulkAdd = (dexie: Database.t, items: array<t>): Promise.t<array<id>> => {
    dexie->Bindings.table(Schema.tableName)->Bindings.bulkAdd(items, {allKeys: true})
  }

  let bulkPut = (dexie: Database.t, items: array<t>): Promise.t<array<id>> => {
    dexie->Bindings.table(Schema.tableName)->Bindings.bulkPut(items, {allKeys: true})
  }
  let bulkDelete = (dexie: Database.t, items: array<id>): Promise.t<unit> => {
    dexie->Bindings.table(Schema.tableName)->Bindings.bulkDelete(items)
  }
  let bulkGet = (dexie: Database.t, ids: array<id>): Promise.t<array<option<t>>> => {
    dexie->Bindings.table(Schema.tableName)->Bindings.bulkGet(ids)
  }
  let count = (dexie: Database.t): Promise.t<int> => {
    dexie->Bindings.table(Schema.tableName)->Bindings.count
  }
  let delete = (dexie: Database.t, id: Schema.id): Promise.t<unit> => {
    dexie->Bindings.table(Schema.tableName)->Bindings.delete(id)
  }
  let findByCriteria = (dexie: Database.t, criteria: Js.t<'a>): Collection.t<t> => {
    dexie->Bindings.table(Schema.tableName)->Bindings.findByCriteria(criteria)
  }
  let getById = (dexie: Database.t, id: id): Promise.t<option<t>> => {
    dexie->Bindings.table(Schema.tableName)->Bindings.getById(id)
  }
  let getByCriteria = (dexie: Database.t, criteria: Js.t<'a>): Promise.t<option<t>> => {
    dexie->Bindings.table(Schema.tableName)->Bindings.getByCriteria(criteria)
  }
  let put = (dexie: Database.t, item: t): Promise.t<id> => {
    dexie->Bindings.table(Schema.tableName)->Bindings.put(item)
  }
  let update = (dexie: Database.t, id: id, patch: Js.t<'a>): Promise.t<int> => {
    dexie->Bindings.table(Schema.tableName)->Bindings.update(id, patch)
  }
  let where = (dexie: Database.t, fieldName: string): Where.t<t> => {
    dexie->Bindings.table(Schema.tableName)->Bindings.where(fieldName)
  }
}

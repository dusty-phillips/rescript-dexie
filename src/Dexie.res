type t

@new @module("dexie") external make: (string, ~options: 'options) => t = "default"

@send external opendb: t => Promise.t<unit> = "open"
@send external closedb: t => Promise.t<unit> = "close"

@send external table: (t, string) => Table.t<'item, 'id> = "table"

@send
external transaction: (t, string, array<string>, Transaction.callback) => Promise.t<'result> =
  "transaction"

@send external version: (t, int) => DexieVersion.t = "version"

type t

@new @module("dexie") external make: string => t = "default"

@send external opendb: t => promise<unit> = "open"
@send external closedb: t => promise<unit> = "close"

@send
external transaction: (
  t,
  Transaction.mode,
  array<string>,
  Transaction.callback,
) => promise<'result> = "transaction"

@send external version: (t, int) => Version.t = "version"

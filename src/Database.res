type t

@new @module("dexie") external make: string => t = "default"

@send external opendb: t => Promise.t<unit> = "open"
@send external closedb: t => Promise.t<unit> = "close"

@send
external transaction: (
  t,
  Transaction.mode,
  array<string>,
  Transaction.callback,
) => Promise.t<'result> = "transaction"

@send external version: (t, int) => Version.t = "version"

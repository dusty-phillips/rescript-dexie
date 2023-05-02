type t

type event = {newVersion: string}

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

@send external on: (t, [#blocked | #close | #ready], unit => unit) => unit = "on"

@send external on1: (t, [#ready], unit => promise<'a>) => unit = "on"

@send external on2: (t, [#populate], Transaction.t => promise<'a>) => unit = "on"

@send external on3: (t, [#versionchange], event => bool) => unit = "on"

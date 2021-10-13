// if the `dexie-react-hooks` optional dependency is installed, these bindings
// will work.
//
// See `examples/react/src/Demo.res` for an example of how to use them.

@module("dexie-react-hooks")
external use0: (unit => Promise.t<option<'a>>) => option<'a> = "useLiveQuery"
@module("dexie-react-hooks")
external use1: (unit => Promise.t<option<'a>>, array<'b>) => option<'a> = "useLiveQuery"
@module("dexie-react-hooks")
external use2: (unit => Promise.t<option<'a>>, ('b, 'c)) => option<'a> = "useLiveQuery"
@module("dexie-react-hooks")
external use3: (unit => Promise.t<option<'a>>, ('b, 'c, 'd)) => option<'a> = "useLiveQuery"
@module("dexie-react-hooks")
external use4: (unit => Promise.t<option<'a>>, ('b, 'c, 'd, 'e)) => option<'a> = "useLiveQuery"
@module("dexie-react-hooks")
external use5: (unit => Promise.t<option<'a>>, ('b, 'c, 'd, 'e, 'f)) => option<'a> = "useLiveQuery"
@module("dexie-react-hooks")
external use6: (unit => Promise.t<option<'a>>, ('b, 'c, 'd, 'e, 'f, 'g)) => option<'a> =
  "useLiveQuery"
@module("dexie-react-hooks")
external use7: (unit => Promise.t<option<'a>>, ('b, 'c, 'd, 'e, 'f, 'g, 'h)) => option<'a> =
  "useLiveQuery"

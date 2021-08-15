type t<'item>

@send
external count: t<'item> => Promise.t<int> = "count"

@send external clone: t<'item> => t<'item> = "clone"

@send external delete: t<'item> => Promise.t<unit> = "delete"

// 'a placeholder below is for if I model IDBCursor someday
@send external each: (t<'item>, ('item, 'a) => unit) => Promise.t<unit> = "each"

@send external filter: (t<'item>, 'item => bool) => t<'item> = "filter"

@send
external first: t<'item> => Promise.t<option<'item>> = "first"

@send
external last: t<'item> => Promise.t<option<'item>> = "last"

@send external limit: (t<'item>, int) => t<'item> = "limit"

@send external modify: (t<'item>, 'changes) => Promise.t<int> = "modify"

@send external offset: (t<'item>, int) => t<'item> = "offset"

@send
external sortBy: (t<'item>, string) => Promise.t<array<'item>> = "sortBy"

@send
external toArray: t<'item> => Promise.t<array<'item>> = "toArray"

@send external until: (t<'item>, 'item => bool) => t<'item> = "until"

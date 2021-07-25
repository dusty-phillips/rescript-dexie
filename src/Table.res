type t<'item> = {name: string}

@send
external add: (t<'item>, 'item) => Promise.t<'id> = "add"

@send
external getById: (t<'item>, 'id) => Promise.t<'item> = "get"

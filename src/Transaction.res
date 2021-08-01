type t

type mode = [#rw | #r | #"rw?" | #"r!" | #"r?"]

type callback = t => unit

@send
external table: (t, string) => Table.t<'item, 'id> = "table"

@send
external abort: t => unit = "abort"

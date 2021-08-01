type t

type callback = t => unit

@send
external table: (t, string) => Table.t<'item, 'id> = "table"

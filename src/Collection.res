type t<'item>

@send
external toArray: t<'item> => Promise.t<array<'item>> = "toArray"

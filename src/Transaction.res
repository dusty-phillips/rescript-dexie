type t

type mode = [#rw | #r | #"rw!" | #"rw?" | #"r!" | #"r?"]

@send
external abort: t => unit = "abort"

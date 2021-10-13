type t

type mode = [#rw | #r | #"rw?" | #"r!" | #"r?"]

type callback = t => unit

@send
external abort: t => unit = "abort"

type t

type mode = [#rw | #r | #"rw?" | #"r!" | #"r?"]

type callback = t => promise<unit>

@send
external abort: t => unit = "abort"

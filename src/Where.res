type t<'item>

@send external above: (t<'item>, 'a) => Collection.t<'item> = "above"
@send external aboveOrEqual: (t<'item>, 'a) => Collection.t<'item> = "aboveOrEqual"
@send external anyOf: (t<'item>, array<'a>) => Collection.t<'item> = "anyOf"
@send external anyOfIgnoreCase: (t<'item>, array<string>) => Collection.t<'item> = "anyOfIgnoreCase"
@send external below: (t<'item>, 'a) => Collection.t<'item> = "below"
@send external belowOrEqual: (t<'item>, 'a) => Collection.t<'item> = "belowOrEqual"
@send external equals: (t<'item>, 'a) => Collection.t<'item> = "equals"
@send external equalsIgnoreCase: (t<'item>, string) => Collection.t<'item> = "equalsIgnoreCase"
@send external noneOf: (t<'item>, array<'a>) => Collection.t<'item> = "noneOf"
@send external notEqual: (t<'item>, 'a) => Collection.t<'item> = "notEqual"
@send external startsWith: (t<'item>, string) => Collection.t<'item> = "startsWith"
@send
external startsWithIgnoreCase: (t<'item>, string) => Collection.t<'item> = "startsWithIgnoreCase"
@send
external startsWithAnyOfIgnoreCase: (t<'item>, array<string>) => Collection.t<'item> =
  "startsWithAnyOfIgnoreCase"
@send external startsWithAnyOf: (t<'item>, array<string>) => Collection.t<'item> = "startsWithAnyOf"

type inAnyOptions = {
  includeLowers: bool,
  includeUppers: bool,
}

@send
external inAnyRange_binding: (t<'item>, array<'a>, option<inAnyOptions>) => Collection.t<'item> =
  "inAnyRange"

let inAnyRange = (where: t<'item>, ~options: option<inAnyOptions>=?, items: array<'a>) => {
  where->inAnyRange_binding(items, options)
}

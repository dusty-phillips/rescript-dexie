type t

%%private(@send external stores_binding: (t, Js.Dict.t<string>) => t = "stores")


type callback = t => unit
@send external upgrade: (t, callback) => t = "upgrade"

let stores = (version: t, schema: Js.Array.t<(string, string)>) => {
  let schema = schema->Js.Dict.fromArray
  version->stores_binding(schema)
}

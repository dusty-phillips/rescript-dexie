type count = {
  id: option<int>,
  count: int,
}

module Counter = {
  @react.component
  let make = (~dexie: Dexie.Database.t) => {
    let countOption = Dexie.LiveQuery.use0(() => {
      dexie->Dexie.Database.table("count")->Dexie.Table.getById(1)
    })

    switch countOption {
    | None => <div> {React.string(" No count ")} </div>

    | Some(count) =>
      <div>
        <div> {React.string(`Counter is ${count.count->Js.Int.toString}`)} </div>
        <button
          onClick={_ => {
            Js.log(count)
            dexie
            ->Dexie.Database.table("count")
            ->Dexie.Table.put({id: Some(1), count: count.count + 1})
            ->ignore
          }}>
          {React.string("Count")}
        </button>
      </div>
    }
  }
}

@react.component
let make = () => {
  let (dexieOption, setDexie) = React.useState(_ => None)

  React.useEffect0(() => {
    let dexie = Dexie.Database.make("Example")

    let schema = [("count", "++id")]

    dexie->Dexie.Database.version(1)->Dexie.Version.stores(schema)->ignore
    setDexie(_prev => Some(dexie))
    None
  })

  switch dexieOption {
  | None => <div> {React.string("Hello World")} </div>
  | Some(dexie) => <Counter dexie />
  }
}

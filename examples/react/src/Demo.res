module CountSchema = {
  type t = {
    id: option<int>,
    count: int,
  }
  type id = int
  let tableName = "count"
}

module Count = Dexie.Table.MakeTable(CountSchema)

module Counter = {
  @react.component
  let make = (~dexie: Dexie.Database.t) => {
    let countOption = Dexie.LiveQuery.use0(() => {
      dexie->Count.getById(1)
    })

    switch countOption {
    | None =>
      <div>
        <button
          onClick={_ => {
            dexie->Count.put({id: Some(1), count: 1})->ignore
          }}>
          {React.string("Count")}
        </button>
        <div> {React.string(" No count ")} </div>
      </div>

    | Some(count) =>
      <div>
        <div> {React.string(`Counter is ${count.count->Js.Int.toString}`)} </div>
        <button
          onClick={_ => {
            dexie->Count.put({id: Some(1), count: count.count + 1})->ignore
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

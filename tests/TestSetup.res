type fakeIndexedDb

let p = Promise.then
let pt = Promise.thenResolve

@module("fake-indexeddb/lib/FDBKeyRange.js") external fIDBKeyRange: 'keyrange = "default"
@new @module("fake-indexeddb/lib/FDBFactory.js")
external fdbFactory: unit => fakeIndexedDb = "default"

type friend = {
  id: option<int>,
  name: string,
  color: [#Blue | #Red | #Purple],
}

let setup = () => {
  let idb = fdbFactory()
  let dexie = Dexie.make("hello dexie", ~options={"indexedDB": idb, "IDBKeyRange": fIDBKeyRange})
  let schema = [("friends", "++id,name,birthdate,color"), ("pets", "++id,name,kind")]
  dexie
  ->Dexie.version(1)
  ->DexieVersion.stores(schema)
  ->DexieVersion.upgrade(_tx => {
    // Show the upgrade function is bound, because we don't test that anywhere
    let _ = 365 * 24 * 60 * 60 * 1000
  })
  ->ignore

  dexie->Dexie.opendb->ignore

  dexie
}

let friendFixture = dexie => {
  let friends: Table.t<friend, int> = dexie->Dexie.table("friends")
  friends
  ->Table.bulkPut([
    {id: Some(1), name: "Chris", color: #Red},
    {id: Some(2), name: "Leroy", color: #Blue},
    {id: Some(3), name: "Jerome", color: #Purple},
    {id: Some(4), name: "Betty", color: #Purple},
    {id: Some(5), name: "Xiao", color: #Blue},
    {id: Some(6), name: "Rohan", color: #Red},
    {id: Some(7), name: "Natalia", color: #Red},
    {id: Some(8), name: "Padma", color: #Purple},
  ])
  ->pt(_ => friends)
}

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
    let _ = 365 * 24 * 60 * 60 * 1000
  })
  ->ignore

  dexie->Dexie.opendb->ignore

  dexie
}

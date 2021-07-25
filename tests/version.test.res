open Zora

type fakeIndexedDb

@module("fake-indexeddb/lib/FDBKeyRange.js") external fIDBKeyRange: 'keyrange = "default"
@new @module("fake-indexeddb/lib/FDBFactory.js")
external fdbFactory: unit => fakeIndexedDb = "default"

let default: zoraTestBlock = t => {
  t->test("Initialize version and upgrade", t => {
    let idb = fdbFactory()
    let dexie = Dexie.make("hello dexie", ~options={"indexedDB": idb, "IDBKeyRange": fIDBKeyRange})
    let schema = [("friends", "++id,name,birthdate,sex"), ("pets", "++id,name,kind")]
    let version =
      dexie
      ->Dexie.version(1)
      ->DexieVersion.stores(schema)
      ->DexieVersion.upgrade(_tx => {
        let _ = 365 * 24 * 60 * 60 * 1000
      })

    Js.log(version)

    dexie->Dexie.opendb->ignore

    let friends = dexie->Dexie.table("friends")

    Js.log(friends.name)

    dexie->Dexie.closedb->ignore

    t->ok(true, "It is fine")
    done()
  })
}

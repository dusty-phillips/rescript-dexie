open Zora

type fakeIndexedDb

@module("fake-indexeddb/lib/FDBKeyRange.js") external fIDBKeyRange: 'keyrange = "default"
@new @module("fake-indexeddb/lib/FDBFactory.js")
external fdbFactory: unit => fakeIndexedDb = "default"

let default: zoraTestBlock = t => {
  t->test("factory makes two instances", t => {
    let idb = fdbFactory()
    let dexie = Dexie.make("hello dexie", ~options={"indexedDB": idb, "IDBKeyRange": fIDBKeyRange})
    Js.log(dexie)
    t->ok(true, "It is fine")
    done()
  })
}

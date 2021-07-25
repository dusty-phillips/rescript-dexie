open Zora

type fakeIndexedDb

@module("fake-indexeddb/lib/FDBKeyRange.js") external fIDBKeyRange: 'keyrange = "default"
@new @module("fake-indexeddb/lib/FDBFactory.js")
external fdbFactory: unit => fakeIndexedDb = "default"

type friend = {
  id: option<int>,
  name: string,
  sex: [#Male | #Female | #Nonbinary],
}

let default: zoraTestBlock = t => {
  t->test("Initialize version and upgrade", t => {
    let idb = fdbFactory()
    let dexie = Dexie.make("hello dexie", ~options={"indexedDB": idb, "IDBKeyRange": fIDBKeyRange})
    let schema = [("friends", "++id,name,birthdate,sex"), ("pets", "++id,name,kind")]
    dexie
    ->Dexie.version(1)
    ->DexieVersion.stores(schema)
    ->DexieVersion.upgrade(_tx => {
      let _ = 365 * 24 * 60 * 60 * 1000
    })
    ->ignore

    dexie->Dexie.opendb->ignore

    let friends: Table.t<friend> = dexie->Dexie.table("friends")
    t->equal(friends.name, "friends", "Table name should be `friends`")

    t->ok(true, "It is fine")
    friends
    ->Table.add({id: None, name: "Chris", sex: #Nonbinary})
    ->Promise.then(id => {
      t->equal(id, 1, "Id should be 1")
      done()
    })
    ->Promise.then(_ => {
      friends->Table.getById(1)
    })
    ->Promise.then(result => {
      t->equal(result.name, "Chris", "Returned friend should have same name")
      t->equal(result.sex, #Nonbinary, "Returned friend should have same name")
      done()
    })
  })
}

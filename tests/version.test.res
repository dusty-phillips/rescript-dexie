open Zora

type fakeIndexedDb

let p = Promise.then

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

    let friends: Table.t<friend, int> = dexie->Dexie.table("friends")
    t->equal(friends.name, "friends", "Table name should be `friends`")

    friends
    ->Table.add({id: None, name: "Chris", sex: #Nonbinary})
    ->p(id => {
      t->equal(id, 1, "Id should be 1")
      done()
    })
    ->p(_ => {
      friends->Table.getById(1)
    })
    ->p(result => {
      t->optionSome(result, (t, friend) => {
        t->equal(friend.name, "Chris", "Returned friend should have same name")
        t->equal(friend.sex, #Nonbinary, "Returned friend should have same sex")
      })
      friends->Table.getByCriteria({"name": "Chris"})
    })
    ->p(result => {
      t->optionSome(result, (t, friend) => {
        t->equal(friend.name, "Chris", "Returned friend should have same name")
        t->equal(friend.sex, #Nonbinary, "Returned friend should have same sex")
      })

      friends->Table.getById(5)
    })
    ->p(result => {
      t->optionNone(result, "result should be none")

      friends->Table.getByCriteria({"name": "nobody"})
    })
    ->p(result => {
      t->optionNone(result, "result should be none")

      friends->Table.bulkAdd([
        {id: None, name: "Samuel", sex: #Male},
        {id: None, name: "Samantha", sex: #Female},
      ])
    })
    ->p(ids => {
      t->equal(ids->Js.Array2.length, 2, "Should have added two ids")

      friends->Table.count
    })
    ->p(count => {
      t->equal(count, 3, "Should now have three entries")
      done()
    })
  })
}

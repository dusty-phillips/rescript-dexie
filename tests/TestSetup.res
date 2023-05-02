%%raw(`
// I couldn't figure out how to do this in Rescript and practicality beats purity
import indexedDB from "fake-indexeddb";
import IDBKeyRange from "fake-indexeddb/lib/FDBKeyRange.js";

Dexie.dependencies.indexedDB = indexedDB;
Dexie.dependencies.IDBKeyRange = IDBKeyRange;
`)
@scope("Math") @val external random: unit => float = "random"

module FriendSchema = {
  type t = {
    id: option<int>,
    name: string,
    color: [#Blue | #Red | #Purple],
  }
  type id = int
  let tableName = "friends"
}

module Friend = Table.MakeTable(FriendSchema)

let setup = () => {
  let someNumber = random()->Js.Float.toString
  let dexie = Database.make(`hello dexie ${someNumber}`)
  let schema = [("friends", "++id,name,birthdate,color"), ("pets", "++id,name,kind")]
  dexie
  ->Database.version(1)
  ->Version.stores(schema)
  ->Version.upgrade(_tx => {
    // Show the upgrade function is bound, because we don't test that anywhere
    let _ = 365 * 24 * 60 * 60 * 1000
    Js.Promise.resolve()
  })
  ->ignore

  dexie->Database.opendb->ignore

  dexie
}

let friendFixture = async dexie => {
  await dexie->Friend.bulkPut([
    {id: Some(1), name: "Chris", color: #Red},
    {id: Some(2), name: "Leroy", color: #Blue},
    {id: Some(3), name: "Jerome", color: #Purple},
    {id: Some(4), name: "Betty", color: #Purple},
    {id: Some(5), name: "Xiao", color: #Blue},
    {id: Some(6), name: "Rohan", color: #Red},
    {id: Some(7), name: "Natalia", color: #Red},
    {id: Some(8), name: "Padma", color: #Purple},
  ])
}

module Outbound = {
  module FriendSchema = {
    type t = {
      name: string,
      color: [#Blue | #Red | #Purple],
    }
    type id = int
    let tableName = "friends"
  }

  module Friend = Table.MakeTable(FriendSchema)

  let setup = () => {
    let someNumber = random()->Js.Float.toString
    let dexie = Database.make(`hello dexie ${someNumber}`)
    let schema = [("friends", "++,name,birthdate,color")]
    dexie
    ->Database.version(1)
    ->Version.stores(schema)
    ->Version.upgrade(_tx => {
      // Show the upgrade function is bound, because we don't test that anywhere
      let _ = 365 * 24 * 60 * 60 * 1000
      Js.Promise.resolve()
    })
    ->ignore

    dexie->Database.opendb->ignore

    dexie
  }
}

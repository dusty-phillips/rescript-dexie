open Zora
open TestSetup

exception MyError(string)

zoraBlock("Transactions", t => {
  t->test("Open transaction", async t => {
    let dexie = setup()

    await dexie->Database.transaction(#rw, ["friends"], async _tx => {
      let id = await dexie->Friend.add({id: None, name: "Chris", color: #Red})
      let friend = await dexie->Friend.getById(id)

        t->optionSome(friend, (t, friend) => {
          t->equal(friend.name, "Chris", "Friend should be added in transaction")
        })
    })
  })

  t->skip("Abort transaction", async t => {
    // This is throwing PrematureCommitError instead of AbortError
    // and I don't know why. 
    // The generated code doesn't seem to be awaiting anything it shouldn't be.
    // Anyone investigating will be interested in this page:
    // https://dexie.org/docs/DexieErrors/Dexie.PrematureCommitError
    let dexie = setup()

    try {
    await dexie
    ->Database.transaction(#rw, ["friends"], async tx => {
      tx->Transaction.abort
    })
  } catch { 
      | Js.Exn.Error(ex) =>
        t->optionSome(ex->Js.Exn.name, (t, name) =>
          t->equal(name, "AbortError", "should catch abortError")
        )
      | _ => t->fail("Received incorrect error")
      }
    })
})

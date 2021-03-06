open Zora
open TestSetup

exception MyError(string)

zoraBlock("Transactions", t => {
  t->test("Open transaction", t => {
    let dexie = setup()

    dexie->Database.transaction(#rw, ["friends"], _tx => {
      dexie
      ->Friend.add({id: None, name: "Chris", color: #Red})
      ->p(id => dexie->Friend.getById(id))
      ->pt(result => {
        t->optionSome(result, (t, friend) => {
          t->equal(friend.name, "Chris", "Friend should be added in transaction")
        })
      })
      ->ignore
    })
  })

  t->test("Abort transaction", t => {
    let dexie = setup()

    dexie
    ->Database.transaction(#rw, ["friends"], tx => {
      tx->Transaction.abort
    })
    ->Promise.catch(error => {
      switch error {
      | Promise.JsError(ex) =>
        t->optionSome(ex->Js.Exn.name, (t, name) =>
          t->equal(name, "AbortError", "should catch abortError")
        )
      | _ => t->fail("Received incorrect error")
      }
      done()
    })
  })
})

open Zora
open TestSetup

zora("Table commands", async t => {
  t->test("Test basic methods", async t => {
    let dexie = setup()

    t->equal(dexie->Database.isOpen, false, "Database should be closed")

    let id = await dexie->Friend.add({id: None, name: "Chris", color: #Purple})
    t->equal(id, 1, "Id should be 1")

    let result = await dexie->Friend.getById(1)
    t->optionSome(
      result,
      (t, friend) => {
        t->equal(friend.name, "Chris", "Returned friend should have same name")
        t->equal(friend.color, #Purple, "Returned friend should have same color")
      },
    )

    t->equal(dexie->Database.isOpen, true, "Database should be open")

    let result = await dexie->Friend.getByCriteria({"name": "Chris"})
    t->optionSome(
      result,
      (t, friend) => {
        t->equal(friend.name, "Chris", "Returned friend should have same name")
        t->equal(friend.color, #Purple, "Returned friend should have same color")
      },
    )

    let result = await dexie->Friend.getById(5)
    t->optionNone(result, "result should be none")

    let result = await dexie->Friend.getByCriteria({"name": "nobody"})
    t->optionNone(result, "result should be none")

    dexie->Friend.add({id: None, name: "Sam", color: #Blue})->ignore

    let id = await dexie->Friend.put({id: Some(3), name: "Jess", color: #Red})
    t->equal(id, 3, "Should have added a third friend")

    let result = await dexie->Friend.getById(3)
    t->optionSome(
      result,
      (t, friend) => {
        t->equal(friend.name, "Jess", "Name should be what was set")
        t->equal(friend.color, #Red, "Color should be what was set")
      },
    )

    let id = await dexie->Friend.put({id: Some(3), name: "Jess", color: #Blue})
    t->equal(id, 3, "Should have updated the third friend")

    let result = await dexie->Friend.getById(3)
    t->optionSome(
      result,
      (t, friend) => {
        t->equal(friend.name, "Jess", "Name should not have changed")
        t->equal(friend.color, #Blue, "Color should have changed")
      },
    )

    await dexie->Friend.delete(1)
    let count = await dexie->Friend.count
    t->equal(count, 2, "Should now have two entries")

    let id = await dexie->Friend.put({id: None, name: "Nora", color: #Red})
    t->equal(id, 4, "Should successfully add and increment id with put")

    let updated = await dexie->Friend.update(4, {"color": #Purple})
    t->equal(updated, 1, "Should have updated one row")

    let result = await dexie->Friend.getById(4)
    t->optionSome(
      result,
      (t, friend) => {
        t->equal(friend.color, #Purple, "Color should have changed")
      },
    )

    let result = await dexie->Friend.findByCriteria({"color": #Purple})->Collection.toArray
    t->equal(result->Belt.Array.length, 1, "Should be one #Purple person in array")

    let resultArray = await dexie->Friend.where("name")->Where.equals("Jess")->Collection.toArray
    let jess: Friend.t = {id: Some(3), name: "Jess", color: #Blue}
    t->equal(resultArray, [jess], "Should have the one matching element")

    let resultArray = await dexie->Friend.toCollection->Collection.toArray
    t->equal(
      resultArray,
      [
        {id: Some(2), name: "Sam", color: #Blue},
        {id: Some(3), name: "Jess", color: #Blue},
        {id: Some(4), name: "Nora", color: #Purple},
      ],
      "Should contain all the elements",
    )
  })

  t->test("Test bulk methods", async t => {
    let dexie = setup()

    let ids =
      await dexie->Friend.bulkAdd([
        {id: None, name: "Chris", color: #Purple},
        {id: None, name: "Samuel", color: #Blue},
        {id: None, name: "Samantha", color: #Red},
      ])
    t->equal(ids->Js.Array2.length, 3, "Should have added two ids")

    let count = await dexie->Friend.count
    t->equal(count, 3, "Should now have three entries")

    let result = await dexie->Friend.bulkGet([1, 2, 999])
    t->equal(result->Js.Array.length, 3, "Should have retrieved two ids")
    t->optionSome(
      result[0],
      (t, friend) => t->equal(friend.name, "Chris", "First array result should be Chris"),
    )
    t->optionNone(result[2], "Third result should be undefined")

    await dexie->Friend.bulkDelete([2, 3, 99])
    let count = await dexie->Friend.count
    t->equal(count, 1, "Should have deleted two of three entries")

    (await dexie
    ->Friend.bulkPut([
      {id: Some(1), name: "Jerome", color: #Blue},
      {id: None, name: "Kim", color: #Purple},
      {id: Some(8), name: "Tyrone", color: #Blue},
    ]))
    ->ignore
    let count = await dexie->Friend.count
    t->equal(count, 3, "Should have replaced one and added two entries")
  })

  t->test("Test toArray method", async t => {
    let dexie = setup()

    open TestSetup.FriendSchema

    let friends = [
      {id: Some(1), name: "Chris", color: #Purple},
      {id: Some(2), name: "Samuel", color: #Blue},
      {id: Some(3), name: "Samantha", color: #Red},
    ]

    (await dexie->Friend.bulkAdd(friends))->ignore
    let result = await Friend.toArray(dexie)
    t->equal(result, friends, "Should list all friends")

    await dexie->Friend.bulkDelete([1, 2, 3])
  })

  t->test("Test methods with ids", async t => {
    let dexie = Outbound.setup()

    let id = await dexie->Outbound.Friend.add({name: "Chris", color: #Purple}, ~id=2)
    t->equal(id, 2, "Id should be 2")

    let result = await dexie->Outbound.Friend.getById(2)
    t->optionSome(
      result,
      (t, friend) => {
        t->equal(friend.name, "Chris", "Returned friend should have same name")
        t->equal(friend.color, #Purple, "Returned friend should have same color")
      },
    )

    let id = await dexie->Outbound.Friend.put({name: "Chris", color: #Blue}, ~id=2)
    t->equal(id, 2, "Id should still be 2")

    let result = await dexie->Outbound.Friend.getById(2)
    t->optionSome(
      result,
      (t, friend) => {
        t->equal(friend.name, "Chris", "Returned friend should have same name")
        t->equal(friend.color, #Blue, "Returned friend should have new color")
      },
    )
  })
})

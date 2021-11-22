open Zora
open TestSetup

zora("Table commands", t => {
  t->test("Test basic methods", t => {
    let dexie = setup()

    dexie
    ->Friend.add({id: None, name: "Chris", color: #Purple})
    ->p(id => {
      t->equal(id, 1, "Id should be 1")
      dexie->Friend.getById(1)
    })
    ->p(result => {
      t->optionSome(result, (t, friend) => {
        t->equal(friend.name, "Chris", "Returned friend should have same name")
        t->equal(friend.color, #Purple, "Returned friend should have same color")
      })

      dexie->Friend.getByCriteria({"name": "Chris"})
    })
    ->p(result => {
      t->optionSome(result, (t, friend) => {
        t->equal(friend.name, "Chris", "Returned friend should have same name")
        t->equal(friend.color, #Purple, "Returned friend should have same color")
      })

      dexie->Friend.getById(5)
    })
    ->p(result => {
      t->optionNone(result, "result should be none")

      dexie->Friend.getByCriteria({"name": "nobody"})
    })
    ->p(result => {
      t->optionNone(result, "result should be none")

      dexie->Friend.add({id: None, name: "Sam", color: #Blue})->ignore
      dexie->Friend.put({id: Some(3), name: "Jess", color: #Red})
    })
    ->p(id => {
      t->equal(id, 3, "Should have added a third friend")

      dexie->Friend.getById(3)
    })
    ->p(result => {
      t->optionSome(result, (t, friend) => {
        t->equal(friend.name, "Jess", "Name should be what was set")
        t->equal(friend.color, #Red, "Color should be what was set")
      })
      dexie->Friend.put({id: Some(3), name: "Jess", color: #Blue})
    })
    ->p(id => {
      t->equal(id, 3, "Should have updated the third friend")

      dexie->Friend.getById(3)
    })
    ->p(result => {
      t->optionSome(result, (t, friend) => {
        t->equal(friend.name, "Jess", "Name should not have changed")
        t->equal(friend.color, #Blue, "Color should have changed")
      })

      dexie->Friend.delete(1)
    })
    ->p(_ => {
      dexie->Friend.count
    })
    ->p(count => {
      t->equal(count, 2, "Should now have two entries")

      dexie->Friend.put({id: None, name: "Nora", color: #Red})
    })
    ->p(id => {
      t->equal(id, 4, "Should successfully add and increment id with put")

      dexie->Friend.update(4, {"color": #Purple})
    })
    ->p(updated => {
      t->equal(updated, 1, "Should have updated one row")

      dexie->Friend.getById(4)
    })
    ->pt(result => {
      t->optionSome(result, (t, friend) => {
        t->equal(friend.color, #Purple, "Color should have changed")
      })

      dexie->Friend.findByCriteria({"color": #Purple})
    })
    ->p(Collection.toArray)
    ->p(result => {
      t->equal(result->Belt.Array.length, 1, "Should be one #Purple person in array")
      dexie->Friend.where("name")->Where.equals("Jess")->Collection.toArray
    })
    ->pt(array => {
      let jess: Friend.t = {id: Some(3), name: "Jess", color: #Blue}
      t->equal(array, [jess], "Should have the one matching element")
    })
  })

  t->test("Test bulk methods", t => {
    let dexie = setup()

    dexie
    ->Friend.bulkAdd([
      {id: None, name: "Chris", color: #Purple},
      {id: None, name: "Samuel", color: #Blue},
      {id: None, name: "Samantha", color: #Red},
    ])
    ->p(ids => {
      t->equal(ids->Js.Array2.length, 3, "Should have added two ids")

      dexie->Friend.count
    })
    ->p(count => {
      t->equal(count, 3, "Should now have three entries")

      dexie->Friend.bulkGet([1, 2, 999])
    })
    ->p(result => {
      t->equal(result->Js.Array.length, 3, "Should have retrieved two ids")
      t->optionSome(result[0], (t, friend) =>
        t->equal(friend.name, "Chris", "First array result should be Chris")
      )
      t->optionNone(result[2], "Third result should be undefined")

      dexie->Friend.bulkDelete([2, 3, 99])
    })
    ->p(_ => {
      dexie->Friend.count
    })
    ->p(count => {
      t->equal(count, 1, "Should have deleted two of three entries")

      dexie->Friend.bulkPut([
        {id: Some(1), name: "Jerome", color: #Blue},
        {id: None, name: "Kim", color: #Purple},
        {id: Some(8), name: "Tyrone", color: #Blue},
      ])
    })
    ->p(_ => {
      dexie->Friend.count
    })
    ->pt(count => {
      t->equal(count, 3, "Should have replaced one and added two entries")
    })
  })

  t->test("Test toArray method", t => {
    let dexie = setup()

    open TestSetup.FriendSchema

    let friends = [
      {id: Some(1), name: "Chris", color: #Purple},
      {id: Some(2), name: "Samuel", color: #Blue},
      {id: Some(3), name: "Samantha", color: #Red},
    ]

    dexie
    ->Friend.bulkAdd(friends)
    ->p(_ => {
      dexie->Friend.toArray
    })
    ->p(result => {
      t->equal(result, friends, "Should list all friends")

      dexie->Friend.bulkDelete([1, 2, 3])
    })
  })

  done()
})

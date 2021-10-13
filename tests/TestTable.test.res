open Zora
open TestSetup

zora("Table commands", t => {
  t->test("Test basic methods", t => {
    let dexie = setup()

    let friends: Table.t<friend, int> = dexie->Database.table("friends")
    t->equal(friends.name, "friends", "Table name should be `friends`")

    friends
    ->Table.add({id: None, name: "Chris", color: #Purple})
    ->p(id => {
      t->equal(id, 1, "Id should be 1")
      friends->Table.getById(1)
    })
    ->p(result => {
      t->optionSome(result, (t, friend) => {
        t->equal(friend.name, "Chris", "Returned friend should have same name")
        t->equal(friend.color, #Purple, "Returned friend should have same color")
      })

      friends->Table.getByCriteria({"name": "Chris"})
    })
    ->p(result => {
      t->optionSome(result, (t, friend) => {
        t->equal(friend.name, "Chris", "Returned friend should have same name")
        t->equal(friend.color, #Purple, "Returned friend should have same color")
      })

      friends->Table.getById(5)
    })
    ->p(result => {
      t->optionNone(result, "result should be none")

      friends->Table.getByCriteria({"name": "nobody"})
    })
    ->p(result => {
      t->optionNone(result, "result should be none")

      friends->Table.add({id: None, name: "Sam", color: #Blue})->ignore
      friends->Table.put({id: Some(3), name: "Jess", color: #Red})
    })
    ->p(id => {
      t->equal(id, 3, "Should have added a third friend")

      friends->Table.getById(3)
    })
    ->p(result => {
      t->optionSome(result, (t, friend) => {
        t->equal(friend.name, "Jess", "Name should be what was set")
        t->equal(friend.color, #Red, "Color should be what was set")
      })
      friends->Table.put({id: Some(3), name: "Jess", color: #Blue})
    })
    ->p(id => {
      t->equal(id, 3, "Should have updated the third friend")

      friends->Table.getById(3)
    })
    ->p(result => {
      t->optionSome(result, (t, friend) => {
        t->equal(friend.name, "Jess", "Name should not have changed")
        t->equal(friend.color, #Blue, "Color should have changed")
      })

      friends->Table.delete(1)
    })
    ->p(_ => {
      friends->Table.count
    })
    ->p(count => {
      t->equal(count, 2, "Should now have two entries")

      friends->Table.put({id: None, name: "Nora", color: #Red})
    })
    ->p(id => {
      t->equal(id, 4, "Should successfully add and increment id with put")

      friends->Table.update(4, {"color": #Purple})
    })
    ->p(updated => {
      t->equal(updated, 1, "Should have updated one row")

      friends->Table.getById(4)
    })
    ->pt(result => {
      t->optionSome(result, (t, friend) => {
        t->equal(friend.color, #Purple, "Color should have changed")
      })

      friends->Table.findeByCriteria({"color": #Purple})
    })
    ->p(Collection.toArray)
    ->p(result => {
      t->equal(result->Belt.Array.length, 1, "Should be one #Purple person in array")
      friends->Table.where("name")->Where.equals("Jess")->Collection.toArray
    })
    ->pt(array =>
      t->equal(
        array,
        [{TestSetup.id: Some(3), name: "Jess", color: #Blue}],
        "Should have the one matching element",
      )
    )
  })

  t->test("Test bulk methods", t => {
    let dexie = setup()
    let friends: Table.t<friend, int> = dexie->Database.table("friends")

    friends
    ->Table.bulkAdd([
      {id: None, name: "Chris", color: #Purple},
      {id: None, name: "Samuel", color: #Blue},
      {id: None, name: "Samantha", color: #Red},
    ])
    ->p(ids => {
      t->equal(ids->Js.Array2.length, 3, "Should have added two ids")

      friends->Table.count
    })
    ->p(count => {
      t->equal(count, 3, "Should now have three entries")

      friends->Table.bulkGet([1, 2, 999])
    })
    ->p(result => {
      t->equal(result->Js.Array.length, 3, "Should have retrieved two ids")
      t->optionSome(result[0], (t, friend) =>
        t->equal(friend.name, "Chris", "First array result should be Chris")
      )
      t->optionNone(result[2], "Third result should be undefined")

      friends->Table.bulkDelete([2, 3, 99])
    })
    ->p(_ => {
      friends->Table.count
    })
    ->p(count => {
      t->equal(count, 1, "Should have deleted two of three entries")

      friends->Table.bulkPut([
        {id: Some(1), name: "Jerome", color: #Blue},
        {id: None, name: "Kim", color: #Purple},
        {id: Some(8), name: "Tyrone", color: #Blue},
      ])
    })
    ->p(_ => {
      friends->Table.count
    })
    ->pt(count => {
      t->equal(count, 3, "Should have replaced one and added two entries")
    })
  })

  done()
})

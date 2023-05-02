open Zora
open TestSetup

zora("Collection", async t => {
  t->test("retreival functions", async t => {
    let dexie = setup()
    (await dexie->friendFixture)->ignore

    let collection = dexie->Friend.findByCriteria({"color": #Purple})

    t->test(
      "count function",
      async t => {
        let count = await collection->Collection.clone->Collection.count
        t->equal(count, 3, "3 Purple Elements")
      },
    )
    t->test(
      "first function",
      async t => {
        let first = await collection->Collection.clone->Collection.first
        t->optionSome(
          first,
          (t, friend) => {
            let jerome: Friend.t = {id: Some(3), name: "Jerome", color: #Purple}
            t->equal(friend, jerome, "First friend should be Betty")
          },
        )
      },
    )

    t->test(
      "toArray",
      async t => {
        let array = await collection->Collection.clone->Collection.toArray
        let expected: array<Friend.t> = [
          {id: Some(3), name: "Jerome", color: #Purple},
          {id: Some(4), name: "Betty", color: #Purple},
          {id: Some(8), name: "Padma", color: #Purple},
        ]
        t->equal(array, expected, "Should have the three friends that chose purple")
      },
    )
    t->test(
      "each function",
      async t =>
        await collection
        ->Collection.clone
        ->Collection.each(
          (friend, _) => {
            t->equal(friend.color, #Purple, "Each friend should choose purple")
          },
        ),
    )
    t->test(
      "last function",
      async t => {
        let last = await collection->Collection.clone->Collection.last
        t->optionSome(
          last,
          (t, friend) => t->equal(friend.name, "Padma", "Last friend should be Padma"),
        )
      },
    )
    t->test(
      "sortBy function",
      async t => {
        let array = await collection->Collection.clone->Collection.sortBy("name")
        let expected: array<Friend.t> = [
          {id: Some(4), name: "Betty", color: #Purple},
          {id: Some(3), name: "Jerome", color: #Purple},
          {id: Some(8), name: "Padma", color: #Purple},
        ]
        t->equal(array, expected, "Array should be sorted by name")
      },
    )
  })
  t->test("mutation functions", async t => {
    t->test(
      "delete function",
      async t => {
        let dexie = setup()

        (await dexie->friendFixture)->ignore
        await dexie->Friend.findByCriteria({"color": #Purple})->Collection.delete
        let count = await dexie->Friend.count
        t->equal(count, 5, "Should be down to 5 friends")
      },
    )
  })
  t->test("modify function", async t => {
    let dexie = setup()
    (await dexie->friendFixture)->ignore
    let num_changed =
      await dexie->Friend.findByCriteria({"color": #Purple})->Collection.modify({"color": #Blue})
    t->equal(num_changed, 3, "Should have changed all three items")
    let count = await dexie->Friend.findByCriteria({"color": #Blue})->Collection.count
    t->equal(count, 5, "Should now have five frineds who chose blue")

    let count = await dexie->Friend.findByCriteria({"color": #Purple})->Collection.count
    t->equal(count, 0, "Should not be any friends who chose purple")
  })

  t->test("Collection operation functions (they return self)", async t => {
    let dexie = setup()
    (await dexie->friendFixture)->ignore
    (await dexie
    ->Friend.bulkPut([
      {id: Some(9), name: "Padma", color: #Purple},
      {id: Some(10), name: "Leroy", color: #Blue},
    ]))
    ->ignore

    let collection = dexie->Friend.findByCriteria({"color": #Purple})
    t->test(
      "Filter function",
      async t => {
        let array =
          await collection
          ->Collection.clone
          ->Collection.filter(f => f.name != "Padma")
          ->Collection.toArray
        t->equal(array->Array.length, 2, "Should only have two elements, the ones not named Padma")
      },
    )
    t->test(
      "Offset function",
      async t => {
        let array = await collection->Collection.clone->Collection.offset(2)->Collection.toArray
        let expected: array<Friend.t> = [
          {id: Some(8), name: "Padma", color: #Purple},
          {id: Some(9), name: "Padma", color: #Purple},
        ]
        t->equal(array, expected, "Should not have first three entries")
      },
    )
    t->test(
      "Limit function",
      async t => {
        let array = await collection->Collection.clone->Collection.limit(2)->Collection.toArray
        let expected: array<Friend.t> = [
          {id: Some(3), name: "Jerome", color: #Purple},
          {id: Some(4), name: "Betty", color: #Purple},
        ]
        t->equal(array, expected, "Should not have first three entries")
      },
    )
    t->test(
      "Until function",
      async t => {
        let array =
          await collection
          ->Collection.clone
          ->Collection.until(f => f.name == "Padma")
          ->Collection.toArray
        let expected: array<Friend.t> = [
          {id: Some(3), name: "Jerome", color: #Purple},
          {id: Some(4), name: "Betty", color: #Purple},
        ]
        t->equal(array, expected, "Should not have first three entries")
      },
    )
  })
})

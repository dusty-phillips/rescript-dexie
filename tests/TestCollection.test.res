open Zora
open TestSetup

let p = Promise.then
let pt = Promise.thenResolve

zora("Collection", t => {
  t->test("retreival functions", t => {
    let dexie = setup()
    dexie
    ->friendFixture
    ->pt(_ => dexie->Friend.findByCriteria({"color": #Purple}))
    ->p(collection => {
      t->test("count function", t =>
        collection
        ->Collection.clone
        ->Collection.count
        ->pt(count => t->equal(count, 3, "3 Purple Elements"))
      )
      t->test("first function", t =>
        collection
        ->Collection.clone
        ->Collection.first
        ->pt(first =>
          t->optionSome(first, (t, friend) => {
            let jerome: Friend.t = {id: Some(3), name: "Jerome", color: #Purple}
            t->equal(friend, jerome, "First friend should be Betty")
          })
        )
      )
      t->test("toArray", t =>
        collection
        ->Collection.clone
        ->Collection.toArray
        ->pt(array => {
          let expected: array<Friend.t> = [
            {id: Some(3), name: "Jerome", color: #Purple},
            {id: Some(4), name: "Betty", color: #Purple},
            {id: Some(8), name: "Padma", color: #Purple},
          ]
          t->equal(array, expected, "Should have the three friends that chose purple")
        })
      )
      t->test("each function", t =>
        collection
        ->Collection.clone
        ->Collection.each((friend, _) => {
          t->equal(friend.color, #Purple, "Each friend should choose purple")
        })
      )
      t->test("last function", t =>
        collection
        ->Collection.clone
        ->Collection.last
        ->pt(last =>
          t->optionSome(last, (t, friend) =>
            t->equal(friend.name, "Padma", "Last friend should be Padma")
          )
        )
      )
      t->test("sortBy function", t =>
        collection
        ->Collection.clone
        ->Collection.sortBy("name")
        ->pt(array => {
          let expected: array<Friend.t> = [
            {id: Some(4), name: "Betty", color: #Purple},
            {id: Some(3), name: "Jerome", color: #Purple},
            {id: Some(8), name: "Padma", color: #Purple},
          ]
          t->equal(array, expected, "Array should be sorted by name")
        })
      )
      done()
    })
  })
  t->test("mutation functions", t => {
    t->test("delete function", t => {
      let dexie = setup()

      dexie
      ->friendFixture
      ->p(_ => {
        dexie
        ->Friend.findByCriteria({"color": #Purple})
        ->Collection.delete
        ->p(_ => dexie->Friend.count)
        ->pt(count => t->equal(count, 5, "Should be down to 5 friends"))
      })
    })
    t->test("modify function", t => {
      let dexie = setup()
      dexie
      ->friendFixture
      ->p(_ => {
        dexie
        ->Friend.findByCriteria({"color": #Purple})
        ->Collection.modify({"color": #Blue})
        ->p(num_changed => {
          t->equal(num_changed, 3, "Should have changed all three items")
          dexie->Friend.findByCriteria({"color": #Blue})->Collection.count
        })
        ->p(count => {
          t->equal(count, 5, "Should now have five frineds who chose blue")
          dexie->Friend.findByCriteria({"color": #Purple})->Collection.count
        })
        ->pt(count => t->equal(count, 0, "Should not be any friends who chose purple"))
      })
    })
    done()
  })
  t->test("Collection operation functions (they return self)", t => {
    let dexie = setup()
    dexie
    ->friendFixture
    ->p(_ =>
      dexie
      ->Friend.bulkPut([
        {id: Some(9), name: "Padma", color: #Purple},
        {id: Some(10), name: "Leroy", color: #Blue},
      ])
      ->pt(_ => dexie->Friend.findByCriteria({"color": #Purple}))
      ->p(collection => {
        t->test("Filter function", t =>
          collection
          ->Collection.clone
          ->Collection.filter(f => f.name != "Padma")
          ->Collection.toArray
          ->pt(array =>
            t->equal(
              array->Array.length,
              2,
              "Should only have two elements, the ones not named Padma",
            )
          )
        )
        t->test("Offset function", t =>
          collection
          ->Collection.clone
          ->Collection.offset(2)
          ->Collection.toArray
          ->pt(array => {
            let expected: array<Friend.t> = [
              {id: Some(8), name: "Padma", color: #Purple},
              {id: Some(9), name: "Padma", color: #Purple},
            ]
            t->equal(array, expected, "Should not have first three entries")
          })
        )
        t->test("Limit function", t =>
          collection
          ->Collection.clone
          ->Collection.limit(2)
          ->Collection.toArray
          ->pt(array => {
            let expected: array<Friend.t> = [
              {id: Some(3), name: "Jerome", color: #Purple},
              {id: Some(4), name: "Betty", color: #Purple},
            ]
            t->equal(array, expected, "Should not have first three entries")
          })
        )
        t->test("Until function", t =>
          collection
          ->Collection.clone
          ->Collection.until(f => f.name == "Padma")
          ->Collection.toArray
          ->pt(array => {
            let expected: array<Friend.t> = [
              {id: Some(3), name: "Jerome", color: #Purple},
              {id: Some(4), name: "Betty", color: #Purple},
            ]
            t->equal(array, expected, "Should not have first three entries")
          })
        )
        done()
      })
    )
  })
  done()
})

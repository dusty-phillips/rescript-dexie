open Zora
open TestSetup

let p = Promise.then
let pt = Promise.thenResolve

zora("Collection", t => {
  t->test("retreival functions", t => {
    let dexie = setup()
    dexie
    ->friendFixture
    ->pt(friends => friends->Table.findeByCriteria({"color": #Purple}))
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
          t->optionSome(first, (t, friend) =>
            t->equal(
              friend,
              {TestSetup.id: Some(3), name: "Jerome", color: #Purple},
              "First friend should be Betty",
            )
          )
        )
      )
      t->test("toArray", t =>
        collection
        ->Collection.clone
        ->Collection.toArray
        ->pt(array => {
          t->equal(
            array,
            [
              {TestSetup.id: Some(3), name: "Jerome", color: #Purple},
              {TestSetup.id: Some(4), name: "Betty", color: #Purple},
              {TestSetup.id: Some(8), name: "Padma", color: #Purple},
            ],
            "Should have the three friends that chose purple",
          )
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
          t->equal(
            array,
            [
              {TestSetup.id: Some(4), name: "Betty", color: #Purple},
              {TestSetup.id: Some(3), name: "Jerome", color: #Purple},
              {TestSetup.id: Some(8), name: "Padma", color: #Purple},
            ],
            "Array should be sorted by name",
          )
        })
      )
      done()
    })
  })
  t->test("mutation functions", t => {
    t->test("delete function", t =>
      setup()
      ->friendFixture
      ->p(friends => {
        friends
        ->Table.findeByCriteria({"color": #Purple})
        ->Collection.delete
        ->p(_ => friends->Table.count)
        ->pt(count => t->equal(count, 5, "Should be down to 5 friends"))
      })
    )
    t->test("modify function", t =>
      setup()
      ->friendFixture
      ->p(friends => {
        friends
        ->Table.findeByCriteria({"color": #Purple})
        ->Collection.modify({"color": #Blue})
        ->p(num_changed => {
          t->equal(num_changed, 3, "Should have changed all three items")
          friends->Table.findeByCriteria({"color": #Blue})->Collection.count
        })
        ->p(count => {
          t->equal(count, 5, "Should now have five frineds who chose blue")
          friends->Table.findeByCriteria({"color": #Purple})->Collection.count
        })
        ->pt(count => t->equal(count, 0, "Should not be any friends who chose purple"))
      })
    )
    done()
  })
  t->test("Collection operation functions (they return self)", t => {
    setup()
    ->friendFixture
    ->p(friends =>
      friends
      ->Table.bulkPut([
        {id: Some(9), name: "Padma", color: #Purple},
        {id: Some(10), name: "Leroy", color: #Blue},
      ])
      ->pt(_ => friends->Table.findeByCriteria({"color": #Purple}))
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
          ->pt(array =>
            t->equal(
              array,
              [
                {TestSetup.id: Some(8), name: "Padma", color: #Purple},
                {TestSetup.id: Some(9), name: "Padma", color: #Purple},
              ],
              "Should not have first three entries",
            )
          )
        )
        t->test("Limit function", t =>
          collection
          ->Collection.clone
          ->Collection.limit(2)
          ->Collection.toArray
          ->pt(array =>
            t->equal(
              array,
              [
                {TestSetup.id: Some(3), name: "Jerome", color: #Purple},
                {TestSetup.id: Some(4), name: "Betty", color: #Purple},
              ],
              "Should not have first three entries",
            )
          )
        )
        t->test("Until function", t =>
          collection
          ->Collection.clone
          ->Collection.until(f => f.name == "Padma")
          ->Collection.toArray
          ->pt(array =>
            t->equal(
              array,
              [
                {TestSetup.id: Some(3), name: "Jerome", color: #Purple},
                {TestSetup.id: Some(4), name: "Betty", color: #Purple},
              ],
              "Should not have first three entries",
            )
          )
        )
        done()
      })
    )
  })
  done()
})

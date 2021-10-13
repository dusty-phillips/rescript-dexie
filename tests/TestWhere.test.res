open Zora
open TestSetup

zora("Where clauses", t => {
  let dexie = setup()
  dexie
  ->friendFixture
  ->p(_ => {
    dexie
    ->Friend.where("name")
    ->Where.equals("Chris")
    ->Collection.toArray
    ->p(chris => {
      t->equal(chris, [{id: Some(1), name: "Chris", color: #Red}], "should be Chris")

      dexie->Friend.where("name")->Where.equalsIgnoreCase("chris")->Collection.toArray
    })
    ->p(chris => {
      t->equal(chris, [{id: Some(1), name: "Chris", color: #Red}], "should be Chris")

      dexie->Friend.where("id")->Where.above(Some(5))->Collection.toArray
    })
    ->p(items => {
      t->equal(
        items,
        [
          {id: Some(6), name: "Rohan", color: #Red},
          {id: Some(7), name: "Natalia", color: #Red},
          {id: Some(8), name: "Padma", color: #Purple},
        ],
        "Should have the last three items",
      )

      dexie->Friend.where("id")->Where.aboveOrEqual(Some(6))->Collection.toArray
    })
    ->p(items => {
      t->equal(
        items,
        [
          {id: Some(6), name: "Rohan", color: #Red},
          {id: Some(7), name: "Natalia", color: #Red},
          {id: Some(8), name: "Padma", color: #Purple},
        ],
        "Should have the last three items",
      )
      dexie->Friend.where("id")->Where.below(Some(3))->Collection.toArray
    })
    ->p(items => {
      t->equal(
        items,
        [{id: Some(1), name: "Chris", color: #Red}, {id: Some(2), name: "Leroy", color: #Blue}],
        "Should have the first two items",
      )
      dexie->Friend.where("id")->Where.belowOrEqual(Some(2))->Collection.toArray
    })
    ->p(items => {
      t->equal(
        items,
        [{id: Some(1), name: "Chris", color: #Red}, {id: Some(2), name: "Leroy", color: #Blue}],
        "Should have the first two items",
      )

      dexie->Friend.where("name")->Where.anyOf(["Leroy", "Rohan"])->Collection.toArray
    })
    ->p(items => {
      t->equal(
        items,
        [{id: Some(2), name: "Leroy", color: #Blue}, {id: Some(6), name: "Rohan", color: #Red}],
        "Should have the two selected items",
      )
      dexie->Friend.where("name")->Where.anyOfIgnoreCase(["leRoy", "roHan"])->Collection.toArray
    })
    ->p(items => {
      t->equal(
        items,
        [{id: Some(2), name: "Leroy", color: #Blue}, {id: Some(6), name: "Rohan", color: #Red}],
        "Should have the two selected items",
      )
      dexie->Friend.where("name")->Where.notEqual("Rohan")->Collection.toArray
    })
    ->p(items => {
      t->equal(items->Array.length, 7, "should only contain 7 items")

      dexie->Friend.where("name")->Where.noneOf(["Rohan", "Chris", "Natalia"])->Collection.toArray
    })
    ->p(items => {
      t->equal(items->Array.length, 5, "should only contain 5 items")

      dexie->Friend.where("name")->Where.startsWith("Le")->Collection.toArray
    })
    ->p(items => {
      t->equal(items, [{id: Some(2), name: "Leroy", color: #Blue}], "Should start with Le")

      dexie->Friend.where("name")->Where.startsWithAnyOf(["Le", "Na"])->Collection.toArray
    })
    ->p(items => {
      t->equal(
        items,
        [{id: Some(2), name: "Leroy", color: #Blue}, {id: Some(7), name: "Natalia", color: #Red}],
        "Should start with Le and Na",
      )

      dexie->Friend.where("name")->Where.startsWithIgnoreCase("le")->Collection.toArray
    })
    ->p(items => {
      t->equal(items, [{id: Some(2), name: "Leroy", color: #Blue}], "Should start with Le")

      dexie->Friend.where("name")->Where.startsWithAnyOfIgnoreCase(["le", "na"])->Collection.toArray
    })
    ->p(items => {
      t->equal(
        items,
        [{id: Some(2), name: "Leroy", color: #Blue}, {id: Some(7), name: "Natalia", color: #Red}],
        "Should start with le and na",
      )

      dexie->Friend.where("name")->Where.inAnyRange([["Le", "Op"]])->Collection.toArray
    })
    ->p(items => {
      t->equal(
        items,
        [{id: Some(2), name: "Leroy", color: #Blue}, {id: Some(7), name: "Natalia", color: #Red}],
        "Should be in range",
      )

      dexie
      ->Friend.where("id")
      ->Where.inAnyRange(
        [[Some(1), Some(4)], [Some(6), Some(7)]],
        ~options={includeLowers: false, includeUppers: true},
      )
      ->Collection.toArray
    })
    ->p(items => {
      Js.log(items)
      t->equal(
        items,
        [
          {id: Some(2), name: "Leroy", color: #Blue},
          {id: Some(3), name: "Jerome", color: #Purple},
          {id: Some(4), name: "Betty", color: #Purple},
          {id: Some(7), name: "Natalia", color: #Red},
        ],
        "Should be in Range with options",
      )

      done()
    })
  })
})

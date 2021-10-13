# Rescript-Dexie

Rescript bindings to the easy-to-use [Dexie](https://dexie.org) wrapper of IndexedDB.

These bindings are not complete, but everything required for basic IndexedDB
access should be working, including:

- Define fully typed table schemas
- Version and upgrade schemas
- Create, update, delete records (including bulk operations)
- Query by index
- Query using criteria
- Query using where clauses
- Perform operations on the resulting Collections
- Execute inside Transactions
- React live queries (optional, with `dexie-react-hooks` installed)

Some of the more complex pieces of Dexie are missing from these bindings:

- Translation of Dexie's JS error types into a Rescript-friendly paradigm
- Dexie Hooks API or DBCore Middleware
- Syncables
- Addons, including Dexie Cloud

A couple things I haven't tested yet:

- Not sure if things like compound primary keys are working
- Probably schema upgrades will get confused when dealing with 'before' and 'after' types

## Quick Start

Start by defining a small module for each table in your database, that
describes the type of the `id` field, the structure of each record, and
the name of the table:

```rescript
module FriendSchema = {
  type id = int
  type t = {
    id: option<int>,
    name: string,
    color: [#Blue | #Red | #Purple],
  }
  let tableName = "friends"
}
```

Use the `MakeTable` functor to create a table for each schema:

```rescript
module Friend = Dexie.Table.MakeTable(FriendSchema)
```

Construct a Dexie instance with the IndexedDB name:

```rescript
let dexie = Dexie.Database.make(`hello dexie ${someNumber}`)
```

Describe the [Dexie schema](https://dexie.org/docs/Version/Version.stores) for
each of your tables using an array of `(name, schema)` tuples:

```rescript
let schema = [("friends", "++id,name,birthdate,color"), ...]
```

Create your initial version of the database and open it:

```rescript
dexie
->Dexie.Database.version(1)
->Dexie.Version.stores(schema)
->ignore

dexie->Dexie.Database.opendb->ignore
```

Add and query your tables using the module you created with the
`MakeTable` functor. Most operations return Promises, so become
familiar with [ryyppy's Promise library](https://github.com/ryyppy/rescript-promise).

Some things you can do:

```rescript
dexie->Friend.bulkPut([
  {id: Some(1), name: "Chris", color: #Red},
  {id: Some(2), name: "Leroy", color: #Blue},
  {id: Some(3), name: "Jerome", color: #Purple},
  {id: Some(4), name: "Betty", color: #Purple},
])

dexie->Friend.add(None, name: "Xiao", color: #Blue)

dexie->Friend.getById(3)->Promise.then(friendOption => ...)

dexie
->Friend.where("name")
->Dexie.Where.anyOfIgnoreCase(["Leroy", "Xiao"])
->Dexie.Collection.first
->Promise.then(friend=> ...)
```

React [live query](<https://dexie.org/docs/dexie-react-hooks/useLiveQuery()>)
hooks are also supported if you `yarn add dexie-react-hooks`:

```rescript
let teamBlue = Dexie.LiveQuery.use0(() => {
  dexie->Friend.findByCriteria({color: #Blue})
})
```

There are hooks `use0` through `use7` that behave similarly to rescript-react's
[useEffect](https://rescript-lang.org/docs/react/latest/hooks-effect)
modelling.

## Next Steps

I haven't documented this as thoroughly as I normally do in my projects. For
the most part, follow [Dexie's excellent
documentation](https://dexie.org/docs/) and assume the Rescript bindings are
sane (or completely unavailable).

You can also refer to the [unit
tests](https://github.com/dusty-phillips/rescript-dexie/tree/main/tests) to get
a better idea of the things you can do with the bindings.

And there is a tiny React app in the [examples/react](examples/react) folder.

## Contributing

PRs and issues are welcome!

### Testing

I use my [rescript-zora](https://github.com/dusty-phillips/rescript-zora)
library for testing. `yarn test:watch` should be all you need.

### Releasing

This is for my reference:

- update the version in `bsconfig.json`
- bump the version in `example/react`
- `np`

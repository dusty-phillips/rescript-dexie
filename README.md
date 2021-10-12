# Rescript-Dexie

Note: These bindings are still very early. No npm package is available and there are no docs.

Rescript bindings to the easy-to-use [Dexie](https://dexie.org) wrapper of indexedDB.

Refer to the [unit
tests](https://github.com/dusty-phillips/rescript-dexie/tree/main/tests) and
[Dexie documentation](https://dexie.org/docs/) to see some examples
of how these bindings can be used.

## Current State

Most CRUD-type operations can be executed on a Dexie database.

## Not implemented yet:

- Types aren't as restricted as I would like in some cases.
- None of the DBCore operations -- it's not possible to make a Dexie middleware yet.
- Advanced stuff such as hooks and syncables
- React live query hooks

## Releasing

This is for my reference

- update the version in `bsconfig.json`
- `npx np`

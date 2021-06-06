type t

@new @module("dexie") external make: (string, ~options: 'options) => t = "default"

type t

@new @module("dexie") external make: (string, ~options: 'options) => t = "default"
@send external version: (t, int) => DexieVersion.t = "version"

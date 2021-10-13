type schemaTableName = string

module type SchemaItem = {
  type t
  type id
  let tableName: schemaTableName
}

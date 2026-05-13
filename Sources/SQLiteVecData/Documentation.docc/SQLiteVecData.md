# ``SQLiteVecData``

SQLiteData interoperability with sqlite-vec.

## Overview

The core sqlite-vec query helpers are defined in ``StructuredQueriesSQLiteVecCore``, which this library exports alongside `SQLiteData` for the base SQL expression system; see the [StructuredQueriesSQLiteVecCore documentation](https://swiftpackageindex.com/mhayes853/sqlite-vec-data/~/documentation/structuredqueriessqliteveccore/) for more detail.

### Load sqlite-vec at app launch

Choose a setup strategy based on the platform where your app runs.

### Apple platforms

Call ``loadSQLiteVecExtension()`` in your database preparation so every connection can use vec0 tables and vector functions.

```swift
import SQLiteVecData

extension DependencyValues {
  mutating func bootstrapDatabase() throws {
    var configuration = Configuration()
    configuration.prepareDatabase = { db in
      try db.loadSQLiteVecExtension()
    }
    let database = try SQLiteData.defaultDatabase(configuration: configuration)
    var migrator = DatabaseMigrator()
    try migrator.migrate(database)
    defaultDatabase = database
  }
}

@main
struct MyApp: App {
  init() {
    prepareDependencies {
      try! $0.bootstrapDatabase()
    }
  }
}
```

### Non-Apple platforms

Call ``registerSQLiteVecAutoExtension()`` once during process startup before opening any SQLite
connections. This registers sqlite-vec as a process-global SQLite auto extension, so only
connections opened after registration can use vec0 tables and vector functions.

```swift
import SQLiteVecData

@main
enum MyApp {
  static func main() throws {
    try registerSQLiteVecAutoExtension()

    let database = try SQLiteData.defaultDatabase()
    var migrator = DatabaseMigrator()
    try migrator.migrate(database)

    // Start the rest of your application after the database is ready.
  }
}
```

### Create a vec0 table

Create the vec0 virtual table in your migration.

```sql
CREATE VIRTUAL TABLE "Embeddings" USING vec0(
  embedding FLOAT[1536],
  label TEXT
);
```

Then model the table by conforming to ``Vec0`` and using a vector bytes representation such as ``Array/VectorBytesRepresentation``.

```swift
@Table("Embeddings")
struct Embedding: Vec0 {
  @Column(as: [Float].VectorBytesRepresentation.self)
  var embedding: [Float]

  var label: String
}
```

import SQLiteVecData
import StructuredQueriesTestSupport
import Testing

@Suite("Vec0Query tests")
struct Vec0QueryTests {
  private let database = try! DatabaseQueue()

  init() async throws {
    try await self.database.write { db in
      try db.loadSQLiteVecExtension()
      try #sql(
        """
        CREATE VIRTUAL TABLE Embeddings USING vec0(
          embedding float[3],
          label text
        );
        """,
        as: Void.self
      )
      .execute(db)
    }
    try await self.seedDatabase()
  }

  @Test("Vec0 match builds KNN SQL with limit and distance order")
  func vec0MatchWithLimitSQL() async throws {
    let queryVector = [Float].VectorBytesRepresentation(queryOutput: [0.1, 0.2, 0.3])
    let query =
      Embedding
      .where { $0.embedding.match(queryVector) }
      .order(by: { $0.distance })
      .limit(10)

    assertQuery(query) { query in
      try self.database.read { db in
        try query.fetchAll(db)
      }
    } sql: {
      """
      SELECT "Embeddings"."embedding", "Embeddings"."label"
      FROM "Embeddings"
      WHERE ("Embeddings"."embedding" MATCH '���=��L>���>')
      ORDER BY "Embeddings"."distance"
      LIMIT 10
      """
    } results: {
      """
      ┌───────────────────┐
      │ Embedding(        │
      │   embedding: [    │
      │     [0]: 0.0,     │
      │     [1]: 1.0,     │
      │     [2]: 2.0      │
      │   ],              │
      │   label: "item-0" │
      │ )                 │
      ├───────────────────┤
      │ Embedding(        │
      │   embedding: [    │
      │     [0]: 1.0,     │
      │     [1]: 2.0,     │
      │     [2]: 3.0      │
      │   ],              │
      │   label: "item-1" │
      │ )                 │
      ├───────────────────┤
      │ Embedding(        │
      │   embedding: [    │
      │     [0]: 2.0,     │
      │     [1]: 3.0,     │
      │     [2]: 4.0      │
      │   ],              │
      │   label: "item-2" │
      │ )                 │
      ├───────────────────┤
      │ Embedding(        │
      │   embedding: [    │
      │     [0]: 3.0,     │
      │     [1]: 4.0,     │
      │     [2]: 5.0      │
      │   ],              │
      │   label: "item-3" │
      │ )                 │
      ├───────────────────┤
      │ Embedding(        │
      │   embedding: [    │
      │     [0]: 4.0,     │
      │     [1]: 5.0,     │
      │     [2]: 6.0      │
      │   ],              │
      │   label: "item-4" │
      │ )                 │
      ├───────────────────┤
      │ Embedding(        │
      │   embedding: [    │
      │     [0]: 5.0,     │
      │     [1]: 6.0,     │
      │     [2]: 7.0      │
      │   ],              │
      │   label: "item-5" │
      │ )                 │
      ├───────────────────┤
      │ Embedding(        │
      │   embedding: [    │
      │     [0]: 6.0,     │
      │     [1]: 7.0,     │
      │     [2]: 8.0      │
      │   ],              │
      │   label: "item-6" │
      │ )                 │
      ├───────────────────┤
      │ Embedding(        │
      │   embedding: [    │
      │     [0]: 7.0,     │
      │     [1]: 8.0,     │
      │     [2]: 9.0      │
      │   ],              │
      │   label: "item-7" │
      │ )                 │
      ├───────────────────┤
      │ Embedding(        │
      │   embedding: [    │
      │     [0]: 8.0,     │
      │     [1]: 9.0,     │
      │     [2]: 10.0     │
      │   ],              │
      │   label: "item-8" │
      │ )                 │
      ├───────────────────┤
      │ Embedding(        │
      │   embedding: [    │
      │     [0]: 9.0,     │
      │     [1]: 10.0,    │
      │     [2]: 11.0     │
      │   ],              │
      │   label: "item-9" │
      │ )                 │
      └───────────────────┘
      """
    }
  }

  @Test("Vec0 match builds KNN SQL with explicit k constraint")
  func vec0MatchWithKSQL() async throws {
    let queryVector = [Float].VectorBytesRepresentation(queryOutput: [0.1, 0.2, 0.3])
    let query =
      Embedding
      .where { $0.embedding.match(queryVector) }
      .where { $0.k.eq(25) }
      .order(by: { $0.distance })

    assertQuery(query) { query in
      try self.database.read { db in
        try query.fetchAll(db)
      }
    } sql: {
      """
      SELECT "Embeddings"."embedding", "Embeddings"."label"
      FROM "Embeddings"
      WHERE ("Embeddings"."embedding" MATCH '���=��L>���>') AND ("Embeddings"."k") = (25)
      ORDER BY "Embeddings"."distance"
      """
    } results: {
      """
      ┌────────────────────┐
      │ Embedding(         │
      │   embedding: [     │
      │     [0]: 0.0,      │
      │     [1]: 1.0,      │
      │     [2]: 2.0       │
      │   ],               │
      │   label: "item-0"  │
      │ )                  │
      ├────────────────────┤
      │ Embedding(         │
      │   embedding: [     │
      │     [0]: 1.0,      │
      │     [1]: 2.0,      │
      │     [2]: 3.0       │
      │   ],               │
      │   label: "item-1"  │
      │ )                  │
      ├────────────────────┤
      │ Embedding(         │
      │   embedding: [     │
      │     [0]: 2.0,      │
      │     [1]: 3.0,      │
      │     [2]: 4.0       │
      │   ],               │
      │   label: "item-2"  │
      │ )                  │
      ├────────────────────┤
      │ Embedding(         │
      │   embedding: [     │
      │     [0]: 3.0,      │
      │     [1]: 4.0,      │
      │     [2]: 5.0       │
      │   ],               │
      │   label: "item-3"  │
      │ )                  │
      ├────────────────────┤
      │ Embedding(         │
      │   embedding: [     │
      │     [0]: 4.0,      │
      │     [1]: 5.0,      │
      │     [2]: 6.0       │
      │   ],               │
      │   label: "item-4"  │
      │ )                  │
      ├────────────────────┤
      │ Embedding(         │
      │   embedding: [     │
      │     [0]: 5.0,      │
      │     [1]: 6.0,      │
      │     [2]: 7.0       │
      │   ],               │
      │   label: "item-5"  │
      │ )                  │
      ├────────────────────┤
      │ Embedding(         │
      │   embedding: [     │
      │     [0]: 6.0,      │
      │     [1]: 7.0,      │
      │     [2]: 8.0       │
      │   ],               │
      │   label: "item-6"  │
      │ )                  │
      ├────────────────────┤
      │ Embedding(         │
      │   embedding: [     │
      │     [0]: 7.0,      │
      │     [1]: 8.0,      │
      │     [2]: 9.0       │
      │   ],               │
      │   label: "item-7"  │
      │ )                  │
      ├────────────────────┤
      │ Embedding(         │
      │   embedding: [     │
      │     [0]: 8.0,      │
      │     [1]: 9.0,      │
      │     [2]: 10.0      │
      │   ],               │
      │   label: "item-8"  │
      │ )                  │
      ├────────────────────┤
      │ Embedding(         │
      │   embedding: [     │
      │     [0]: 9.0,      │
      │     [1]: 10.0,     │
      │     [2]: 11.0      │
      │   ],               │
      │   label: "item-9"  │
      │ )                  │
      ├────────────────────┤
      │ Embedding(         │
      │   embedding: [     │
      │     [0]: 10.0,     │
      │     [1]: 11.0,     │
      │     [2]: 12.0      │
      │   ],               │
      │   label: "item-10" │
      │ )                  │
      ├────────────────────┤
      │ Embedding(         │
      │   embedding: [     │
      │     [0]: 11.0,     │
      │     [1]: 12.0,     │
      │     [2]: 13.0      │
      │   ],               │
      │   label: "item-11" │
      │ )                  │
      ├────────────────────┤
      │ Embedding(         │
      │   embedding: [     │
      │     [0]: 12.0,     │
      │     [1]: 13.0,     │
      │     [2]: 14.0      │
      │   ],               │
      │   label: "item-12" │
      │ )                  │
      ├────────────────────┤
      │ Embedding(         │
      │   embedding: [     │
      │     [0]: 13.0,     │
      │     [1]: 14.0,     │
      │     [2]: 15.0      │
      │   ],               │
      │   label: "item-13" │
      │ )                  │
      ├────────────────────┤
      │ Embedding(         │
      │   embedding: [     │
      │     [0]: 14.0,     │
      │     [1]: 15.0,     │
      │     [2]: 16.0      │
      │   ],               │
      │   label: "item-14" │
      │ )                  │
      ├────────────────────┤
      │ Embedding(         │
      │   embedding: [     │
      │     [0]: 15.0,     │
      │     [1]: 16.0,     │
      │     [2]: 17.0      │
      │   ],               │
      │   label: "item-15" │
      │ )                  │
      ├────────────────────┤
      │ Embedding(         │
      │   embedding: [     │
      │     [0]: 16.0,     │
      │     [1]: 17.0,     │
      │     [2]: 18.0      │
      │   ],               │
      │   label: "item-16" │
      │ )                  │
      ├────────────────────┤
      │ Embedding(         │
      │   embedding: [     │
      │     [0]: 17.0,     │
      │     [1]: 18.0,     │
      │     [2]: 19.0      │
      │   ],               │
      │   label: "item-17" │
      │ )                  │
      ├────────────────────┤
      │ Embedding(         │
      │   embedding: [     │
      │     [0]: 18.0,     │
      │     [1]: 19.0,     │
      │     [2]: 20.0      │
      │   ],               │
      │   label: "item-18" │
      │ )                  │
      ├────────────────────┤
      │ Embedding(         │
      │   embedding: [     │
      │     [0]: 19.0,     │
      │     [1]: 20.0,     │
      │     [2]: 21.0      │
      │   ],               │
      │   label: "item-19" │
      │ )                  │
      ├────────────────────┤
      │ Embedding(         │
      │   embedding: [     │
      │     [0]: 20.0,     │
      │     [1]: 21.0,     │
      │     [2]: 22.0      │
      │   ],               │
      │   label: "item-20" │
      │ )                  │
      ├────────────────────┤
      │ Embedding(         │
      │   embedding: [     │
      │     [0]: 21.0,     │
      │     [1]: 22.0,     │
      │     [2]: 23.0      │
      │   ],               │
      │   label: "item-21" │
      │ )                  │
      ├────────────────────┤
      │ Embedding(         │
      │   embedding: [     │
      │     [0]: 22.0,     │
      │     [1]: 23.0,     │
      │     [2]: 24.0      │
      │   ],               │
      │   label: "item-22" │
      │ )                  │
      ├────────────────────┤
      │ Embedding(         │
      │   embedding: [     │
      │     [0]: 23.0,     │
      │     [1]: 24.0,     │
      │     [2]: 25.0      │
      │   ],               │
      │   label: "item-23" │
      │ )                  │
      ├────────────────────┤
      │ Embedding(         │
      │   embedding: [     │
      │     [0]: 24.0,     │
      │     [1]: 25.0,     │
      │     [2]: 26.0      │
      │   ],               │
      │   label: "item-24" │
      │ )                  │
      └────────────────────┘
      """
    }
  }

  private func seedDatabase() async throws {
    try await self.database.write { db in
      try Embedding.all.delete().execute(db)

      let records = (0..<50)
        .map { index in
          Embedding(
            embedding: [Float(index), Float(index + 1), Float(index + 2)],
            label: "item-\(index)"
          )
        }
      try Embedding.insert { records }.execute(db)
    }
  }
}

@Table("Embeddings")
private struct Embedding: Vec0 {
  @Column(as: [Float].VectorBytesRepresentation.self)
  var embedding: [Float]

  var label: String
}

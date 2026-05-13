import GRDB
import SQLiteVecData
import SQLiteVecDataTestSupport
import Testing

@Suite("DatabaseLoadSQLiteVec tests", .sqliteVecAutoExtension)
struct DatabaseLoadSQLiteVecTests {
  @Test("Loads SQLiteVec Extension Successfully")
  func loadsSQLiteVecExtensionSuccessfully() async throws {
    await #expect(throws: Never.self) {
      let database = try DatabaseQueue()
      try await database.write { db in
        #if canImport(Darwin)
          try db.loadSQLiteVecExtension()
        #endif

        try #sql(
          """
          CREATE VIRTUAL TABLE TestVectors USING vec0(
            sampleEmbeddings float[8]
          )
          """
        )
        .execute(db)
      }
    }
  }
}

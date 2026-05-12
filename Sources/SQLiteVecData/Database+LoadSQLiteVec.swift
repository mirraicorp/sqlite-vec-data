import CSQLiteVec
import GRDB

extension Database {
  /// Loads the sqlite-vec extension into the current database connection.
  ///
  /// Call this at application launch using a `Configuration.prepareDatabase` callback so every
  /// connection loads sqlite-vec.
  ///
  /// ```swift
  /// extension DependencyValues {
  ///   mutating func bootstrapDatabase() throws {
  ///     var configuration = Configuration()
  ///     configuration.prepareDatabase = { db in
  ///       try db.loadSQLiteVecExtension()
  ///     }
  ///     let database = try SQLiteData.defaultDatabase(configuration: configuration)
  ///     var migrator = DatabaseMigrator()
  ///     try migrator.migrate(database)
  ///     defaultDatabase = database
  ///   }
  /// }
  ///
  /// @main
  /// struct MyApp: App {
  ///   init() {
  ///     prepareDependencies {
  ///       try! $0.bootstrapDatabase()
  ///     }
  ///   }
  /// }
  /// ```
  public func loadSQLiteVecExtension() throws {
    #if canImport(Darwin)
      let code = sqlite3_vec_init(self.sqliteConnection, nil, nil)
    #else
      let vecInit:
        @convention(c) (
          OpaquePointer?,
          UnsafeMutablePointer<UnsafeMutablePointer<CChar>?>?,
          UnsafePointer<sqlite3_api_routines>?
        ) -> Int32 = sqlite3_vec_init
      let code = sqlite3_auto_extension(
        unsafeBitCast(vecInit, to: (@convention(c) () -> Void).self)
      )
    #endif
    let resultCode = ResultCode(rawValue: code)
    if resultCode != .SQLITE_OK {
      throw DatabaseError(resultCode: resultCode, message: "Failed to load SQLiteVec extension.")
    }
  }
}

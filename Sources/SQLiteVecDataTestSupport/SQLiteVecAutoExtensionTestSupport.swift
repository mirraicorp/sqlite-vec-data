import SQLiteVecData
import Testing

public struct _SQLiteVecAutoExtensionTrait: SuiteTrait {
  private static let didRegisterSQLiteVecAutoExtension = Lock(false)

  public func prepare(for test: Test) async throws {
    #if !canImport(Darwin)
      try Self.didRegisterSQLiteVecAutoExtension.withLock { didRegister in
        guard !didRegister else { return }
        try registerSQLiteVecAutoExtension()
        didRegister = true
      }
    #endif
  }
}

extension Trait where Self == _SQLiteVecAutoExtensionTrait {
  /// Registers sqlite-vec as a process-global auto extension for Linux test suites.
  ///
  /// Use this trait on suites that need `vec0` available before opening SQLite connections. The
  /// registration happens exactly once per process and is a no-op on Apple platforms. Tests
  /// should continue using ``GRDB/Database/loadSQLiteVecExtension()`` on the database connection
  /// directly on Apple platforms.
  ///
  /// ```swift
  /// import SQLiteVecDataTestSupport
  /// import Testing
  ///
  /// @Suite(.sqliteVecAutoExtension)
  /// struct MyDatabaseTests {
  ///   // ...
  /// }
  /// ```
  public static var sqliteVecAutoExtension: Self {
    Self()
  }
}

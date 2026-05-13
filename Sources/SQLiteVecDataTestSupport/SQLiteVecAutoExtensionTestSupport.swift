import SQLiteVecData
import Testing

/// A Swift Testing suite trait that registers sqlite-vec auto extensions for non-Apple platform
/// tests.
///
/// Apply this trait to any test suite that opens SQLite connections before each test explicitly
/// loads sqlite-vec into the current connection. On Linux, the trait registers sqlite-vec as a
/// process-global auto extension exactly once, before the suite runs, so connections opened by the
/// suite can use `vec0` tables and vector functions.
///

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

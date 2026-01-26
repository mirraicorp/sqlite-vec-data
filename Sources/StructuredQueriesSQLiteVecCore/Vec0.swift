import StructuredQueriesCore

public protocol Vec0: Table {}

extension TableDefinition where QueryValue: Vec0 {
  public var distance: some QueryExpression<Double?> {
    SQLQueryExpression(
      """
      \(QueryValue.self)."distance"
      """
    )
  }

  public var k: some QueryExpression<Int?> {
    SQLQueryExpression(
      """
      \(QueryValue.self)."k"
      """
    )
  }
}

extension TableColumnExpression where Root: Vec0 {
  public func match(
    _ vector: some VectorBytesRepresentable & QueryBindable
  ) -> some QueryExpression<Bool> {
    SQLQueryExpression(
      """
      (\(Root.self).\(quote: name) MATCH \(vector.queryBinding))
      """
    )
  }
}

import StructuredQueriesCore

// MARK: - Vec0

public protocol Vec0: Table {}

// MARK: - Column Helpers

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

// MARK: - Match

extension TableColumnExpression where Root: Vec0, Value: VectorBytesRepresentable {
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

// MARK: - Column Expression Helpers

extension TableColumnExpression
where Root: Vec0, Value: VectorBytesRepresentable {
  public func distanceL2(
    to vector: some VectorBytesRepresentable & QueryBindable
  ) -> some QueryExpression<Double> {
    Vec.distanceL2(self, to: vector)
  }

  public func distanceL1(
    to vector: some VectorBytesRepresentable & QueryBindable
  ) -> some QueryExpression<Double> {
    Vec.distanceL1(self, to: vector)
  }

  public func distanceCosine(
    to vector: some VectorBytesRepresentable & QueryBindable
  ) -> some QueryExpression<Double> {
    Vec.distanceCosine(self, to: vector)
  }

  public func distanceHamming(
    to vector: some VectorBytesRepresentable & QueryBindable
  ) -> some QueryExpression<Double> {
    Vec.distanceHamming(self, to: vector)
  }

  public func length() -> some QueryExpression<Double?> {
    Vec.length(self)
  }

  public func type() -> some QueryExpression<String?> {
    Vec.type(self)
  }

  public func toJSON() -> some QueryExpression<String?> {
    Vec.toJSON(self)
  }

  public func add(
    _ vector: some VectorBytesRepresentable & QueryBindable
  ) -> some QueryExpression<Value> {
    Vec.add(self, vector, as: Value.self)
  }

  public func sub(
    _ vector: some VectorBytesRepresentable & QueryBindable
  ) -> some QueryExpression<Value> {
    Vec.sub(self, vector, as: Value.self)
  }

  public func slice(
    start: Int,
    length: Int
  ) -> some QueryExpression<Value> {
    Vec.slice(
      self,
      start: start,
      length: length,
      as: Value.self
    )
  }

  public func normalize() -> some QueryExpression<Value> {
    Vec.normalize(self, as: Value.self)
  }

  public func f32() -> some QueryExpression<Value> {
    Vec.f32(self, as: Value.self)
  }

  public func bit() -> some QueryExpression<Value> {
    Vec.bit(self, as: Value.self)
  }

  public func int8() -> some QueryExpression<Value> {
    Vec.int8(self, as: Value.self)
  }

  public func quantizeInt8(scale: Double) -> some QueryExpression<Value> {
    Vec.quantizeInt8(
      self,
      scale: scale,
      as: Value.self
    )
  }

  public func quantizeBinary() -> some QueryExpression<Value> {
    Vec.quantizeBinary(self, as: Value.self)
  }
}

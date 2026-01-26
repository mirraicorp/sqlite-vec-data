import StructuredQueriesCore

public enum Vec {
  public static func distanceL2(
    _ column: some QueryExpression<some VectorBytesRepresentable>,
    to vector: some VectorBytesRepresentable & QueryBindable
  ) -> some QueryExpression<Double> {
    SQLQueryExpression("vec_distance_l2(\(column), \(bind: vector))")
  }

  public static func distanceL1(
    _ column: some QueryExpression<some VectorBytesRepresentable>,
    to vector: some VectorBytesRepresentable & QueryBindable
  ) -> some QueryExpression<Double> {
    SQLQueryExpression("vec_distance_l1(\(column), \(bind: vector))")
  }

  public static func distanceCosine(
    _ column: some QueryExpression<some VectorBytesRepresentable>,
    to vector: some VectorBytesRepresentable & QueryBindable
  ) -> some QueryExpression<Double> {
    SQLQueryExpression("vec_distance_cosine(\(column), \(bind: vector))")
  }

  public static func distanceHamming(
    _ column: some QueryExpression<some VectorBytesRepresentable>,
    to vector: some VectorBytesRepresentable & QueryBindable
  ) -> some QueryExpression<Double> {
    SQLQueryExpression("vec_distance_hamming(\(column), \(bind: vector))")
  }

  public static func length(
    _ column: some QueryExpression<some VectorBytesRepresentable>
  ) -> some QueryExpression<Double?> {
    SQLQueryExpression("vec_length(\(column))")
  }

  public static func type(
    _ column: some QueryExpression<some VectorBytesRepresentable>
  ) -> some QueryExpression<String?> {
    SQLQueryExpression("vec_type(\(column))")
  }

  public static func toJSON(
    _ column: some QueryExpression<some VectorBytesRepresentable>
  ) -> some QueryExpression<String?> {
    SQLQueryExpression("vec_to_json(\(column))")
  }

  public static func add<T: VectorBytesRepresentable & QueryBindable>(
    _ column: some QueryExpression<some VectorBytesRepresentable>,
    _ vector: some VectorBytesRepresentable & QueryBindable,
    as result: T.Type
  ) -> some QueryExpression<T> {
    SQLQueryExpression("vec_add(\(column), \(bind: vector))")
  }

  public static func add(
    _ column: some QueryExpression<some VectorBytesRepresentable>,
    _ vector: some VectorBytesRepresentable & QueryBindable
  ) -> some QueryExpression<[Float].VectorBytesRepresentation> {
    Self.add(column, vector, as: [Float].VectorBytesRepresentation.self)
  }

  public static func sub<T: VectorBytesRepresentable & QueryBindable>(
    _ column: some QueryExpression<some VectorBytesRepresentable>,
    _ vector: some VectorBytesRepresentable & QueryBindable,
    as result: T.Type
  ) -> some QueryExpression<T> {
    SQLQueryExpression("vec_sub(\(column), \(bind: vector))")
  }

  public static func sub(
    _ column: some QueryExpression<some VectorBytesRepresentable>,
    _ vector: some VectorBytesRepresentable & QueryBindable
  ) -> some QueryExpression<[Float].VectorBytesRepresentation> {
    Self.sub(column, vector, as: [Float].VectorBytesRepresentation.self)
  }

  public static func slice<T: VectorBytesRepresentable & QueryBindable>(
    _ column: some QueryExpression<some VectorBytesRepresentable>,
    start: Int,
    length: Int,
    as result: T.Type
  ) -> some QueryExpression<T> {
    SQLQueryExpression("vec_slice(\(column), \(raw: start), \(raw: length))")
  }

  public static func slice(
    _ column: some QueryExpression<some VectorBytesRepresentable>,
    start: Int,
    length: Int
  ) -> some QueryExpression<[Float].VectorBytesRepresentation> {
    Self.slice(
      column,
      start: start,
      length: length,
      as: [Float].VectorBytesRepresentation.self
    )
  }

  public static func normalize<T: VectorBytesRepresentable & QueryBindable>(
    _ column: some QueryExpression<some VectorBytesRepresentable>,
    as result: T.Type
  ) -> some QueryExpression<T> {
    SQLQueryExpression("vec_normalize(\(column))")
  }

  public static func normalize(
    _ column: some QueryExpression<some VectorBytesRepresentable>
  ) -> some QueryExpression<[Float].VectorBytesRepresentation> {
    Self.normalize(column, as: [Float].VectorBytesRepresentation.self)
  }

  public static func f32<T: VectorBytesRepresentable & QueryBindable>(
    _ column: some QueryExpression<some VectorBytesRepresentable>,
    as result: T.Type
  ) -> some QueryExpression<T> {
    SQLQueryExpression("vec_f32(\(column))")
  }

  public static func f32(
    _ column: some QueryExpression<some VectorBytesRepresentable>
  ) -> some QueryExpression<[Float].VectorBytesRepresentation> {
    Self.f32(column, as: [Float].VectorBytesRepresentation.self)
  }

  public static func bit<T: VectorBytesRepresentable & QueryBindable>(
    _ column: some QueryExpression<some VectorBytesRepresentable>,
    as result: T.Type
  ) -> some QueryExpression<T> {
    SQLQueryExpression("vec_bit(\(column))")
  }

  public static func bit(
    _ column: some QueryExpression<some VectorBytesRepresentable>
  ) -> some QueryExpression<[Float].VectorBytesRepresentation> {
    Self.bit(column, as: [Float].VectorBytesRepresentation.self)
  }

  public static func int8<T: VectorBytesRepresentable & QueryBindable>(
    _ column: some QueryExpression<some VectorBytesRepresentable>,
    as result: T.Type
  ) -> some QueryExpression<T> {
    SQLQueryExpression("vec_int8(\(column))")
  }

  public static func int8(
    _ column: some QueryExpression<some VectorBytesRepresentable>
  ) -> some QueryExpression<[Float].VectorBytesRepresentation> {
    Self.int8(column, as: [Float].VectorBytesRepresentation.self)
  }

  public static func quantizeInt8<T: VectorBytesRepresentable & QueryBindable>(
    _ column: some QueryExpression<some VectorBytesRepresentable>,
    scale: Double,
    as result: T.Type
  ) -> some QueryExpression<T> {
    SQLQueryExpression("vec_quantize_int8(\(column), \(raw: scale))")
  }

  public static func quantizeInt8(
    _ column: some QueryExpression<some VectorBytesRepresentable>,
    scale: Double
  ) -> some QueryExpression<[Float].VectorBytesRepresentation> {
    Self.quantizeInt8(
      column,
      scale: scale,
      as: [Float].VectorBytesRepresentation.self
    )
  }

  public static func quantizeBinary<T: VectorBytesRepresentable & QueryBindable>(
    _ column: some QueryExpression<some VectorBytesRepresentable>,
    as result: T.Type
  ) -> some QueryExpression<T> {
    SQLQueryExpression("vec_quantize_binary(\(column))")
  }

  public static func quantizeBinary(
    _ column: some QueryExpression<some VectorBytesRepresentable>
  ) -> some QueryExpression<[Float].VectorBytesRepresentation> {
    Self.quantizeBinary(column, as: [Float].VectorBytesRepresentation.self)
  }
}

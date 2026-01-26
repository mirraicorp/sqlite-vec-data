import StructuredQueriesCore

// MARK: - VectorBytesRepresentable

public protocol VectorBytesRepresentable {
  associatedtype VectorBytesRepresentation: QueryBindable & QueryDecodable & QueryRepresentable
}

// MARK: - Array

extension Array: VectorBytesRepresentable where Element == Float {}

extension Array.VectorBytesRepresentation: VectorBytesRepresentable {
  public typealias VectorBytesRepresentation = Self
}

// MARK: - InlineArray

#if swift(>=6.2)
  @available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *)
  extension InlineArray: VectorBytesRepresentable where Element == Float {}

  @available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *)
  extension InlineArray.VectorBytesRepresentation: VectorBytesRepresentable {
    public typealias VectorBytesRepresentation = Self
  }
#endif

// MARK: - EmbeddingVector

#if swift(>=6.2)
  @available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *)
  extension EmbeddingVector: VectorBytesRepresentable {
    public typealias VectorBytesRepresentation = Self
  }
#endif

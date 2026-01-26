# ``StructuredQueriesSQLiteVecCore``

StructuredQueries helpers for [sqlite-vec](https://github.com/asg017/sqlite-vec) that are not tied to SQLiteData.

## Overview

Use ``Vec0`` tables, `TableColumnExpression` helpers like ``StructuredQueriesCore/TableColumnExpression/match(_:)`` and ``StructuredQueriesCore/TableColumnExpression/distanceCosine(to:)``, and the ``Vec`` namespace to build vector search queries without writing SQL strings directly.

### Match queries

```swift
@Table("Embeddings")
struct Embedding: Vec0 {
  @Column(as: [Float].VectorBytesRepresentation.self)
  var embedding: [Float]

  var label: String
}

let queryVector: [Float].VectorBytesRepresentation = [0.1, 0.2, 0.3]
let query = Embedding
  .where { $0.embedding.match(queryVector) }
  .order { $0.distance.asc() }
  .limit(5)
  .select { ($0.label, $0.distance) }
```

### Distance functions

```swift
let queryVector: [Float].VectorBytesRepresentation = [0.1, 0.2, 0.3]
let query = Embedding.select {
  ($0.label, $0.embedding.distanceCosine(to: queryVector))
}
```

## EmbeddingVector

``EmbeddingVector`` is a Hashable and Codable fixed-length array alternative to `InlineArray`. It is available on iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, and visionOS 26.0, and it can be stored in vec0 tables or used directly as a query binding.

```swift
@Table("Embeddings")
struct Embedding: Vec0 {
  var id: UUID
  var embedding: EmbeddingVector<1536>
}

let queryVector = EmbeddingVector<1536>([...])
let query = Embedding
  .where { $0.embedding.match(queryVector) }
  .select { ($0.id, $0.distance) }
```

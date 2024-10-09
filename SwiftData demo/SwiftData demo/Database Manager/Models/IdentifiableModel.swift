/// A protocol that defines an identifiable model.
///
/// The `IdentifiableModel` protocol requires conforming types to provide a unique identifier (`id`).
public protocol IdentifiableModel {
  var id: String { get }
}

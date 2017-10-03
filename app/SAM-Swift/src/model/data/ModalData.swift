import Foundation

/// Container class for all Model properties.
/// Separates the actual mutable Model data from the Model acceptors.
/// Of type Class (not Struct) since we don't want to copy the entire
/// Model tree when a single property is mutated.

/// Note: For more complex applications consisting of several larger modules,
/// we would probably want to organise the Model values per "component" or
/// use additional higher-level data structures.
final class ModelData {
    var currentGif: Gif = Gif.empty()
    var openedGifUrl: URL?
    var isLoading: Bool = false
    var error: ModelError?
}

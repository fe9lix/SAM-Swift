import Foundation

/// Action that presents a URL for opening to the Model.
/// The URL can be nil, inficating that a Gif should no longer be in the opened state.
/// (Close semantics could also be extracted into a separate Action.)
final class OpenGif {
    @discardableResult
    init(url: URL?, present: @escaping ([AnyHashable: Any]) -> Void) {
        if let url = url {
            print("Opening Gif: \(String(describing: url))")
            present(["openedGifUrl": url])
        } else {
            print("Closing Gif...")
            present([:])
        }
    }
}

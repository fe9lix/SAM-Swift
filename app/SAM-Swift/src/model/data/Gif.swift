import Foundation

/// Simple Model value holding the properties of a Gif.
struct Gif {
    let title: String
    let link: URL
    let source: URL
    let data: Data
}

/// Extension for initializing a Model from a dataset.
extension Gif {
    static func empty() -> Gif { return Gif([:]) }
    
    init(_ data: [AnyHashable: Any]) {
        let defaultUrl = { URL(string: "http://thecodinglove.com")! }
        title = data["title"] as? String ?? ""
        link = data["link"] as? URL ?? defaultUrl()
        source = data["source"] as? URL ?? defaultUrl()
        self.data = data["data"] as? Data ?? Data()
    }
}

/// Equality
/// We treat two Gifs the same if the source URL is identical.
extension Gif: Equatable {
    static func == (lhs: Gif, rhs: Gif) -> Bool {
        return lhs.source == rhs.source
    }
}

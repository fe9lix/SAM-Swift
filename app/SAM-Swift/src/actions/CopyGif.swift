import UIKit

/// Action that copies a Gif URL to the general clipboard.
/// No Model presentation needed here.
final class CopyGif {
    @discardableResult
    init(title: String, url: URL) {
        UIPasteboard.general.string = "\(title) \(url.absoluteString)"
    }
}

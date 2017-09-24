import Foundation
import Kanna

/// Action that loads a random Gif.
/// Delegates to a common Action for performing the actual loading.
final class LoadRandomGif {
    private let url = URL(string: "http://thecodinglove.com/random")!
    
    @discardableResult
    init(present: @escaping ([AnyHashable: Any]) -> Void) {
        print("Loading random Gif...")
        LoadGif(url: url, present: present)
    }
}

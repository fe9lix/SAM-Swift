import Foundation
import Kanna

/// Action that loads a random Gif.
/// Delegates to a common Action for performing the actual loading.
final class LoadRandomGif {
    private let url = URL(string: "http://thecodinglove.com/random")!
    private let maxRetries = 5
    
    @discardableResult
    init(present: @escaping ([AnyHashable: Any]) -> Void) {
        print("Loading random Gif...")
        load(url: url, present: present)
    }
    
    deinit { print("deinit", self) }
    
    /// Loads the Gif from the given URL and retries the call maxRetries times.
    /// (The /random path sometimes returns invalid Gif URLs.)
    private func load(url: URL, present: @escaping ([AnyHashable: Any]) -> Void, retryCount: Int = 0) {
        LoadGif(url: url) { data in
            if data["error"] != nil, retryCount < self.maxRetries {
                print("Retry loading...")
                self.load(url: url, present: present, retryCount: retryCount + 1)
                return
            }
            present(data)
        }
    }
}

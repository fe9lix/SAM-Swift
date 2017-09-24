import Foundation
import Kanna

/// Action that loads the latest Gif.
/// First finds the URL of the latest Gif and then delegates to a common Action for performing the actual loading.
final class LoadLatestGif {
    private let url = URL(string: "http://thecodinglove.com")!
    
    @discardableResult
    init(present: @escaping ([AnyHashable: Any]) -> Void) {
        print("Loading latest Gif...")
        loadHTML { data in
            guard
                let data = data,
                let latestURL = self.findLatestURL(in: data)
                else {
                    present(["error": ["name": "gifNotLoaded"]])
                    return
            }
            LoadGif(url: latestURL, present: present)
        }
    }
    
    /// Loads the main HTML as Data.
    private func loadHTML(completion: @escaping (Data?) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
            guard let data = data else {
                print("Invalid data: \(String(describing: error))")
                completion(nil)
                return
            }
            completion(data)
        }).resume()
    }
    
    /// Finds the link of the first post on the home HTML.
    private func findLatestURL(in data: Data) -> URL? {
        guard
            let htmlString = String(data: data, encoding: .utf8),
            let doc = try? HTML(html: htmlString, encoding: .utf8),
            let link = doc.css("#post1 a").first?["href"]
            else {
                print("Could not find latest URL.")
                return nil
        }
        
        return URL(string: link)
    }
}

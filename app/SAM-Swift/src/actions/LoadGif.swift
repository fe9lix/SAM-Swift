import Foundation
import Kanna

/// Action that loads a Gif from a URL.
/// First loads the HTML, then parses the elements for Gif properties and finally presents the payload to the Model.
final class LoadGif {
    @discardableResult
    init(url: URL, present: @escaping ([AnyHashable: Any]) -> Void) {
        print("Loading Gif from: \(url)")
        present(["isLoading": true])
        
        loadHTML(from: url) { (data, url) in
            /// Load the Gif and update the website link.
            var gif = self.loadGif(from: data)
            if gif.isEmpty {
                present(["error": ["name": "gifNotLoaded"]])
                return
            }
            gif["link"] = url
            
            DispatchQueue.main.async {
                print("Gif loaded: \(gif)")
                present(["gif": gif])
            }
        }
    }
    
    /// Loads the HTML as Data and gets the actual URL (after a potential redirect).
    private func loadHTML(from url: URL, completion: @escaping (Data, URL) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard
                let data = data,
                let url = response?.url else {
                print("Invalid response: \(String(describing: error))")
                return
            }
            completion(data, url)
        }).resume()
    }
    
    /// Parses the Gif attributes from the HTML Data and loads the Gif as Data.
    private func loadGif(from data: Data) -> [AnyHashable: Any] {
        guard
            let htmlString = String(data: data, encoding: .utf8),
            let doc = try? HTML(html: htmlString, encoding: .utf8),
            let title = doc.css("#post1 h3").first?.text,
            let link = doc.css("#post1 img").first?["src"],
            let url = URL(string: link),
            let data = try? Data(contentsOf: url)
            else {
                print("Could not parse gif.")
                return [:]
        }
        
        return [
            "title": title,
            "source": url,
            "data": data
        ]
    }
}

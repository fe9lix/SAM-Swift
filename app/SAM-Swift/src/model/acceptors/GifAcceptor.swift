import Foundation

/// Model Acceptor for Gif data.
struct GifAcceptor: Acceptor {
    func update(_ model: Model, _ data: [AnyHashable: Any]) {
        if let gifData = data["gif"] as? [AnyHashable: Any] {
            let newGif = Gif(gifData)
            model.currentGif = newGif
        }
        
        model.openedGifUrl = data["openedGifUrl"] as? URL
    }
}

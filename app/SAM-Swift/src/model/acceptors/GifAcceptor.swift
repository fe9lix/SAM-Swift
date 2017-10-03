import Foundation

/// Model Acceptor for Gif data.
struct GifAcceptor: Acceptor {
    func update(_ model: Model, _ data: [AnyHashable: Any]) {
        if let gifData = data["gif"] as? [AnyHashable: Any] {
            let newGif = Gif(gifData)
            model.render = newGif != model.data.currentGif
            model.data.currentGif = newGif
        }
        
        model.data.openedGifUrl = data["openedGifUrl"] as? URL
    }
}

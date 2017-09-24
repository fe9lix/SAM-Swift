import UIKit
import FLAnimatedImage

/// View-specific Model describing the screen for the gif details.
struct GifDetails {
    let title: String
    let attributedTitle: NSAttributedString
    let sourceUrl: URL
    let webUrl: URL
    let viewMode: ViewMode
    
    private(set) var animatedImage: FLAnimatedImage?
}

/// The convenience initializer for configuring the properties based on the Model value
/// is kept separate in an extension.
extension GifDetails {
    init(_ gif: Gif, viewMode: ViewMode) {
        switch viewMode {
        case .loading: title = "Loading Gif from the_coding_love()..."
        case .success: title = gif.title
        case .error: title = "Could not load Gif."
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedTitle = NSAttributedString(string: title, attributes: [
            .paragraphStyle: paragraphStyle
            ])
        
        sourceUrl = gif.source
        webUrl = gif.link
        /// Check if the Gif actually contains data to prevent potential crashes.
        if gif.data.count > 0 {
            animatedImage = FLAnimatedImage(animatedGIFData: gif.data)
        }
        
        self.viewMode = viewMode
    }
}

import UIKit

/// The View actually renders the current State Representation.
/// In HTML/JS application, the View would return HTML that is then updated in the DOM.
/// Here, we calcuate view-compatible properties that are then passed to a ViewController via the display closure.
/// The ViewController then (imperatively) renders the View by updating view components.
/// Supporting the UIKit framework via a declarative API would require a lot of work (incl. diffing the entire hierarchy)
/// and we would give up Interface Builder features such as Storyboards, AutoLayout etc.)
struct View {
    // MARK: - Display
    
    /// Closure for updating the user interface with the View Description.
    typealias Display = (View.Description) -> Void
    
    let display: Display
    
    init(display: @escaping Display) {
        self.display = display
    }
}

// MARK: - Descriptions

/// Pure functions for View Descriptions kept in an extension:
/// Model, Trigger -> View Description
extension View {
    /// An associated enum value represents a view and carries the data that the UI needs for rendering.
    /// (This is the equivalent of declarative HTML in a HTML/JS app.)
    /// We could use structs but assoc. enums have the advantage that we can use pattern matching in the
    /// user interface for rendering and each case only carries the required data for a specific view.
    /// For more complex screens, the enum cases could contain structs describing an entire screen.
    enum Description {
        case empty
        case gifDetails(details: GifDetails, trigger: Trigger)
        case openedGif(url: URL, trigger: Trigger)
    }
    
    func gifDetails(_ model: Model, _ trigger: @escaping Trigger) -> Description {
        return .gifDetails(details: GifDetails(model.currentGif,
                                               viewMode: ViewMode(model)),
                           trigger: trigger)
    }
    
    func openedGif(_ model: Model, _ trigger: @escaping Trigger) -> Description {
        return .openedGif(url: model.openedGifUrl ?? URL(string: "http://thecodinglove.com")!, trigger: trigger)
    }
}

import Foundation

/// An Action computes a dataset (Proposal) – the values we want the Model to accept –
/// and then presents it to the Model.
/// It performs input validation and enriches the input data from an event if needed,
/// for example by performing an async. network call.

/// This class provides the mapping from Intents to actual Actions.
final class Actions {
    // MARK: - Intent
    
    /// Intents are used by UI components to trigger Actions.
    /// They further decouple the UI from knowledge of concrete Actions.
    enum Intent {
        case latestGif
        case randomGif
        case copyGif(title: String, url: URL)
        case openGif(url: URL?)
    }
    
    // MARK: - Init
    
    /// Closure for presenting data to the Model.
    let present: ([AnyHashable: Any]) -> Void
    /// Closure for triggering Intents.
    lazy var trigger: Trigger = self.createTrigger()
    
    init(_ present: @escaping ([AnyHashable: Any]) -> Void) {
        self.present = present
    }
    
    // MARK: - Trigger
    
    /// Returns a closure with a mapping from Intent to Action.
    /// Trigger is used in the UI to trigger Intents -> Actions.
    private func createTrigger() -> Trigger {
        return { [weak self] intent in
            guard let strongSelf = self else { return }
            
            switch intent {
            case .latestGif: LoadLatestGif(present: strongSelf.present)
            case .randomGif: LoadRandomGif(present: strongSelf.present)
            case let .copyGif(title, url): CopyGif(title: title, url: url)
            case let .openGif(url): OpenGif(url: url, present: strongSelf.present)
            }
        }
    }
}

/// Typealias used by other components that need access to triggers (e.g. View).
typealias Trigger = (Actions.Intent) -> Void

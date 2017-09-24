import Foundation

/// Model for the entire application ("Single State Tree").
/// The actual (control) state will be derived from the values of the Model.
/// The Model exposes only one method for presenting data (Proposal) that is then accepted or rejected.
/// The Model actually mutates its properties while enforcing its integrity rules.
/// After the mutation, the State is asked to render.
final class Model {
    var state: State!
    
    // MARK: - Values
    
    /// Note: For more complex applications consisting of several larger modules,
    /// we would probably want to organise the Model values per "component" or
    /// use additional higher-level data structures.
    
    private(set) var currentGif: Gif = Gif.empty()
    private(set) var openedGifUrl: URL?
    private(set) var isLoading: Bool = false
    private(set) var error: ModelError?
    
    // MARK: - Acceptor
    
    /// The purpose of the present function is to decouple an Action from the Model, i.e.:
    /// Rather than directly mutating the Model from within an Action (which would require the Action to have the entire knowledge of the Model and application state),
    /// the proposal only carries a payload (the data we want the Model to accept) that is then presented to the Model.
    /// The actual mutation is performed by the Model, not by the Action.
    /// We *could* use assoc. enums to carry the proposal instead of a plain dictionary, however, this would cause stronger coupling between Actions and the Model.
    
    func present(_ data: [AnyHashable: Any]) {
        print("present: \(data)")
        var shouldRender = true
   
        isLoading = data["isLoading"] as? Bool ?? false
        if let errorData = data["error"] as? [AnyHashable: Any] {
            error = ModelError(errorData)
        }
        
        if let gifData = data["gif"] as? [AnyHashable: Any] {
            let newGif = Gif(gifData)
            shouldRender = newGif != currentGif
            currentGif = newGif
        }
        
        openedGifUrl = data["openedGifUrl"] as? URL
        
        /// The code here could also organized into:
        /// applyFilters() -> calculate what's changed for the view
        /// CRUD() -> persistence
        /// postProcessing() -> perform ancillary assignments
        
        /// Ask the State to render.
        /// We can also guard this call with a model property if rendering should be prevented in certain cases.
        if shouldRender {
            state.render(self)
        }
    }
}

import Foundation

/// Model for the entire application ("Single Model Tree").
/// The actual (control) state will be derived from the values of the Model.
/// The Model exposes only one method for presenting data (Proposal) that is then accepted or rejected.
/// The Model actually mutates its properties while enforcing its integrity rules.
/// After the mutation, the State is asked to render.
final class Model {
    var state: State!
    var data: ModelData
    var render = true
    
    private let acceptors: [Acceptor]
    
    init(_ data: ModelData, acceptors: [Acceptor]) {
        self.data = data
        self.acceptors = acceptors
    }
    
    // MARK: - Acceptors
    
    /// The purpose of the present function is to decouple an Action from the Model, i.e.:
    /// Rather than directly mutating the Model from within an Action (which would require the Action to have the entire knowledge of the Model and application state),
    /// the proposal only carries a payload (the data we want the Model to accept) that is then presented to the Model.
    /// The actual mutation is performed by the Model, not by the Action.
    /// We *could* use assoc. enums to carry the proposal instead of a plain dictionary, however, this would cause stronger coupling between Actions and the Model.
    
    func present(_ data: [AnyHashable: Any]) {
        print("present: \(data)")
        /// Reset rendering flag.
        render = true
        /// Run through all Model acceptors that mutate the Model data.
        acceptors.forEach { $0.update(self, data) }
        
        /// The code here could also organized into:
        /// applyFilters() -> calculate what's changed for the view
        /// CRUD() -> persistence
        /// postProcessing() -> perform ancillary assignments
        
        /// Ask the State to render if needed.
        if render {
            state.render(self)
        }
    }
}

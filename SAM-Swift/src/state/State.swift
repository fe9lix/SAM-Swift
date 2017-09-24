import Foundation

/// The State is entirely derived from the Model properties.
/// (Maybe unintuitively, the State itself is stateless.)
/// It first calculates the current State Representation based on set of predicates.
/// It then calculates the NAP (Next Action Predicate), i.e. any "automatic" Action that should be triggered.
/// (If no action should be triggered, the system just waits for the next user or system event).
struct State {
    private let view: View
    private let trigger: Trigger
    
    init(_ view: View, _ trigger: @escaping Trigger) {
        self.view = view
        self.trigger = trigger
    }
    
    // MARK: - Current State
    
    /// Determines the current State Representation for the view.
    /// The representation is a pure function of the Model.
    /// This can be simple if/else if logic based on state predicates.
    private func representation(_ model: Model) -> View.Description {
        var representation: View.Description = .empty
        
        if gifDetails(model) {
            representation = view.gifDetails(model, trigger)
        } else if gifOpened(model) {
            representation = view.openedGif(model, trigger)
        }
        
        return representation
    }
    
    // MARK: - State Predicates
    
    /// Pure functions: Model -> Bool
    /// Invidual predicates contain the conditional logic to determine the state based on Model properties.
    /// Depending on our needs, we can compose single state predicates into higher-level predicates corresponding to a State Representation.
    /// States can also be thought of as "ranges of property values" but often are reduced to a single value.
    
    private func gifDetails(_ model: Model) -> Bool {
        return model.openedGifUrl == nil
    }
    
    private func gifOpened(_ model: Model) -> Bool {
        return model.openedGifUrl != nil
    }
    
    // MARK: - Next Action Predicate (NAP)
    
    /// No NAP here.
    /// If required, we could check the state here and trigger another (automatic) Action.
    /// The NAP is also a pure function of the Model.
    private func nextAction(_ model: Model) {}
    
    // MARK: - Reactive Loop
    
    /// First determine the current state representation on a background queue.
    /// Then perform the next action predicate on the main queue.
    func render(_ model: Model) {
        DispatchQueue.global(qos: .userInteractive).async {
            let representation = self.representation(model)
            DispatchQueue.main.sync {
                self.view.display(representation)
                self.nextAction(model)
            }
        }
    }
}

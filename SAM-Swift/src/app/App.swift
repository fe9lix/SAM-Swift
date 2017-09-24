import UIKit

/// Example App for the SAM (State-Action-Model) described by Jean-Jacques Dubray on http://sam.js.org
/// The entire pattern can essentially described as:
/// View=State(Model.present(Action(event))).then(nap)

/// Main entry point: Creates the Main UI and wires all elements.
final class App {
    private let model: Model
    private let view: View
    private let state: State
    
    init(_ window: UIWindow) {
        model = Model()
        let actions = Actions(model.present)
        let userInterface = AppViewController.create { actions.trigger(.latestGif) }
        window.rootViewController = userInterface
        view = View { userInterface.display($0) }
        state = State(view, actions.trigger)
        model.state = state
    }
}

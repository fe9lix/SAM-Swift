import Foundation

/// Protocol for all Model acceptors:
/// The update method expects the Model and the proposed data for the Model mutation.
protocol Acceptor {
    func update(_ model: Model, _ data: [AnyHashable: Any])
}

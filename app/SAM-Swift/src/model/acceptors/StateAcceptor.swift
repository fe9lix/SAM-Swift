import Foundation

/// Model Acceptor for States (loading, error...).
struct StateAcceptor: Acceptor {
    func update(_ model: Model, _ data: [AnyHashable: Any]) {
        model.isLoading = data["isLoading"] as? Bool ?? false
        
        if let errorData = data["error"] as? [AnyHashable: Any] {
            model.error = ModelError(errorData)
        } else {
            model.error = nil
        }
    }
}

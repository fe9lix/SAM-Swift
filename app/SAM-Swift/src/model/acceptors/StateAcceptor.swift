import Foundation

/// Model Acceptor for States (loading, error...).
struct StateAcceptor: Acceptor {
    func update(_ model: Model, _ data: [AnyHashable: Any]) {
        model.data.isLoading = data["isLoading"] as? Bool ?? false
        
        if let errorData = data["error"] as? [AnyHashable: Any] {
            model.data.error = ModelError(errorData)
        } else {
            model.data.error = nil
        }
    }
}

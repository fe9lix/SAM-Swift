import Foundation

/// Simple enum for view-specific Models to indicate their state.
enum ViewMode {
    case loading
    case success
    case error
}

/// Extension for setting the view mode based on Model properties.
extension ViewMode {
    init(_ model: Model) {
        if let _ = model.error {
            self = .error
        } else if model.isLoading {
            self = .loading
        } else {
            self = .success
        }
    }
}

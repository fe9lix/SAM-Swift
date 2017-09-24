import Foundation

/// Custom error type for the Model.
enum ModelError: Error {
    case general
    case gifNotLoaded
}

/// Extension for initializing the Error from a dataset.
extension ModelError {
    init(_ data: [AnyHashable: Any]) {
        let name = data["name"] as? String
        
        switch name {
        case "gifNotLoaded"?: self = .gifNotLoaded
        default: self = .general
        }
    }
}

import Foundation

enum CommonError: Error, Equatable {
    case decoding
    case notFound
    case unKnown
    case validationFailed
    case movedPermanent
    case custom(message: String)
    
    init(statusCode: Int?) {
        switch statusCode {
        case 301:
            self = .movedPermanent
                        
        case 404:
            self = .notFound
            
        case 422:
            self = .validationFailed
                        
        default:
            self = .unKnown
        }
    }
}

extension CommonError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .decoding, .notFound, .validationFailed, .movedPermanent:
            return "네트워크 관련 에러입니다."
            
        case .unKnown:
            return "알 수 없는 에러입니다."
            
        case .custom(let message):
            return message
        }
    }
}

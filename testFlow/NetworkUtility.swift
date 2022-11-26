import Foundation

import Alamofire

class NetworkUtility {
    static func getHeader() -> HTTPHeaders {
        let headers: HTTPHeaders = ["Accept": "application/json"]
                
        return headers
    }
}

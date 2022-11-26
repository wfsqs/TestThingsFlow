import Foundation

import RxSwift
import Alamofire

protocol GitHubServiceType {
    func searchIssue(
        owner: String,
        repoName: String,
        perPage: Int,
        currentPage: Int
    ) -> Observable<[Issue]>
}

final class GitHubService: GitHubServiceType {
    func searchIssue(
        owner: String,
        repoName: String,
        perPage: Int,
        currentPage: Int
    ) -> Observable<[Issue]> {
        return Observable.create { observer in
            guard let url = URL(
                string: "https://api.github.com/repos/\(owner)/\(repoName)/issues"
            ) else {
                observer.onError(CommonError.unKnown)
                return Disposables.create()
            }
            
            var components = URLComponents(string: url.absoluteString)
            components?.queryItems = [
                URLQueryItem(name: "per_page", value: "\(perPage)"),
                URLQueryItem(name: "page", value: "\(currentPage)")
            ]

            AF.request(
                components?.string ?? "",
                method: .get,
                encoding: URLEncoding.httpBody,
                headers: NetworkUtility.getHeader()
            ).responseData { response in
                switch response.result {
                case .success(let data):
                    if response.response?.statusCode == 200 {
                        if let decodedData = try? JSONDecoder().decode(
                            [Issue].self, from: data
                        ) {
                            observer.onNext(decodedData)
                            observer.onCompleted()
                        } else {
                            observer.onError(CommonError.decoding)
                        }
                    } else {
                        observer.onError(CommonError(statusCode: response.response?.statusCode))
                    }
                    
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
}

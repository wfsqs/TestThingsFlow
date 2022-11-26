import RxSwift

struct GlobalState {
    static let shared = GlobalState()
    
    let refreshIssue = PublishSubject<(owner: String, repo: String)>()
}

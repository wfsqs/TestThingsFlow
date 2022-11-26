import Foundation

import ReactorKit

final class IssueListReactor: Reactor {
    enum Action {
        case viewDidLoad
        case search(owner: String, repo: String)
        case willDisplayCell(indexPath: IndexPath)
        case selectRow(IndexPath)
    }
    
    enum Mutation {
        case showURL
        case setIssues([Issue])
        case appendIssues([Issue])
        case showErrorAlert(Error)
        case setCurrentOwner(String)
        case setCurrentRepo(String)
        case showIssueDetail(Issue)
    }
    
    struct State {
        var issues: [Issue]
        var currentOwner: String
        var currentRepo: String
        @Pulse var showURL: Void?
        @Pulse var error: Error?
        @Pulse var showIssue: Issue?
    }
    
    var initialState: State
    private let githubService: GitHubServiceType
    private var currentPage = 1
    private let pageCount = 20
    private var isLast = false
    private var isLoadingService = false
    private let userDefaults: UserDefaults
    private let globalState: GlobalState
    
    init(
        initialState: State,
        githubService: GitHubServiceType,
        userDefaults: UserDefaults,
        globalState: GlobalState
    ) {
        self.initialState = initialState
        self.githubService = githubService
        self.userDefaults = userDefaults
        self.globalState = globalState
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .search(let owner, let repo):
            self.currentPage = 1
            self.isLast = false
            
            if owner.isEmpty || repo.isEmpty {
                return Observable.just(
                    Mutation.showErrorAlert(CommonError.custom(message: "입력되지 않은 정보가 있습니다."))
                )
            } else {
                return self.searchRepository(owner: owner, repo: repo)
            }
            
        case .willDisplayCell(let indexPath):
            guard self.canLoadMore(row: indexPath.row) else { return .empty() }
            self.isLoadingService = true
            
            return self.searchRepository(isWillDisplayCell: true)
            
        case .viewDidLoad:
            return self.searchRepository(
                owner: self.currentState.currentOwner,
                repo: self.currentState.currentRepo
            )
            
        case .selectRow(let indexPath):
            if indexPath.row == 4 {
                return Observable.just(Mutation.showURL)
            } else {
                return Observable.just(
                    Mutation.showIssueDetail(self.currentState.issues[indexPath.row])
                )
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .showURL:
            newState.showURL = ()
            
        case .setIssues(let issues):
            newState.issues = issues
                        
        case .appendIssues(let issues):
            newState.issues.append(contentsOf: issues)
            
        case .showErrorAlert(let error):
            newState.error = error
            
        case .setCurrentOwner(let owner):
            newState.currentOwner = owner
            
        case .setCurrentRepo(let repo):
            newState.currentRepo = repo
            
        case .showIssueDetail(let issue):
            newState.showIssue = issue
        }
        
        return newState
    }
    
    func transform(action: Observable<Action>) -> Observable<Action> {
        return .merge([
            action,
            self.globalState.refreshIssue.map { .search(owner: $0.owner, repo: $0.repo) }
        ])
    }
        
    private func canLoadMore(row: Int) -> Bool {
        return self.currentState.issues.count - 1 <= row
        && !self.isLast
        && !self.isLoadingService
    }
        
    private func searchRepository(
        owner: String = "",
        repo: String = "",
        isWillDisplayCell: Bool = false
    ) -> Observable<Mutation> {
        return self.githubService.searchIssue(
            owner: isWillDisplayCell ? self.currentState.currentOwner : owner,
            repoName: isWillDisplayCell ? self.currentState.currentRepo : repo,
            perPage: self.pageCount,
            currentPage: self.currentPage
        )
        .do(onNext: { [weak self] issues in
            guard let self = self else { return }
            
            if issues.isEmpty {
                self.isLast = true
            } else {
                self.currentPage += 1
            }
            
            if isWillDisplayCell {
                self.isLoadingService = false
            }
        })
        .flatMap { issues -> Observable<Mutation> in
            if isWillDisplayCell {
                return Observable.just(Mutation.appendIssues(issues))
            } else {
                var addBannerIssues = issues
                
                if addBannerIssues.count > 5 {
                    addBannerIssues.insert(Issue(), at: 4)
                }
                self.userDefaults.set(owner, forKey: "keyOwner")
                self.userDefaults.set(repo, forKey: "keyRepo")
                
                return Observable.merge([
                    Observable.just(Mutation.setIssues(addBannerIssues)),
                    Observable.just(Mutation.setCurrentOwner(owner)),
                    Observable.just(Mutation.setCurrentRepo(repo))
                ])
            }
        }
        .catch { [weak self] error in
            if isWillDisplayCell {
                self?.isLoadingService = false
            }
            
            return Observable.just(Mutation.showErrorAlert(error))
        }
    }
}

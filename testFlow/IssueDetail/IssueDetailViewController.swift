import UIKit

import ReactorKit
import RxCocoa

class IssueDetailViewController: UIViewController, View {
    static func instances(issue: Issue) -> IssueDetailViewController {
        let viewController = IssueDetailViewController()
        viewController.reactor = IssueDetailReactor(
            initialState: IssueDetailReactor.State(issue: issue)
        )
        
        return viewController
    }
    
    var disposeBag: DisposeBag = DisposeBag()

    private let issueDetailView = IssueDetailView()
    
    override func loadView() {
        self.view = self.issueDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bind(reactor: IssueDetailReactor) {
        reactor.state.map { $0.issue }
            .asDriver(onErrorJustReturn: nil)
            .compactMap { $0 }
            .drive(onNext: { [weak self] issue in
                self?.issueDetailView.configure(issue: issue)
            })
            .disposed(by: self.disposeBag)
    }
}


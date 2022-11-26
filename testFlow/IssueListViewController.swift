import UIKit

import ReactorKit
import RxCocoa

class IssueListViewController: UIViewController, View {
    static func instances() -> UINavigationController {
        let viewController = IssueListViewController()
        
        return UINavigationController(rootViewController: viewController)
    }
    
    var disposeBag: DisposeBag = DisposeBag()

    private let issueListView = IssueListView()
    
    private let barButtonItem = UIBarButtonItem(
        title: "Search",
        style: .plain,
        target: self,
        action: nil
    )
    
    override func loadView() {
        self.view = self.issueListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = barButtonItem
        self.reactor = IssueListReactor(githubService: GitHubService())
        self.reactor?.action.onNext(.viewDidLoad)
    }
        
    func bind(reactor: IssueListReactor) {
        reactor.state.map { ($0.currentOwner, $0.currentRepo) }
            .asDriver(onErrorJustReturn: ("",""))
            .map { "\($0.0)/\($0.1)"}
            .drive(self.issueListView.repoTitleLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.issues }
            .asDriver(onErrorJustReturn: [])
            .drive(self.issueListView.tableView.rx.items(
                cellIdentifier: IssueCell.registerID, cellType: IssueCell.self)
            ) { index, issue, cell in
                cell.configure(issue: issue)
            }
            .disposed(by: self.disposeBag)
        
        self.issueListView.tableView.rx.willDisplayCell
            .map { Reactor.Action.willDisplayCell(indexPath: $0.indexPath) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.barButtonItem.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.showSearchAlert()
            })
            .disposed(by: self.disposeBag)
        
        self.issueListView.tableView.rx.itemSelected
            .map { Reactor.Action.selectRow($0) }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.pulse(\.$error)
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: CommonError.unKnown)
            .drive(onNext: { [weak self] in
                self?.showAlert(error: $0)
            })
            .disposed(by: self.disposeBag)
        
        reactor.pulse(\.$showURL)
            .compactMap { $0 }
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {
                if let url = URL(string: "https://thingsflow.kr") {
                    UIApplication.shared.open(url, options: [:])
                }
            })
            .disposed(by: self.disposeBag)
        
        reactor.pulse(\.$showIssue)
            .asDriver(onErrorJustReturn: nil)
            .compactMap { $0 }
            .drive(onNext: {
                let viewController = IssueDetailViewController.instances(issue: $0)
                self.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func showAlert(error: Error) {
        let alertController = UIAlertController(
            title: nil,
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true)
    }
    
    private func showSearchAlert() {
        let alertController = UIAlertController(
            title: "Search",
            message: nil,
            preferredStyle: .alert
        )
        
        alertController.addTextField {
            $0.placeholder = "Owner"
        }
        alertController.addTextField {
            $0.placeholder = "Repo"
        }
        
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.reactor?.action.onNext(
                .search(
                    owner: alertController.textFields?[0].text ?? "",
                    repo: alertController.textFields?[1].text ?? ""
                )
            )
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
}


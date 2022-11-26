import UIKit

class IssueListViewController: UIViewController {
    static func instances() -> UINavigationController {
        let viewController = IssueListViewController()
        
        return UINavigationController(rootViewController: viewController)
    }
    
    private let issueListView = IssueListView()
    
    override func loadView() {
        self.view = self.issueListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
    }
}


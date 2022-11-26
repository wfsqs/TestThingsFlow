import UIKit

import Then
import SnapKit

class IssueListView: UIView {
    let repoTitleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont.systemFont(ofSize: 30)
    }
    
    let tableView = UITableView().then {
        $0.register(IssueCell.self, forCellReuseIdentifier: IssueCell.registerID)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        self.backgroundColor = .white
        
        self.addSubview(self.repoTitleLabel)
        self.addSubview(self.tableView)
                
        self.repoTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(20)
            $0.left.equalToSuperview().offset(20)
        }
        
        self.tableView.snp.makeConstraints {
            $0.top.equalTo(self.repoTitleLabel.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}


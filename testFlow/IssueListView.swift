import UIKit

import Then
import SnapKit

class IssueListView: UIView {
    private let searchButton = UIButton().then {
        $0.setTitle("Search", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    
    private let repoTitleLabel = UILabel().then {
        $0.textColor = .black
    }
    
    private let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        self.backgroundColor = .white
        
        self.addSubview(self.searchButton)
        self.addSubview(self.repoTitleLabel)
        self.addSubview(self.tableView)
        
        self.searchButton.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.right.equalToSuperview().inset(10)
        }
        
        self.repoTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.searchButton.snp.bottom).offset(20)
            $0.left.equalToSuperview()
        }
        
        self.tableView.snp.makeConstraints {
            $0.top.equalTo(self.repoTitleLabel.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}


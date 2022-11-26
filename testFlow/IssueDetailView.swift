import UIKit

import Then
import SnapKit

class IssueDetailView: UIView {
    let profileImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 25
    }
    
    let nameLabel = UILabel().then {
        $0.textColor = .black
    }
    
    let contentsLabel = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(issue: Issue) {
        self.profileImageView.sd_setImage(
            with: URL(string: issue.profileURL)
        )
        self.nameLabel.text = issue.userName
        self.contentsLabel.text = issue.contents
    }

    private func setLayout() {
        self.backgroundColor = .white
        
        self.addSubview(self.profileImageView)
        self.addSubview(self.nameLabel)
        self.addSubview(self.contentsLabel)
        
        self.profileImageView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.left.equalToSuperview().inset(10)
            $0.width.height.equalTo(50)
        }
        
        self.nameLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.profileImageView)
            $0.left.equalTo(self.profileImageView.snp.right).offset(20)
        }
        
        self.contentsLabel.snp.makeConstraints {
            $0.top.equalTo(self.profileImageView.snp.bottom).offset(20)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}


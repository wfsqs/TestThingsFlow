import Foundation
import UIKit

import RxSwift
import SDWebImage

final class IssueCell: UITableViewCell {
    static let registerID = "\(IssueCell.self)"
    
    var disposeBag = DisposeBag()
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = .black
        $0.isHidden = true
    }
    
    private let bannerImageView = UIImageView().then {
        $0.isHidden = true
    }
            
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
        self.bindConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.isHidden = true
        self.bannerImageView.isHidden = true
        self.disposeBag = DisposeBag()
    }
    
    func configure(issue: Issue, isShowBanner: Bool = false) {
        if isShowBanner {
            let url = URL(string: "https://s3.ap-northeast-2.amazonaws.com/hellobot-kr-test/image/main_logo.png")
            self.bannerImageView.isHidden = false
            self.bannerImageView.sd_setImage(with: url)
        } else {
            self.titleLabel.isHidden = false
            self.titleLabel.text = "\(issue.number) - " + issue.title
        }
    }
        
    private func setup() {
        self.contentView.addSubview(self.stackView)
        
        self.stackView.addArrangedSubview(self.titleLabel)
        self.stackView.addArrangedSubview(self.bannerImageView)
    }
    
    private func bindConstraints() {
        self.stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

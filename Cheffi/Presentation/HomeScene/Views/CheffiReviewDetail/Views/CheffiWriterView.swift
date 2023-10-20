//
//  CheffiWriterView.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/05.
//

import UIKit

class CheffiWriterView: BaseView {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var writerContentView: UIView!
    private let profileView: ProfileView = ProfileView()
    var didTapFollowWriterInfo: ((ReviewWriterInfoDTO?, Bool) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    // MARK: - Private
    private func setupViews() {
        titleLabel.text = "작성자".localized()
        titleLabel.font = Fonts.suit.weight700.size(18.0)
        titleLabel.textColor = .cheffiGray9
        
        writerContentView.addSubview(profileView)
        profileView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        profileView.didTapFollowWriterInfo = { [weak self] writerInfo, isSelected in
            self?.didTapFollowWriterInfo?(writerInfo, isSelected)
        }
    }
    
    // MARK: - Public
    func updateWriter(_ writerInfo: ReviewWriterInfoDTO) {
        profileView.updateWriter(writerInfo)
    }
}

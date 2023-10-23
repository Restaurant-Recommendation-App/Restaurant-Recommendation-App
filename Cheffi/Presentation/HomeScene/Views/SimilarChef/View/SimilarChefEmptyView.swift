//
//  SimilarChefEmptyView.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/23/23.
//

import UIKit

final class SimilarChefEmptyView: BaseView {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var selectButton: UIButton!
    
    var didTapSelectButton: (() -> Void)?
    
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
        titleLabel.text = "아직 나의 취향 선택을 안하셨나요?\n나와 비슷한 사람들은 무엇을 먹었는지 알아봐요!".localized()
        titleLabel.font = Fonts.suit.weight500.size(14)
        titleLabel.textColor = .cheffiGray6
        
        selectButton.setTitle("내 취향 선택하기".localized(), for: .normal)
        selectButton.setTitleColor(.mainCTA, for: .normal)
        selectButton.titleLabel?.font = Fonts.suit.weight600.size(15)
        selectButton.backgroundColor = UIColor(hexString: "FFF2F4")
        selectButton.layerCornerRadius = 10
    }
    
    // MARK: - Actions
    @IBAction func didTapButtonAction(_ sender: UIButton) {
        didTapSelectButton?()
    }
}

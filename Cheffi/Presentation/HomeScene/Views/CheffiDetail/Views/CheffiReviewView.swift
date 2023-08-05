//
//  CheffiReviewView.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/07/29.
//

import UIKit

enum ReviewState: Int, CaseIterable {
    case positive = 0
    case neutral
    case negative
    
    var title: String {
        switch self {
        case .positive: return "맛있어요".localized()
        case .neutral: return "평범해요".localized()
        case .negative: return "별로에요".localized()
        }
    }
}

class CheffiReviewView: BaseView {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private var reviewButtons: [UIButton]!
    @IBOutlet private var reviewLabels: [UILabel]!
    @IBOutlet private var reviewCountLabels: [UILabel]!
    
    enum Constants {
        static let defaultColor: UIColor = .cheffiGray5
        static let selectedColor: UIColor = .cheffiGray8
    }
    
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
        titleLabel.text = "이 식당 어떠셨나요?".localized()
        
        reviewButtons.forEach({ $0.isSelected = false })
        for i in 0..<reviewLabels.count {
            let reviewState = ReviewState(rawValue: i)
            let label = reviewLabels[i]
            label.text = reviewState?.title
            label.textColor = Constants.defaultColor
        }
        
        for i in 0..<reviewCountLabels.count {
            let label = reviewCountLabels[i]
            label.text = "0"
            label.textColor = Constants.defaultColor
        }
    }
    
    // MARK: - Actions
    @IBAction private func didTapReview(_ sender: UIButton) {
        reviewButtons.forEach({ $0.isSelected = false })
        reviewLabels.forEach({ $0.textColor = Constants.defaultColor })
        reviewCountLabels.forEach({ $0.textColor = Constants.defaultColor })
        
        sender.isSelected = !sender.isSelected
        reviewLabels[sender.tag].textColor = Constants.selectedColor
        reviewCountLabels[sender.tag].textColor = Constants.selectedColor
    }
}

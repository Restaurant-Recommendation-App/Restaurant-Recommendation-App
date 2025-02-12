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
    
    var textColor: UIColor {
        switch self {
        case .positive: return UIColor(hexString: "437CEB")!
        case .neutral: return UIColor(hexString: "28DB85")!
        case .negative: return UIColor.mainCTA
        }
    }
}

class CheffiReviewView: BaseView {
    var didTapReviewState: ((ReviewState) -> Void)?
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var positiveStackView: UIStackView!
    @IBOutlet private weak var neutralStackView: UIStackView!
    @IBOutlet private weak var negativeStackView: UIStackView!
    
    private lazy var reviewButtons: [UIButton] = {
        let positiveButton = positiveStackView.arrangedSubviews[safe: 0] as? UIButton
        let neutralButton = neutralStackView.arrangedSubviews[safe: 0] as? UIButton
        let negativeButton = negativeStackView.arrangedSubviews[safe: 0] as? UIButton
        return [positiveButton, neutralButton, negativeButton].compactMap { $0 }
    }()
    private lazy var reviewLabels: [UILabel] = {
        let positiveLabel = positiveStackView.arrangedSubviews[safe: 1] as? UILabel
        let neutralLabel = neutralStackView.arrangedSubviews[safe: 1] as? UILabel
        let negativeLabel = negativeStackView.arrangedSubviews[safe: 1] as? UILabel
        return [positiveLabel, neutralLabel, negativeLabel].compactMap { $0 }
    }()
    private lazy var reviewVotingLabels: [UILabel] = {
        let positiveLabel = positiveStackView.arrangedSubviews[safe: 2] as? UILabel
        let neutralLabel = neutralStackView.arrangedSubviews[safe: 2] as? UILabel
        let negativeLabel = negativeStackView.arrangedSubviews[safe: 2] as? UILabel
        return [positiveLabel, neutralLabel, negativeLabel].compactMap { $0 }
    }()
    
    private enum Constants {
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
        titleLabel.font = Fonts.suit.weight700.size(18.0)
        titleLabel.textColor = .cheffiGray9
        
        reviewButtons.forEach({ $0.isSelected = false })
        for i in 0..<reviewLabels.count {
            let reviewState = ReviewState(rawValue: i)
            let label = reviewLabels[i]
            label.text = reviewState?.title
            label.font = Fonts.suit.weight400.size(12.0)
            label.textColor = Constants.defaultColor
        }

        for i in 0..<reviewVotingLabels.count {
            let label = reviewVotingLabels[i]
            label.text = "0"
            label.font = Fonts.suit.weight400.size(12.0)
            label.textColor = Constants.defaultColor
        }
    }
    
    // MARK: - Public
    func updateReviewButtons(for state: ReviewState?) {
        for i in 0..<reviewButtons.count {
            let reviewButton = reviewButtons[i]
            let reviewLabel = reviewLabels[i]
            let votingLabel = reviewVotingLabels[i]

            let isSelected = state?.rawValue == i
            reviewButton.isSelected = isSelected
            reviewLabel.textColor = isSelected ? Constants.selectedColor : Constants.defaultColor
            votingLabel.textColor = isSelected ? state?.textColor : Constants.defaultColor
        }
    }
    
    func updateRatings(_ ratings: [String: Int]?) {
        guard let ratings = ratings else { return }
        for (index, value) in [ratings[RatingType.good.rawValue], ratings[RatingType.average.rawValue], ratings[RatingType.bad.rawValue]].enumerated() {
            reviewVotingLabels[index].text = value?.string ?? "0"
        }
    }
    
    // MARK: - Actions
    @IBAction private func didTapReview(_ sender: UIButton) {
        guard let state = ReviewState(rawValue: sender.tag) else { return }
        didTapReviewState?(state)
    }
}

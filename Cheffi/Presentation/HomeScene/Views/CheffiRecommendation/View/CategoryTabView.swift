//
//  CategoryTabView.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/21.
//

import UIKit
import SnapKit

class TabButton: UIButton {
    
    enum Constants {
        static let verticalInset: CGFloat = 10
        static let horizontalInset: CGFloat = 16
    }
    
    private let defaultTabColor = UIColor.cheffiGray5
    private let selectedTabColor = UIColor.main
    
    private let borderLayer = CALayer()
    
    var isSelectedTab = false {
        didSet {
            self.updateConfiguration()
            if isSelectedTab {
                removeLayer(with: borderLayer)
                addBottomBorderWithColor(layer: borderLayer, color: .main, width: 2)
            } else {
                removeLayer(with: borderLayer)
            }
        }
    }
    
    override func updateConfiguration() {
        var config = UIButton.Configuration.filled()
        config.contentInsets = NSDirectionalEdgeInsets(
            top: Constants.verticalInset,
            leading: Constants.horizontalInset,
            bottom: Constants.verticalInset,
            trailing: Constants.horizontalInset
        )
        config.baseForegroundColor = isSelectedTab ? selectedTabColor : defaultTabColor
        config.baseBackgroundColor = .clear
        
        let attributedContainer = AttributeContainer(
            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: isSelectedTab ? .bold :.regular)]
        )
        
        config.attributedTitle = AttributedString(
            self.currentTitle ?? "",
            attributes: attributedContainer
        )
        self.configuration = config
    }
}

protocol CategoryTabViewDelegate {
    func didTapCategory(index: Int)
}

class CategoryTabView: UIView {
    
    enum Constants {
        static let cellInset = 16
    }
    
    private let scrollView = UIScrollView()
    
    private let tabStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let tabsBottomBoder: UIView = {
        let view = UIView()
        return view
    }()
    
    var delegate: CategoryTabViewDelegate?
    
    private var selectedTag = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUp() {
        scrollView.showsHorizontalScrollIndicator = false
        
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scrollView.addSubview(tabStackView)
        
        tabStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Constants.cellInset)
            make.height.equalTo(scrollView)
        }
        
        scrollView.addSubview(tabsBottomBoder)
        tabsBottomBoder.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        scrollView.sendSubviewToBack(tabsBottomBoder)
    }
    
    func setUpCategories(categories: [String]) {
        let buttons = categories.enumerated().map {
            let button = TabButton()
            button.setTitle($0.element, for: .normal)
            button.titleLabel?.textAlignment = .center
            button.addTarget(self, action: #selector(tappedCategory(_:)), for: .touchUpInside)
            button.tag = $0.offset
            button.isSelectedTab = false
            return button
        }
        
        tabStackView.addArrangedSubviews(buttons)
            
        layoutIfNeeded()
        tabsBottomBoder.addBottomBorderWithColor(
            layer: CALayer(),
            color: .cheffiWhite05,
            width: 2
        )
        buttons.first?.isSelectedTab = true
    }
    
    @objc func tappedCategory(_ sender: UIButton) {
        changeSelected(with: sender.tag)
        delegate?.didTapCategory(index: sender.tag)
    }
    
    private func changeSelected(with selectedTag: Int) {
        let tabButtons = tabStackView.arrangedSubviews
            .compactMap { $0 as? TabButton }
        
        guard let deselectingTag = tabButtons
            .first(where: { $0.isSelectedTab })?.tag
        else { return }

        tabButtons[safe: deselectingTag]?.isSelectedTab = false
        tabButtons[safe: selectedTag]?.isSelectedTab = true
    }
}

extension CategoryTabView: CheffiRecommendationCategoryPageViewDelegate {
    func didSwipe(indexPath: IndexPath?) {
        guard let index = indexPath?.row else { return }
        changeSelected(with: index)
    }
}

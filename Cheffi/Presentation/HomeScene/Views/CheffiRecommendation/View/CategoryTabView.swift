//
//  CategoryTabView.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/21.
//

import UIKit
import Combine
import SnapKit

class TabButton: UIButton {
    
    private enum Constants {
        static let verticalInset: CGFloat = 10
        static let horizontalInset: CGFloat = 16
        static let defaultTabColor: UIColor = .cheffiGray5
        static let selectedTabColor: UIColor = .main
    }
    
    private let borderLayer = CALayer()
    
    var isSelectedTab = false {
        didSet {
            self.updateConfiguration()
            removeBorder(with: borderLayer)
            if isSelectedTab {
                addBorderWithColor(layer: borderLayer, edge: .bottom ,color: .main, width: 2)
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
        config.baseForegroundColor = isSelectedTab ? Constants.selectedTabColor : Constants.defaultTabColor
        config.baseBackgroundColor = .clear
        
        let attributedContainer = AttributeContainer(
            [NSAttributedString.Key.font: isSelectedTab ? Fonts.suit.weight700.size(15) :Fonts.suit.weight400.size(15)]
        )
        
        config.attributedTitle = AttributedString(
            self.currentTitle ?? "",
            attributes: attributedContainer
        )
        self.configuration = config
    }
}

// TODO: 제거 필요, CategoryView로 대체
class CategoryTabView: UIView {
    weak var categoryDelegate: CategoryTabViewDelegate?
    
    private enum Constants {
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
            $0.height.equalTo(2)
        }
        scrollView.sendSubviewToBack(tabsBottomBoder)
    }

    func setUpTags(tags: [String]) {
        tabStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        let buttons = tags.enumerated().map {
            let button = TabButton()
            button.setTitle($0.element, for: .normal)
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.font = Fonts.suit.weight400.size(15)
            button.addTarget(self, action: #selector(tappedCategory(_:)), for: .touchUpInside)
            button.tag = $0.offset
            button.isSelectedTab = false
            return button
        }
        
        tabStackView.addArrangedSubviews(buttons)
        
        layoutIfNeeded()
        tabsBottomBoder.addBorderWithColor(
            layer: CALayer(),
            edge: .bottom,
            color: .cheffiWhite05,
            width: 2
        )
        
        // 기본 버튼 태그 높이 강제 지정
        buttons.first?.frame = CGRect(x: 0, y: 0, width: buttons.first?.frame.width ?? 0, height: 50)
        buttons.first?.isSelectedTab = true
    }
    
    @objc func tappedCategory(_ sender: UIButton) {
        changeSelected(with: sender.tag)
        categoryDelegate?.didTapCategory(index: sender.tag)
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

extension CategoryTabView: CategoryPageViewDelegate {
    func categoryPageViewDelegate(_ view: UICollectionView, didSwipe indexPath: IndexPath?) {
        guard let index = indexPath?.row else { return }
        changeSelected(with: index)
    }
}

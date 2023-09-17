//
//  PageControlButton.swift
//  Cheffi
//
//  Created by RONICK on 2023/09/09.
//

import UIKit
import Combine
import SnapKit

final class PageControlButton: UIView {
    
    enum PageType {
        case prev
        case next
        case current
    }
    
    private let pageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 1
        return label
    }()
    
    private let prevButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icArrowLeft"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icArrowRight"), for: .normal)
        return button
    }()
    
    private var currentPage = 1
    private var limitPage = 1
    
    private var cancellables = Set<AnyCancellable>()
    private var didSwiped = PassthroughSubject<Int, Never>()
    
    var tapped: AnyPublisher<PageType, Never> {
        let prev = prevButton.controlPublisher(for: .touchUpInside).map { _ in PageType.prev }
        let next = nextButton.controlPublisher(for: .touchUpInside).map { _ in PageType.next }
        
        return prev.merge(with: next)
            .throttle(for: 0.2, scheduler: RunLoop.main, latest: false)
            .filter(self.validatePage)
            .eraseToAnyPublisher()
    }
            
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUp() {
        addSubview(prevButton)
        prevButton.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
            $0.width.height.equalTo(32)
        }
        
        addSubview(pageLabel)
        pageLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(48)
            $0.height.equalTo(24)
        }
        
        addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
            $0.width.height.equalTo(32)
        }
    }
    
    func configure(currentPage: Int, limitPage: Int, swiped: PassthroughSubject<Int, Never>) {
        self.limitPage = limitPage
        setPageText(currentPage: currentPage)
        didSwiped = swiped
        bind()
    }
    
    private func bind() {
        didSwiped
            .receive(on: DispatchQueue.main)
            .sink {
                self.setPageText(currentPage: $0 + 1)
            }.store(in: &cancellables)
        
        tapped
            .receive(on: DispatchQueue.main)
            .sink {
                self.setPageText(currentPage: ($0 == .next) ? self.currentPage + 1 : self.currentPage - 1)
            }.store(in: &cancellables)
    }
    
    private func setPageText(currentPage: Int) {
        self.currentPage = currentPage
        self.pageLabel.attributedText = getSubtitleAttributedString(currentPage: currentPage, limitPage: limitPage)
    }
    
    private func validatePage(pageType: PageType) -> Bool {
        switch pageType {
        case .next: return currentPage + 1 >= 1 && currentPage + 1 <= limitPage
        case .prev: return currentPage - 1 >= 1 && currentPage - 1 <= limitPage
        default: return false
        }
    }
    
    private func getSubtitleAttributedString(currentPage: Int, limitPage: Int) -> NSAttributedString {
        let str1 = "\(currentPage)"
        let color1 = UIColor.cheffiBlack
        let font1 = Fonts.suit.weight500.size(16)
        
        let str2 = " / \(limitPage)"
        let color2 = UIColor.cheffiGray8
        let font2 = Fonts.suit.weight500.size(16)
        
        let combination = NSMutableAttributedString()
        
        let attr1 = [NSAttributedString.Key.foregroundColor: color1, NSAttributedString.Key.font: font1]
        let part1 = NSMutableAttributedString(string: str1, attributes: attr1 as [NSAttributedString.Key : Any])
        
        let attr2 = [NSAttributedString.Key.foregroundColor: color2, NSAttributedString.Key.font: font2]
        let part2 = NSMutableAttributedString(string: str2, attributes: attr2)
        
        combination.append(part1)
        combination.append(part2)
        
        return combination
    }
}

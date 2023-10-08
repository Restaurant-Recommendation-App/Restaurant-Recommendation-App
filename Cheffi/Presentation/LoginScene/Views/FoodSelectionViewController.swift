//
//  FoodSelectionViewController.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/07.
//

import UIKit
import Combine

class FoodSelectionViewController: UIViewController {
    static func instance<T: FoodSelectionViewController>() -> T {
        let vc: T = .instance(storyboardName: .foodSelection)
        return vc
    }
    
    private enum Constants {
        static let maximumNumberOfSelection: Int = 3
    }
    
    @IBOutlet private weak var nextButton: CustomProfileButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var foodTagListView: ProfileTagListView!
    var delegate: ProfileSetupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let nickname = UserDefaultsManager.AuthInfo.user?.nickname ?? ""
        titleLabel.text = "\(nickname) 쉐피님,\n좋아하는 음식을 선택해주세요.".localized()
    }
    
    // MARK: - Private
    private func setupViews() {
        nextButton.setTitle("다음".localized(), for: .normal)
        nextButton.didTapButton = { [weak self] in
            self?.delegate?.didTapNext()
        }
        
        titleLabel.textColor = .cheffiGray9
        titleLabel.font = Fonts.suit.weight600.size(24)
        
        let subTitleFont = Fonts.suit.weight600.size(15)
        subTitleLabel.highlightKeyword("3가지".localized(), in: "3가지 이상 선택해주세요".localized(),
                                       defaultColor: .cheffiGray6, font: subTitleFont, keywordFont: subTitleFont)
        
        // TEST Code
        let tags = ["한식", "양식", "일식", "중식", "샐러드", "해산물", "카페", "빵집", "분식", "면/국수", "브런치", "한정식", "구이", "디저트", "회", "백반/가정식", "아시아음식", "비건", "샌드위치", "죽", "돈까스", "피자", "치킨", "족발/보쌈", "고기", "패스트푸드", "초밥", "찜닭", "탕/찌개", "햄버거", "파인다이닝"]
        
        foodTagListView.setupTags(tags)
        foodTagListView.didTapTagsHandler = { [weak self] selectedTags in
            self?.nextButton.isEnable = selectedTags.count >= Constants.maximumNumberOfSelection
        }
    }
    
    
    // MARK: - Public
    
    // MAKR: - Actions
}

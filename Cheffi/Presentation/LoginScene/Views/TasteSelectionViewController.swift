//
//  TasteSelectionViewController.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/07.
//

import UIKit
import Combine

class TasteSelectionViewController: UIViewController {
    static func instance<T: TasteSelectionViewController>() -> T {
        let vc: T = .instance(storyboardName: .tasteSelection)
        return vc
    }
    
    private enum Constants {
        static let maximumNumberOfSelection: Int = 5
    }
    
    @IBOutlet private weak var nextButton: CustomProfileButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var tasteTagListView: ProfileTagListView!
    var delegate: ProfileSetupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let nickname = UserDefaultsManager.AuthInfo.user?.name ?? ""
        titleLabel.text = "\(nickname) 쉐피님,\n쉐피님의 취향을 선택해주세요.".localized()
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
        subTitleLabel.highlightKeyword("5가지".localized(), in: "5가지 이상 선택해주세요".localized(),
                                       defaultColor: .cheffiGray6,
                                       font: subTitleFont, keywordFont: subTitleFont)
        
        // TEST Code
        let tags = ["매콤한", "자극적인", "담백한", "넓은", "달닳나", "얼큰한", "시원한", "깔끔한", "깊은맛", "새콤한", "따뜻한", "조용한", "감성적인", "사진맛집", "혼술", "혼밥", "아늑한", "레트로", "트렌디한", "노포", "데이트", "한정메뉴", "독특한", "모임", "특별한", "가성비", "향신료", "밥도둑"]
        
        tasteTagListView.setupTags(tags)
        tasteTagListView.didTapTagsHandler = { [weak self] selectedTags in
            self?.nextButton.isEnable = selectedTags.count >= Constants.maximumNumberOfSelection
        }
    }
    
    // MARK: - Public
    
    // MAKR: - Actions
}

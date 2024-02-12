//
//  SearchViewController.swift
//  Cheffi
//
//  Created by USER on 2023/07/22.
//

import UIKit
import SnapKit
import Combine

enum SearchCategory: Int {
    case food = 0
    case area
    
    var title: String {
        switch self {
        case .food:
            return "음식 검색"
        case .area:
            return "지역 검색"
        }
    }
}

class SearchViewController: UIViewController {
    typealias ViewModel = SearchViewModel
    
    var viewModel: ViewModel!
    var cancellables = Set<AnyCancellable>()
    var searchViewLayout = SearchViewLayout()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icBack"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private lazy var categoryTabView: CategoryView =  {
        let categoryView = CategoryView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        categoryView.categoryDelegate = self
        
        return categoryView
    }()
    
    private lazy var categoryBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = .cheffiGray10
        
        return view
    }()
    
    private lazy var searchBar: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .cheffiWhite05.withAlphaComponent(0.3725)
        
        let attributedPlaceHolder = NSMutableAttributedString(string: "검색어를 입력해주세요.", attributes:[
            NSAttributedString.Key.foregroundColor: UIColor.cheffiGray6,
            NSAttributedString.Key.font: Fonts.suit.weight500.size(16)
        ])
        textField.attributedPlaceholder = attributedPlaceHolder
        
        textField.layer.cornerRadius = 5
        textField.layer.masksToBounds = true
        
        textField.addLeftIcon(withImage: UIImage(named: "icSearch"), imageSize: CGSize(width: 24, height: 24))
        
        return textField
    }()
    
    private lazy var searchCategoryListView: SearchCategoryListView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let listView = SearchCategoryListView(frame: .zero, collectionViewLayout: layout)
        return listView
    }()
        
    private var initialize = PassthroughSubject<Void, Never>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        configure(viewModel: viewModel)
    }
    
    private func setUpLayout() {
        view.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            $0.leading.equalToSuperview().inset(16)
            $0.width.height.equalTo(44)
        }
        
        view.addSubview(categoryBorderView)
        view.addSubview(categoryTabView)
        categoryTabView.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
        
        categoryBorderView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(categoryTabView)
            $0.height.equalTo(1)
        }
        
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints {
            $0.top.equalTo(categoryTabView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
        
        view.addSubview(searchCategoryListView)
        searchCategoryListView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(40)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setUpTableView(recentSearches: [[String]]) {
        categoryTabView.configure(categories: [SearchCategory.food.title, SearchCategory.area.title])
        searchCategoryListView.configure(viewModels: recentSearches)
    }
    
    private func configure(viewModel: ViewModel) {
        bind(to: viewModel)
        initialize.send(())
    }
}

extension SearchViewController: Bindable {
    func bind(to viewModel: ViewModel) {
        let input = ViewModel.Input(initialize: initialize.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)
        
        output.recentSearches
            .sink { [weak self] recentSearches in
                self?.setUpTableView(recentSearches: recentSearches)
            }.store(in: &cancellables)
        
        backButton.controlPublisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }.store(in: &cancellables)
    }
}

extension SearchViewController: CategoryTabViewDelegate {
    func didTapCategory(index: Int) {
        searchCategoryListView.didTapCategory(index: index)
    }
}

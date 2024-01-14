//
//  AreaSelectionViewController.swift
//  Cheffi
//
//  Created by RONICK on 2023/10/20.
//

import UIKit
import SnapKit
import Combine

class AreaSelectionViewController: UIViewController {
    typealias ViewModel = AreaSelectionViewModel
    var viewModel: ViewModel!
    
    var cancellables = Set<AnyCancellable>()
    let initialize = PassthroughSubject<Void, Never>()
    let didSelectProvinceArea = PassthroughSubject<Int, Never>()
    let didSelectCityArea = PassthroughSubject<Int, Never>()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icBack"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "지역선택"
        label.font = Fonts.suit.weight700.size(24)
        label.textColor = .cheffiBlack
        return label
    }()
    
    private let shadowView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let selectButton = CustomProfileButton()
    
    private let provinceSelectionTableView: UITableView = UITableView()
    private let citySelectionTableView: UITableView = UITableView()
        
    private var siSelectionDiffableDataSource: UITableViewDiffableDataSource<Int, AreaSelection>?
    private var guSelectionDiffableDataSource: UITableViewDiffableDataSource<Int, AreaSelection>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        setUpTableViews()
        setUpSelectButton()
        setUpSelectButtonShadow()
        configure(viewModel: viewModel)
    }
    
    private func setUpLayout() {
        view.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            $0.leading.equalToSuperview().offset(16)
            $0.width.height.equalTo(44)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(18)
            $0.leading.equalToSuperview().offset(28)
            $0.trailing.equalToSuperview()
        }
        
        let borderView = UIView()
        borderView.backgroundColor = .cheffiGray1
        view.addSubview(borderView)
        borderView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        view.addSubview(provinceSelectionTableView)
        view.addSubview(citySelectionTableView)
        view.addSubview(shadowView)
                
        view.addSubview(selectButton)
        selectButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(48)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        shadowView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(selectButton.snp.top)
            $0.height.equalTo(1)
        }
        
        provinceSelectionTableView.snp.makeConstraints {
            $0.top.equalTo(borderView.snp.bottom)
            $0.leading.equalToSuperview()
            $0.bottom.equalTo(selectButton.snp.top)
            $0.width.equalTo(131)
        }
        
        citySelectionTableView.snp.makeConstraints {
            $0.top.equalTo(borderView.snp.bottom)
            $0.leading.equalTo(provinceSelectionTableView.snp.trailing)
            $0.bottom.equalTo(selectButton.snp.top)
            $0.trailing.equalToSuperview().offset(-24)
        }
    }

    private func setUpTableViews() {
        provinceSelectionTableView.delegate = self
        citySelectionTableView.delegate = self
        
        provinceSelectionTableView.register(cellWithClass: ProvinceAreaTableViewCell.self)
        citySelectionTableView.register(cellWithClass: CityAreaTableViewCell.self)
        
        provinceSelectionTableView.separatorStyle = .none
        citySelectionTableView.separatorStyle = .none
        
        provinceSelectionTableView.showsVerticalScrollIndicator = false
        citySelectionTableView.showsVerticalScrollIndicator = false
        
        provinceSelectionTableView.alwaysBounceVertical = false
        citySelectionTableView.alwaysBounceVertical = false
        
        provinceSelectionTableView.backgroundColor = .clear
        citySelectionTableView.backgroundColor = .clear
            
        siSelectionDiffableDataSource = UITableViewDiffableDataSource<Int, AreaSelection>(tableView: provinceSelectionTableView) { (tableView, indexPath, item) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withClass: ProvinceAreaTableViewCell.self, for: indexPath)
            cell.configure(areaSelection: item)
            return cell
        }
        
        guSelectionDiffableDataSource = UITableViewDiffableDataSource<Int, AreaSelection>(tableView: citySelectionTableView) { (tableView, indexPath, item) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withClass: CityAreaTableViewCell.self, for: indexPath)
            cell.configure(areaSelection: item)
            return cell
        }
    }
    
    private func setUpSelectButton() {
        selectButton.isEnable = true
        selectButton.setTitle("선택", for: .normal)
        selectButton.setBackgroundColor(.main)
    }
    
    private func setUpSelectButtonShadow() {
        view.layoutIfNeeded()
        shadowView.layer.shadowColor = UIColor.white.cgColor
        shadowView.layer.shadowRadius = 5
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.shadowPath = CGPath(rect: CGRect(x: 0, y: -16, width: shadowView.bounds.width, height: 32), transform: nil)
    }
    
    private func reloadFirstSelectionItems(items: [AreaSelection]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, AreaSelection>()
        snapshot.appendSections([0])
        snapshot.appendItems(items)
        siSelectionDiffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func reloadSecondSelectionItems(items: [AreaSelection]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, AreaSelection>()
        snapshot.appendSections([0])
        snapshot.appendItems(items)
        guSelectionDiffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func configure(viewModel: ViewModel) {
        bind(to: viewModel)
        initialize.send(())
    }
}

extension AreaSelectionViewController: Bindable {
    func bind(to viewModel: ViewModel) {
        
        let tappedSelectButton = selectButton
            .controlPublisher(for: .touchUpInside)
            .map { _ in () }
            .share()
        
        let input = ViewModel.Input(
            initialize: initialize.eraseToAnyPublisher(),
            didSelectProvince: didSelectProvinceArea.eraseToAnyPublisher(),
            didSelectCity: didSelectCityArea.eraseToAnyPublisher(),
            didTappedComplteSelection: tappedSelectButton.eraseToAnyPublisher()
        )
        
        let output = viewModel.transform(input: input)
        
        output.provinces
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.reloadFirstSelectionItems(items: items)
            }.store(in: &cancellables)
        
        output.cities
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.reloadSecondSelectionItems(items: items)
            }.store(in: &cancellables)
        
        backButton.controlPublisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }.store(in: &cancellables)
        
        tappedSelectButton
            .sink { [weak self] _ in
                //TODO: 선택이후 이벤트가 정해지지 않아서, 현재는 뒤로가도록 함
                self?.navigationController?.popViewController(animated: true)
            }.store(in: &cancellables)
    }
}

extension AreaSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == provinceSelectionTableView {
            // TODO: 선택/로컬 저장후 다시 진입했을 시, index out of range 이슈
            didSelectProvinceArea.send(indexPath.row)
        } else if tableView == citySelectionTableView {
            didSelectCityArea.send(indexPath.row)
        }
    }
}

//
//  MoreViewController.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/05.
//

import UIKit
import PanModal

enum MoreMenu: Int, CaseIterable {
    case report
    
    var title: String {
        switch self {
        case .report: return "신고하기".localized()
        }
    }
    
    var image: UIImage? {
        switch self {
        case .report: return UIImage(named: "icSpeakerphone")
        }
    }
}

final class MoreViewController: UIViewController, PanModalPresentable {
    static func instance<T: MoreViewController>() -> T {
        let vc: T = .instance(storyboardName: .more)
        return vc
    }
    
    @IBOutlet private weak var dragIndicator: UIView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private var topContraint: NSLayoutConstraint!
    private var isMoreMenu: Bool = true {
        didSet {
            dragIndicator.isHidden = isMoreMenu
            topContraint.constant = isMoreMenu ? Constants.topHeightWhenMenu : Constants.topHeightWhenSubMenu
            self.view.layoutIfNeeded()
        }
    }
    private var moreMenu: [MoreMenu] = MoreMenu.allCases
    private var datasource: UITableViewDiffableDataSource<Int, String>? = nil
    // TODO: - 서버 통신 필요
    private var reportList: [String] = ["신고사유", "부적절한 사진 및 내용", "욕설 및 비난",
                                        "광고성 게시물", "사기 또는 거짓", "지적재산권 침해"]
    private var dynamicLongFormHeight: PanModalHeight = .intrinsicHeight
    
    private enum Constants {
        static let cellHeight: CGFloat = 50.0
        static let topHeightWhenMenu: CGFloat = 24.0
        static let topHeightWhenSubMenu: CGFloat = 40.0
        static let bottomHeightWhenMenu: CGFloat = 58.0
        static let bottomHeightWhenSubMenu: CGFloat = 50.0
    }
    
    var panScrollable: UIScrollView? {
        return tableView
    }
    var topOffset: CGFloat {
        return 0.0
    }
    var cornerRadius: CGFloat {
        return 20.0
    }
    var longFormHeight: PanModalHeight {
        return dynamicLongFormHeight
    }
    var panModalBackgroundColor: UIColor {
        return UIColor.black.withAlphaComponent(0.25)
    }
    var shouldRoundTopCorners: Bool {
        return true
    }
    var showDragIndicator: Bool {
        return false
    }
    var anchorModalToLongForm: Bool {
        return false
    }
    
    func panModalDidDismiss() {
        debugPrint("------------------------------------------")
        debugPrint("panModalDidDismiss")
        debugPrint("------------------------------------------")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLongFormHeight(to: topContraint.constant
                             + (Constants.cellHeight * CGFloat(MoreMenu.allCases.count))
                             + Constants.bottomHeightWhenMenu)
        isMoreMenu = true
    }
    
    // MARK: - Private
    private func setupViews() {
        tableView.delegate = self
        tableView.register(nibWithCellClass: MoreCell.self)
        tableView.register(nibWithCellClass: MoreSubCell.self)
        
        datasource = UITableViewDiffableDataSource<Int, String>(tableView: tableView, cellProvider: { tableView, indexPath, item in
            if self.isMoreMenu, let moreMenu = self.moreMenu[safe: indexPath.row] {
                let cell = tableView.dequeueReusableCell(withClass: MoreCell.self, for: indexPath)
                cell.configure(moreMenu: moreMenu)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withClass: MoreSubCell.self, for: indexPath)
                cell.configure(item)
                cell.updateTextLabel(isTitle: indexPath.row == 0)
                return cell
            }
        })
        applySnapshot(items: self.moreMenu.map({ $0.title }))
    }
    
    private func applySnapshot(items: [String]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(items, toSection: 0)
        datasource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func updateLongFormHeight(to newHeight: CGFloat) {
        dynamicLongFormHeight = .contentHeight(newHeight)
        panModalSetNeedsLayoutUpdate()
    }
    
    // MARK: - Public
    
    // MARK: - Actions
}

// MARK: - UITableViewDelegate
extension MoreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isMoreMenu {
            switch MoreMenu(rawValue: indexPath.row) {
            case .report:
                isMoreMenu = false
                updateLongFormHeight(to: Constants.topHeightWhenSubMenu + (CGFloat(self.reportList.count) * Constants.cellHeight) +
                                     Constants.bottomHeightWhenSubMenu)
                panModalTransition(to: .longForm)
                applySnapshot(items: self.reportList)
            default:
                break
            }
        } else {
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
}

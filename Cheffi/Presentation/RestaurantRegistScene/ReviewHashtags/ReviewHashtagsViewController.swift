//
//  ReviewHashtagsViewController.swift
//  Cheffi
//
//  Created by 김문옥 on 3/2/24.
//

import UIKit
import ComposableArchitecture

enum ReviewHashtagsActionType: Equatable {
    case posting(review: RegisterReviewRequest, imageDatas: [Data])
    case modification(TagsChangeRequest)
    
    var naviRightButtonKind: NavigationBarReducer.RightButtonKind {
        switch self {
        case .posting: return .posting
        case .modification: return .modification
        }
    }
}

class ReviewHashtagsViewController: UIViewController {
    private let reducer: ReviewHashtagsReducer
    private let reviewHashtagsAction: ReviewHashtagsActionType
    
    init(
        reducer: ReviewHashtagsReducer,
        reviewHashtagsAction: ReviewHashtagsActionType
    ) {
        self.reducer = reducer
        self.reviewHashtagsAction = reviewHashtagsAction
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addHostingController(
            view: ReviewHashtagsView(
                Store(initialState: ReviewHashtagsReducer.State(
                    reviewRequestInfo: reviewHashtagsAction,
                    navigationBarState: NavigationBarReducer.State(
                        title: "",
                        leftButtonKind: .back,
                        rightButtonKind: reviewHashtagsAction.naviRightButtonKind
                    )
                )) {
                    reducer._printChanges()
                }
            )
        )
    }
}

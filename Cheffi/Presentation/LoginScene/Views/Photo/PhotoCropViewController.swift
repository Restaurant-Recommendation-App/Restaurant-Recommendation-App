//
//  PhotoCropViewController.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/13.
//

import UIKit
import Combine

class PhotoCropViewController: UIViewController {
    static func instance<T: PhotoCropViewController>(viewModel: PhotoCropViewModelType, dismissCompltion: ((Data?) -> Void)?) -> T {
        let vc: T = .instance(storyboardName: .photoCrop)
        vc.viewModel = viewModel
        vc.dismissCompltion = dismissCompltion
        return vc
    }
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView!
    private var viewModel: PhotoCropViewModelType!
    private var cancellables: Set<AnyCancellable> = []
    var dismissCompltion: ((Data?) -> Void)?
    
    enum Constants {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
    }
    
    // MARK: - Private
    private func setupViews() {
        scrollView.delegate = self
        scrollView.maximumZoomScale = 3.0
        scrollView.minimumZoomScale = 1.0
    }
    
    private func bindViewModel() {
        viewModel.imageData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                self?.imageView.image = UIImage(data: data)
            }
            .store(in: &cancellables)
        viewModel.croppedImageData
            .sink { [weak self] imageData in
                self?.dismiss(animated: false, completion: {
                    self?.dismissCompltion?(imageData)
                })
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public
    
    // MARK: - Actions
    @IBAction private func didTapCancel(_ sender: UIButton) {
        self.dismissOne(amimated: true)
    }
    
    @IBAction private func didTapDone(_ sender: UIButton) {
        let centerPoint = CGPoint(x: contentView.bounds.width / 2, y: contentView.bounds.height / 2)
        let radius = contentView.bounds.width / 2
        let cropRect = CGRect(x: centerPoint.x - radius, y: centerPoint.y - radius, width: 2 * radius, height: 2 * radius)
        viewModel.cropImage(cropRect: cropRect)
    }
}

extension PhotoCropViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

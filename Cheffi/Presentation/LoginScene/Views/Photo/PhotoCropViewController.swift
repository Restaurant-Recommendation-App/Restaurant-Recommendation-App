//
//  PhotoCropViewController.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/13.
//

import UIKit
import Combine

class PhotoCropViewController: UIViewController {
    static func instance<T: PhotoCropViewController>(viewModel: PhotoCropViewModelType, dismissCompletion: ((Data?) -> Void)?) -> T {
        let vc: T = .instance(storyboardName: .photoCrop)
        vc.viewModel = viewModel
        vc.dismissCompletion = dismissCompletion
        let image = UIImage(data: viewModel.imageData)
        vc.imageView = UIImageView(image: image)
        vc.modalPresentationStyle = .overCurrentContext
        return vc
    }
    
    
    @IBOutlet private weak var contentView: UIView!
    private let scrollView: UIScrollView = UIScrollView()
    private var imageView: UIImageView!
    private var viewModel: PhotoCropViewModelType!
    private var circleView: CircleCropView?
    private var cancellables: Set<AnyCancellable> = []
    var dismissCompletion: ((Data?) -> Void)?
    
    private enum Constants {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let scrollFrame = self.contentView.bounds
        let imSize = imageView.image?.size ?? .zero
        guard let hole = circleView?.circleInset, hole.width > 0 else { return }
        let verticalRatio = hole.height / imSize.height
        let horizontalRatio = hole.width / imSize.width
        scrollView.minimumZoomScale = max(horizontalRatio, verticalRatio)
        scrollView.maximumZoomScale = 1
        scrollView.zoomScale = scrollView.minimumZoomScale
        let insetHeight = (scrollFrame.height - hole.height) / 2
        let insetWidth = (scrollFrame.width - hole.width) / 2
        scrollView.contentInset = UIEdgeInsets(top: insetHeight, left: insetWidth, bottom: insetHeight, right: insetWidth)
        centerImageViewInScrollView()
    }
    
    // MARK: - Private
    private func setupViews() {
        circleView = CircleCropView()
        contentView.addSubview(scrollView)
        contentView.addSubview(circleView!)
        scrollView.addSubview(imageView)
        scrollView.contentSize = imageView.image?.size ?? .zero
        scrollView.delegate = self
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        circleView?.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
        }
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            if let imageSize = imageView.image?.size {
                make.width.equalTo(imageSize.width)
                make.height.equalTo(imageSize.height)
            }
        }
    }
    
    private func bindViewModel() {
        viewModel.croppedImageData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] imageData in
                self?.dismissOne(amimated: false, {
                    self?.dismissCompletion?(imageData)
                })
            }
            .store(in: &cancellables)
    }
    
    private func centerImageViewInScrollView() {
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalMargin = max((scrollViewSize.height - imageViewSize.height) / 2, 0)
        let horizontalMargin = max((scrollViewSize.width - imageViewSize.width) / 2, 0)
        
        scrollView.contentInset = UIEdgeInsets(top: verticalMargin, left: horizontalMargin, bottom: verticalMargin, right: horizontalMargin)
    }
    
    // MARK: - Public
    
    // MARK: - Actions
    @IBAction private func didTapCancel(_ sender: UIButton) {
        self.dismissOne(amimated: true)
    }
    
    @IBAction private func didTapDone(_ sender: UIButton) {
        guard let rect = self.circleView?.circleInset else { return }
        let shift = rect.applying(CGAffineTransform(translationX: self.scrollView.contentOffset.x, y: self.scrollView.contentOffset.y))
        let scaled = shift.applying(CGAffineTransform(scaleX: 1.0 / self.scrollView.zoomScale, y: 1.0 / self.scrollView.zoomScale))
        let croppedImageData = self.imageView.image?.imageCropped(toRect: scaled).pngData()
        viewModel.setCroppedImageData(croppedImageData)
    }
}

extension PhotoCropViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

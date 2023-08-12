//
//  PhotoAlbumViewModel.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/11.
//

import Foundation
import Combine

protocol PhotoAlbumViewModelInput {
    func fetchPhotos()
    func toggleLatestItemsButton()
}

protocol PhotoAlbumViewModelOutput {
    var photoIdentifiersPublisher: Published<[String]>.Publisher { get }
    var isLatestItemsButtonSelectedPublisher: Published<Bool>.Publisher { get }
    var errorSubject: PassthroughSubject<String, Never> { get }
    var downloadingAssetsPublisher: Published<Set<String>>.Publisher { get }
}

typealias PhotoAlbumViewModelType = PhotoAlbumViewModelInput & PhotoAlbumViewModelOutput

class PhotoAlbumViewModel: PhotoAlbumViewModelType {
    private var photoUseCase: FetchPhotoUseCase
    private var cancellables: Set<AnyCancellable> = []
    @Published private(set) var photoIdentifiers: [String] = []
    @Published private(set) var isLatestItemsButtonSelected: Bool = false
    @Published private(set) var errorMessage: String = ""
    @Published private(set) var downloadingAssets: Set<String> = []
    
    // MARK: - Input
    func fetchPhotos() {
        photoUseCase.fetchPhotoIdentifiers()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    let errorMessage = "Error fetching photos: \(error)"
                    self?.errorSubject.send(errorMessage)
                }
            }, receiveValue: { [weak self] identifiers, downloadingIdentifiers in
                self?.photoIdentifiers = identifiers
                self?.downloadingAssets = downloadingIdentifiers
            })
            .store(in: &cancellables)
    }

    func toggleLatestItemsButton() {
        isLatestItemsButtonSelected.toggle()
    }
    
    // MARK: - Output
    var photoIdentifiersPublisher: Published<[String]>.Publisher { $photoIdentifiers }
    var isLatestItemsButtonSelectedPublisher: Published<Bool>.Publisher { $isLatestItemsButtonSelected }
    var errorSubject = PassthroughSubject<String, Never>()
    var downloadingAssetsPublisher: Published<Set<String>>.Publisher { $downloadingAssets }

    init(photoUseCase: FetchPhotoUseCase) {
        self.photoUseCase = photoUseCase
    }
}


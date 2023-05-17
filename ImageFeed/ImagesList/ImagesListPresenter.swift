//
//  ImageListPresenter.swift
//  ImageFeed
//
//  Created by Konstantin Zuykov on 18.05.2023.
//

import Foundation
import UIKit


protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get }
    func viewDidLoad()
    func makePhotoUrl(photoNumber: Int) -> URL?
    func makePhotoDate(row: Int) -> String
    func changeLike(cell: ImagesListCell, row: Int)
    
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    private var imagesListService = ImagesListService.shared
    private var imageListServiceObserver: NSObjectProtocol?
    
    func viewDidLoad() {
        if photos.isEmpty {
            self.imagesListService.fetchPhotosNextPage()
        }
        
        imageListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    guard let self = self else { return }
                    let oldCount = self.photos.count
                    let newCount = self.imagesListService.photos.count
                    self.photos = self.imagesListService.photos
                    if newCount != oldCount {
                        self.view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
                    }
                }
        
    }
    
    func makePhotoUrl(photoNumber: Int) -> URL? {
        let url = URL(string: photos[photoNumber].thumbImageURL)
        return url
    }
    
    func makePhotoDate(row: Int) -> String {
        guard let photosDate = photos[row].createdAt else { return "" }
        let dateString = dateFormatter.string(from: photosDate)
        return dateString
    }
    
    func changeLike(cell: ImagesListCell, row: Int) {
        let photo = photos[row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                cell.setIsLiked(isLiked: self.photos[row].isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print(error)
                view?.showErrorAlert()
            }
            
        }
    }
        
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    
}

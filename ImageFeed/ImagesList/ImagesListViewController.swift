//
//  ViewController.swift
//  ImageFeed
//
//  Created by Konstantin Zuykov on 21.12.2022.
//

import UIKit
import Kingfisher

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    func updateTableViewAnimated(oldCount: Int, newCount: Int)
    func showErrorAlert()
}

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
   
    
    // MARK: Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    var presenter: ImagesListPresenterProtocol?
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var imageListService = ImagesListService.shared
    private var imageListServiceObserver: NSObjectProtocol?

    
    // MARK: View did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
//        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
//
//        imageListServiceObserver = NotificationCenter.default
//            .addObserver(
//                forName: ImagesListService.didChangeNotification,
//                object: nil,
//                queue: .main) { [weak self] _ in
//                    guard let self = self else { return }
//                    self.updateTableViewAnimated()
//                }
//        imageListService.fetchPhotosNextPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as? SingleImageViewController
            if let indexPath = sender as? IndexPath {
                let urlImage = URL(string: presenter?.photos[indexPath.row].fullImageURL ?? "")
                viewController?.fullImageURL = urlImage
            } else {
                super.prepare(for: segue, sender: sender)
            }
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter = presenter else { return 0 }
        return presenter.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        imageListCell.delegate = self
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        let photos = imageListService.photos
        if indexPath.row + 1 == photos.count {
            imageListService.fetchPhotosNextPage()
        }
    }
    
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        tableView.performBatchUpdates {
            let indexPaths = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: 0)
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
    
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with IndexPath: IndexPath) {
        
        guard let url = presenter?.makePhotoUrl(photoNumber: IndexPath.row) else { return }
        let placeholder = UIImage(named: "Stub")
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: url, placeholder: placeholder) { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [IndexPath], with: .automatic)
            cell.cellImage.kf.indicatorType = .none
        }
        
        let date = presenter?.makePhotoDate(row: IndexPath.row)
        cell.dateLabel.text = date
        
        guard let photoIsLiked = presenter?.photos[IndexPath.row].isLiked else { return }
        cell.setIsLiked(isLiked: photoIsLiked)
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter?.changeLike(cell: cell, row: indexPath.row)
    }
    
    internal func showErrorAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось поставить лайк",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(
            title: "Ок",
            style: .default))
        self.present(alert, animated: true)
        
    }
}


extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
}



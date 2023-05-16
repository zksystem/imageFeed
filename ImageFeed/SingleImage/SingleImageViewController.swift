//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Konstantin Zuykov on 29.01.2023.
//

import UIKit

final class SingleImageViewController : UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    @IBAction private func didShareButtonTap(_ sender: Any) {
        guard let image = imageView.image else { return }
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Variables
    var fullImageURL: URL!
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    func showImage() {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: fullImageURL) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                self.showErrorAlert()
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    // error alert
    
    private func showErrorAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Попробовать ещё раз?",
            preferredStyle: .alert
        )
        
        let dismissAction = UIAlertAction(title: "Нет", style: .default ) { _ in
            alert.dismiss(animated: true)
        }
        
        let retryAction = UIAlertAction(title: "Попробовать еше раз?", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.showImage()
        }
        
        alert.addAction(dismissAction)
        alert.addAction(retryAction)
        self.present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        showImage()
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}

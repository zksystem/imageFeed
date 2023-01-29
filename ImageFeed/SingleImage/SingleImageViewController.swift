//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Konstantin Zuykov on 29.01.2023.
//

import UIKit


final class SingleImageViewController : UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}

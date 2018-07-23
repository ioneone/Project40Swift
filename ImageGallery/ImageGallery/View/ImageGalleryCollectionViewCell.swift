//
//  ImageGalleryCollectionViewCell.swift
//  ImageGallery
//
//  Created by Junhong Wang on 7/14/18.
//  Copyright © 2018 ioneone. All rights reserved.
//

import UIKit

class ImageGalleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var label: UILabel!
    
    func fetchImage(with url: URL) {
        imageView.image = nil
        activityIndicator.isHidden = false
        label.isHidden = false
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        self?.imageView.image = image
                        
                    }
                    else {
                        self?.imageView.image = #imageLiteral(resourceName: "invalid-url")
                    }
                    
                    self?.activityIndicator.isHidden = true
                    self?.label.isHidden = true
                }
                
            }
            else {
                DispatchQueue.main.async {
                    self?.imageView.image = #imageLiteral(resourceName: "invalid-url")
                    self?.activityIndicator.isHidden = true
                    self?.label.isHidden = true
                }
            }
        }
        
    }
    
    
    
    
}

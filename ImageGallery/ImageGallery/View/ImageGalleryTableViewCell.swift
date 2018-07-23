//
//  ImageGalleryTableViewCell.swift
//  ImageGallery
//
//  Created by Junhong Wang on 7/21/18.
//  Copyright © 2018 ioneone. All rights reserved.
//

import UIKit

class ImageGalleryTableViewCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.isEnabled = false
    }

}

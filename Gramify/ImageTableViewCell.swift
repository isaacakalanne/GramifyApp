//
//  ImageTableViewCell.swift
//  Gramify
//
//  Created by Isaac Akalanne on 02/02/2020.
//  Copyright © 2020 Believe And Succeed Apps. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var uploadDateLabel: UILabel!
    @IBOutlet weak var uploadTimeLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected == true {
            UIView.animate(withDuration: 0.4) {
                self.showExtraMetadata()
            }
        } else {
            UIView.animate(withDuration: 0.4) {
                self.showDefaultMetadata()
            }
        }
    }
    
    func showExtraMetadata() {
        titleLabel.alpha = 0
        widthLabel.alpha = 0
        heightLabel.alpha = 0
        uploadDateLabel.alpha = 1
        uploadTimeLabel.alpha = 1
        viewsLabel.alpha = 1
        editButton.alpha = 1
        moveViewToTheRight(imagePreview)
        moveViewToTheRight(editButton)
    }
    
    func moveViewToTheRight(_ view : UIView) {
        view.frame = CGRect(x: UIScreen.main.bounds.size.width - view.frame.size.width, y: 0, width: view.frame.size.width, height: view.frame.size.height)
    }
    
    func moveViewToTheLeft(_ view : UIView) {
        view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
    }
    
    func moveImagePreviewToRight() {
        imagePreview.frame = CGRect(x: UIScreen.main.bounds.size.width - imagePreview.frame.size.width, y: 0, width: imagePreview.frame.size.width, height: imagePreview.frame.size.height)
        editButton.frame = CGRect(x: UIScreen.main.bounds.size.width - imagePreview.frame.size.width, y: 0, width: imagePreview.frame.size.width, height: imagePreview.frame.size.height)
    }
    
    func showDefaultMetadata() {
        titleLabel.alpha = 1
        widthLabel.alpha = 1
        heightLabel.alpha = 1
        uploadDateLabel.alpha = 0
        uploadTimeLabel.alpha = 0
        viewsLabel.alpha = 0
        editButton.alpha = 0
        moveViewToTheLeft(imagePreview)
        moveViewToTheLeft(editButton)
    }
    
    func moveImagePreviewToLeft() {
        imagePreview.frame = CGRect(x: 0, y: 0, width: imagePreview.frame.size.width, height: imagePreview.frame.size.height)
        editButton.frame = CGRect(x: 0, y: 0, width: imagePreview.frame.size.width, height: imagePreview.frame.size.height)
    }

}

//
//  TemplateCollectionViewCell.swift
//  Shop101
//
//  Created by sanket on 20/10/19.
//  Copyright © 2019 sanket. All rights reserved.
//

import UIKit

class TemplateCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var fullImageContainerView: UIView!
    @IBOutlet weak var twoImageContainerView: UIView!
    @IBOutlet weak var threeImageContainerView: UIView!
    
    //First Container ImageView
    @IBOutlet weak var fullImageView: UIImageView!
    
    //Second Container ImageView
    @IBOutlet weak var firstImageViewContainer2: UIImageView!
    @IBOutlet weak var secondImageViewContainer2: UIImageView!
    
    //Second Container ImageView
    @IBOutlet weak var firstImageViewContainer3: UIImageView!
    @IBOutlet weak var secondImageViewContainer3: UIImageView!
    @IBOutlet weak var thirdImageViewContainer3: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func populateCellWithData(data : ObjectModel) {
        self.setImageToImageView(data: data)
        if let title = data.title {
            self.titleLabel.text = title
        } else {
            self.titleLabel.text = data.catalogueName
        }
        
    }
    
    func setImageToImageView(data : ObjectModel) {
        if data.templateId == 1 || data.imageElements?.count == 1 {
            self.twoImageContainerView.isHidden = true
            self.threeImageContainerView.isHidden = true
            
            var imageUrl = ""
            if data.templateId == 1 {
                imageUrl = data.catalogueCoverUrl ?? ""
            } else {
                imageUrl = data.imageElements?.first?.imageUrl ?? ""
            }
            
            let url = URL(string: imageUrl)

            fullImageView.sd_setImage(with: url, completed: nil)

        } else if data.imageElements?.count == 2 {
            self.fullImageContainerView.isHidden = true
            self.threeImageContainerView.isHidden = true

        } else if data.imageElements?.count == 3 {
            self.fullImageContainerView.isHidden = true
            self.twoImageContainerView.isHidden = true

        }
    }

}

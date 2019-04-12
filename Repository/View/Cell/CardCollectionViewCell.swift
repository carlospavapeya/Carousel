//
//  CardCollectionViewCell.swift
//  Repository
//
//  Created by Carlos Pava on 4/9/19.
//  Copyright © 2019 Carlos Pava. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(card:CardModel){
        self.cardImageView.image = UIImage(named:card.imageUrl)
        self.cardImageView.layer.cornerRadius = 10
    }
}

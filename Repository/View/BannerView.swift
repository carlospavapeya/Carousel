//
//  BannerView.swift
//  Repository
//
//  Created by Carlos Pava on 4/9/19.
//  Copyright © 2019 Carlos Pava. All rights reserved.
//

import UIKit

class BannerView: UIView {
    
    var height:CGFloat = 150
    var cards:[CardModel]?{
        didSet{
            self.setupViews()
        }
    }
    
    var carouselView:CarouselView!
    var cardImageView:UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.colorBase()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        if let cards = self.cards, cards.count > 1{
            self.setupCarousel()
        }else{
            self.setCardImageView()
        }
    }
    
    internal func setupCarousel(){
        self.carouselView = CarouselView(frame: .zero)
        self.carouselView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(self.carouselView)
        setConstraintToCarousel()
        self.carouselView.setData(cards: self.cards!)
    }
    
    internal func setCardImageView(){
        self.cardImageView = UIImageView(frame: .zero)
        self.cardImageView?.translatesAutoresizingMaskIntoConstraints = false
        
        guard let card = cards?.first else {
            return
        }
        
        self.cardImageView?.image = UIImage(named: card.imageUrl)
        addSubview(self.cardImageView!)
        setConstraintsToCardImageView()
    }
    
    func setConstraintsToCardImageView(){
        let constraints : [NSLayoutConstraint] = [
            cardImageView!.topAnchor.constraint(equalTo: topAnchor),
            cardImageView!.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            cardImageView!.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            cardImageView!.heightAnchor.constraint(equalToConstant: height),
            cardImageView!.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        layoutIfNeeded()
    }
    
    func setConstraintToCarousel(){
        let constraints : [NSLayoutConstraint] = [
            carouselView!.topAnchor.constraint(equalTo: topAnchor),
            carouselView!.leadingAnchor.constraint(equalTo: leadingAnchor),
            carouselView!.trailingAnchor.constraint(equalTo: trailingAnchor),
            carouselView!.bottomAnchor.constraint(equalTo: bottomAnchor),
            ]
        NSLayoutConstraint.activate(constraints)
        
        layoutIfNeeded()
    }
}

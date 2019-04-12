//
//  ViewController.swift
//  Repository
//
//  Created by Carlos Pava on 4/9/19.
//  Copyright © 2019 Carlos Pava. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var bannerView:BannerView!
    var manager:Manager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = Manager()
        self.setBannerView()
        self.setConstraints()
        
        self.setData()
    }

    func setBannerView(){
        self.bannerView = BannerView(frame: .zero)
        self.view.addSubview(self.bannerView)
    }
    
    func setConstraints(){
        let carouselViewConstraints : [NSLayoutConstraint] = [
            self.bannerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64),
            self.bannerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.bannerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.bannerView.heightAnchor.constraint(equalToConstant: 150)
        ]
        NSLayoutConstraint.activate(carouselViewConstraints)
        
        self.view.layoutIfNeeded()
    }
    
    func setData(){
        self.bannerView.cards = manager.getCards()
    }
    
}


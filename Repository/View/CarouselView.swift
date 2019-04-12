//
//  CarouselView.swift
//  Repository
//
//  Created by Carlos Pava on 4/9/19.
//  Copyright © 2019 Carlos Pava. All rights reserved.
//

import UIKit

class CarouselView: UIView{
    
    var carousel:CarouselCollectionView!
    var collectionView:UICollectionView?
    var pageControl:UIPageControl?
    var source:Source!
    let height = 150
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.source = Source()
        self.setupViews()
        self.setConstraints()
        
        backgroundColor = UIColor.colorBase()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func setupViews(){
        self.addCarousel()
        self.setPageControl()
        self.registerCell()
    }
    
    func setData(cards:[CardModel]){
        self.source.setData(cards: cards)
        self.carousel.reloadData()
        self.pageControl?.numberOfPages = cards.count
    }
    
    func addCarousel(){
        self.carousel = CarouselCollectionView(withFrame: .zero, andInset: 20)
        self.carousel.translatesAutoresizingMaskIntoConstraints = false
        self.carousel.delegate = self.source
        self.carousel.dataSource = self.source
        self.carousel.delegateCorousel = self
        self.carousel.backgroundColor = UIColor.clear
        
        addSubview(self.carousel)
    }
    

    
    internal func registerCell(){
        let nib = UINib(nibName: "CardCollectionViewCell", bundle: nil)
        self.carousel.register(nib, forCellWithReuseIdentifier: "cardCell")
    }
    
    internal func setPageControl(){
        self.pageControl = UIPageControl(frame: .zero)
        self.pageControl?.translatesAutoresizingMaskIntoConstraints = false
        self.pageControl?.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl?.currentPageIndicatorTintColor = UIColor.red
        addSubview(self.pageControl!)
    }
    
    internal func setConstraints(){
        let pageControlConstraints:[NSLayoutConstraint] = [
            pageControl!.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            pageControl!.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant:-8),
            pageControl!.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        let collectionViewConstraints : [NSLayoutConstraint] = [
            self.carousel!.topAnchor.constraint(equalTo: self.topAnchor),
            self.carousel!.heightAnchor.constraint(equalToConstant: CGFloat(height)),
            self.carousel!.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            self.carousel!.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            self.carousel!.bottomAnchor.constraint(equalTo: self.pageControl!.topAnchor, constant:-8)
        ]
        
        NSLayoutConstraint.activate(pageControlConstraints)
        NSLayoutConstraint.activate(collectionViewConstraints)
        
        layoutIfNeeded()
    }
}

extension CarouselView : CarouselCollectionViewProtocol{
    func updatePage(page: Int) {
        self.pageControl?.currentPage = page
    }
}

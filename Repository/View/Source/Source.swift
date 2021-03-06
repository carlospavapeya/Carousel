//
//  Source.swift
//  Repository
//
//  Created by Carlos Pava on 4/9/19.
//  Copyright © 2019 Carlos Pava. All rights reserved.
//

import UIKit

protocol SourceProtocol {
    func selectedCard(card:CardModel)
}

class Source: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let idCell = "cardCell"
    var cards = [CardModel]()
    var delegate:SourceProtocol?
    func setData(cards:[CardModel]){
        self.cards = cards
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idCell, for: indexPath) as! CardCollectionViewCell
        cell.setData(card: cards[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.delegate?.selectedCard(card: cards[indexPath.row])
    }
}

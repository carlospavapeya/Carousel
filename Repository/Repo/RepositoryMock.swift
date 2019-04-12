//
//  RepositoryMock.swift
//  Repository
//
//  Created by Carlos Pava on 4/9/19.
//  Copyright © 2019 Carlos Pava. All rights reserved.
//

import Foundation

class RepositoryMock: RepositoryProtocol {
    func getCards() -> [CardModel]? {
        let cards:[CardModel] = [
            CardModel(name:"banner1",imageUrl:"banner1"),
            CardModel(name:"banner2",imageUrl:"banner2"),
            CardModel(name:"banner3",imageUrl:"banner3"),
            CardModel(name:"banner4",imageUrl:"banner4")
        ]
        return cards
    }
}

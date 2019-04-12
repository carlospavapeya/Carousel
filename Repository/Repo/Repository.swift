//
//  Repository.swift
//  Repository
//
//  Created by Carlos Pava on 4/9/19.
//  Copyright © 2019 Carlos Pava. All rights reserved.
//

import Foundation

class Repository: RepositoryProtocol {
    func getCards() -> [CardModel] {
        let cards:[CardModel] = [
            CardModel(name:"banner1",imageUrl:"banner1")
        ]
        return cards
    }
}

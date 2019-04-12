//
//  RepositoryProtocol.swift
//  Repository
//
//  Created by Carlos Pava on 4/9/19.
//  Copyright © 2019 Carlos Pava. All rights reserved.
//

import Foundation

protocol RepositoryProtocol {
    func getCards() -> [CardModel]?
}

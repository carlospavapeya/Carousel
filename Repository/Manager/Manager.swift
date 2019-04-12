//
//  Manager.swift
//  Repository
//
//  Created by Carlos Pava on 4/9/19.
//  Copyright © 2019 Carlos Pava. All rights reserved.
//

import Foundation

class Manager: BaseManager {
    
    var repository:RepositoryProtocol!
    
    override init() {
        super.init()
    }
    
    override func setup() {
        if enviroment{
            self.repository = Repository()
        }else{
            self.repository = RepositoryMock()
        }
    }
    
    func getCards() -> [CardModel]?{
        return self.repository.getCards()
    }
}

//
//  BaseManager.swift
//  Repository
//
//  Created by Carlos Pava on 4/9/19.
//  Copyright © 2019 Carlos Pava. All rights reserved.
//

import Foundation

class BaseManager{
    
    var enviroment:Bool!
    
    init() {
        #if MOCK
        self.enviroment = false
        #else
        self.enviroment = true
        #endif
        
        self.setup()
    }
    
    func setup(){
        print("Setup Enviroment")
    }
}

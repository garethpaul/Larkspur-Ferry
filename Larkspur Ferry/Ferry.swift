//
//  file: Ferry.swift
//  Larkspur Ferry
//
//  Created by Gareth Jones on 11/23/15.
//  Copyright © 2015 gpj. All rights reserved.
//

import Foundation

class Ferry {
    
    var arrive: String
    var depart: String
    var from: String
    var to: String
    
    init(arrive: String, depart: String, from: String, to: String) {
        self.arrive = arrive
        self.depart = depart
        self.from = from
        self.to = to
    }
}

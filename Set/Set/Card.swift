//
//  Card.swift
//  Set
//
//  Created by Junhong Wang on 6/28/18.
//  Copyright © 2018 ioneone. All rights reserved.
//

import Foundation

struct Card: Equatable {
    
    let symbolIdentifier : Identifier
    let shadingIdentifier : Identifier
    let countIdentifier : Identifier
    let colorIdentifier : Identifier
    
    enum Identifier: Int {
        case one = 1
        case two = 2
        case three = 3
        
        static var allIdentifiers: [Identifier] {
            return [.one, .two, .three]
        }
    }
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.symbolIdentifier == rhs.symbolIdentifier && lhs.shadingIdentifier == rhs.shadingIdentifier && lhs.countIdentifier == rhs.countIdentifier && lhs.colorIdentifier == rhs.colorIdentifier
    }
    
}

//
//  Concentration.swift
//  Concentration
//
//  Created by Junhong Wang on 6/28/18.
//  Copyright © 2018 ioneone. All rights reserved.
//

import Foundation

struct Concentration {
    
    private(set) var cards = [Card]()
    
    private(set) var previouslySeenCardIndices = [Int]()
    
    private(set) var score = 0
    
    private(set) var flipCount = 0
    
    private var previousTime = Date()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            var foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp {
                    if foundIndex == nil {
                        foundIndex = index
                    }
                    else {
                        return nil
                    }
                }
            }
            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard {
                // one card was faceup
                
                let currentTime = Date()
                let elapsedTime = Int(currentTime.timeIntervalSince(previousTime))
                previousTime = currentTime
                
                if matchIndex != index {
                    if cards[matchIndex].identifier == cards[index].identifier {
                        cards[matchIndex].isMatched = true
                        cards[index].isMatched = true
                        score += 2 * (10 / elapsedTime)
                    }
                    else {
                        score -= (previouslySeenCardIndices.contains(matchIndex)) ? elapsedTime : 0
                        score -= (previouslySeenCardIndices.contains(index)) ? elapsedTime : 0
                    }
                    
                    
                }
                else {
                    // choose same card twice
                    score -= (previouslySeenCardIndices.contains(index)) ? elapsedTime : 0
                }
                
                if !previouslySeenCardIndices.contains(index) {
                    previouslySeenCardIndices.append(index)
                }
                
                if !previouslySeenCardIndices.contains(matchIndex) {
                    previouslySeenCardIndices.append(matchIndex)
                }
                
                cards[index].isFaceUp = !cards[index].isFaceUp
                
            }
            else {
                // no cards were faceup or two cards were faceup
                indexOfOneAndOnlyFaceUpCard = index
            }
            
            
            flipCount += 1
            
        }
        
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): you must have at least one pair of cards")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        
        // TODO: Shuffle the cards
        cards.shuffle()
    }
    
}

extension MutableCollection {
    mutating func shuffle() {
        for i in 0..<self.count {
            let rand = i + (self.count - i).arc4random
            swapAt(index(startIndex, offsetBy: i), index(startIndex, offsetBy: rand))
        }
    }
}

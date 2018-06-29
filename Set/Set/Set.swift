//
//  Set.swift
//  Set
//
//  Created by Junhong Wang on 6/28/18.
//  Copyright © 2018 ioneone. All rights reserved.
//

import Foundation

struct Set {
    
    private(set) var deck = [Card]()
    private(set) var cards = [Card]()
    private(set) var selectedIndices = [Int]()
    
    private(set) var score = 0
    
    mutating func selectCard(at index: Int) {
        if selectedIndices.count == 2, !selectedIndices.contains(index) {
            selectedIndices.append(index)
            // TODO: check if matched
            if isMatched() {
                score += 1
                removeMatchedCards()
            }
            
            selectedIndices.removeAll()
            
        }
        else {
            if selectedIndices.contains(index) {
                selectedIndices.remove(at: selectedIndices.index(of: index)!)
                
            }
            else {
                selectedIndices.append(index)
            }
        }
        
        
    }
    
    mutating private func removeMatchedCards() {
        selectedIndices.sort()
        for index in selectedIndices.reversed() {
            cards.remove(at: index)
        }
    }
    
    mutating func dealThreeMoreCards() {
        for _ in 1...3 {
            if !deck.isEmpty, cards.count < 24 {
                cards.append(deck.removeFirst())
            }
        }
    }
    
    private func isMatched() -> Bool {
        assert(selectedIndices.count == 3, "Set.isMatched(): you must select three cards to check match")
        
        let selectedCards = [cards[selectedIndices[0]], cards[selectedIndices[1]], cards[selectedIndices[2]]]
        
        return isNumberMatched(for: selectedCards) && isSymbolMatched(for: selectedCards) && isShadingMatched(for: selectedCards) && isColorMatched(for: selectedCards)
        
    }
    
    private func isNumberMatched(for cards: [Card]) -> Bool {
        assert(cards.count == 3, "Set.isNumberMatched(for cards: \(cards.description)): you must select three cards to check match")
        return isSameObject(obj1: cards[0].numberIdentifier, obj2: cards[1].numberIdentifier, obj3: cards[2].numberIdentifier) || isDifferentObject(obj1: cards[0].numberIdentifier, obj2: cards[1].numberIdentifier, obj3: cards[2].numberIdentifier)
        
    }
    
    private func isSymbolMatched(for cards: [Card]) -> Bool {
        assert(cards.count == 3, "Set.isSymbolMatched(for cards: \(cards.description)): you must select three cards to check match")
        return isSameObject(obj1: cards[0].symbolIdentifier, obj2: cards[1].symbolIdentifier, obj3: cards[2].symbolIdentifier) || isDifferentObject(obj1: cards[0].symbolIdentifier, obj2: cards[1].symbolIdentifier, obj3: cards[2].symbolIdentifier)
    }
    
    private func isShadingMatched(for cards: [Card]) -> Bool {
        assert(cards.count == 3, "Set.isShadingMatched(for cards: \(cards.description)): you must select three cards to check match")
        return isSameObject(obj1: cards[0].shadingIdentifier, obj2: cards[1].shadingIdentifier, obj3: cards[2].shadingIdentifier) || isDifferentObject(obj1: cards[0].shadingIdentifier, obj2: cards[1].shadingIdentifier, obj3: cards[2].shadingIdentifier)
    }
    
    private func isColorMatched(for cards: [Card]) -> Bool {
        assert(cards.count == 3, "Set.isColorMatched(for cards: \(cards.description)): you must select three cards to check match")
        return isSameObject(obj1: cards[0].colorIdentifier, obj2: cards[1].colorIdentifier, obj3: cards[2].colorIdentifier) || isDifferentObject(obj1: cards[0].colorIdentifier, obj2: cards[1].colorIdentifier, obj3: cards[2].colorIdentifier)
    }
    
    private func isSameObject<T: Equatable>(obj1: T, obj2: T, obj3: T) -> Bool {
        return obj1 == obj2 && obj2 == obj3
    }
    
    private func isDifferentObject<T: Equatable>(obj1: T, obj2: T, obj3: T) -> Bool {
        return obj1 != obj2 && obj2 != obj3 && obj3 != obj1
    }


    init(numberOfCards: Int) {
        
        for i in 1...3 {
            for j in 1...3 {
                for k in 1...3 {
                    for l in 1...3 {
                        deck.append(Card(symbolIdentifier: i, shadingIdentifier: j, numberIdentifier: k, colorIdentifier: l))
                    }
                }
            }
        }
        
        // TODO: shuffle the deck
        deck.shuffle()
        
        assert(numberOfCards <= deck.count, "Set.init(numberOfCards: \(numberOfCards)): numberOfCards should be less or equal to number of cards in the deck")
        
        for _ in 0..<numberOfCards {
            cards.append(deck.removeFirst())
        }
        
        
    }



}

extension MutableCollection {
    mutating func shuffle() {
        for i in 0..<self.count {
            let rand = i + (self.count - i).arc4Random
            swapAt(index(startIndex, offsetBy: i), index(startIndex, offsetBy: rand))
        }
    }
}








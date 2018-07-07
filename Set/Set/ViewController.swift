//
//  ViewController.swift
//  Set
//
//  Created by Junhong Wang on 6/28/18.
//  Copyright © 2018 ioneone. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private(set) var game = Set(numberOfCards: Constant.startingNumberOfCards)
    
    private var symbols = [Card.Identifier:SetButton.Shape]()
    private var colors = [Card.Identifier:UIColor]()
    private var shades = [Card.Identifier:SetButton.Shading]()
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var buttonContainerView: SetButtonsContainerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        buttonContainerView.deckButton.addTarget(self, action: #selector(dealThreeMoreCards(_:)), for: .touchUpInside)
        
        registerCardIdentifiers()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateViewFromModel()
    }
    
    private func registerCardIdentifiers() {
        var symbolChoices = SetButton.Shape.allShapes
        var colorChoices = [UIColor.green, .red, .purple]
        var shadeChoices = SetButton.Shading.allShadings
        
        for identifier in Card.Identifier.allIdentifiers {
            symbols[identifier] = symbolChoices.remove(at: symbolChoices.count.arc4random)
            colors[identifier] = colorChoices.remove(at: colorChoices.count.arc4random)
            shades[identifier] = shadeChoices.remove(at: shadeChoices.count.arc4random)
        }
        
    }
    
    @objc func cardButtonTapped(_ sender: SetButton) {

        guard let index = buttonContainerView.buttons.index(of: sender) else { return }
        game.selectCard(at: index)
        updateViewFromModel()
        
        
        
    }
    
    @objc func dealThreeMoreCards(_ sender: UIButton?) {
        game.dealThreeMoreCards()
        updateViewFromModel()
    }
    
    @objc private func shuffleCards() {
        game.shuffleCards()
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        
        updateScoreLabelFromModel()
        
        updateDealCardsButton()
        
        updateCardButtonsFromModel()
        
    }
    
    private func updateDealCardsButton() {
        if game.deck.isEmpty {
            buttonContainerView.deckButton.isHidden = true
        }
    }
    
    
    
    private func updateScoreLabelFromModel() {
         scoreLabel.text = "Score: \(game.score)"
    }
    
    private func updateCardButtonsFromModel() {
        for index in buttonContainerView.buttons.indices {
            buttonContainerView.buttons[index].isSelected = game.selectedIndices.contains(index)
        }
        
        if buttonContainerView.buttons.count < game.cards.count {
            for _ in 1...game.cards.count - buttonContainerView.buttons.count {
                let button = SetButton()
                let index = buttonContainerView.buttons.count
                let card = game.cards[index]
                            
                button.color = colors[card.colorIdentifier]
                button.shading = shades[card.shadingIdentifier]
                button.shape = symbols[card.symbolIdentifier]
                button.count = card.countIdentifier.rawValue
                
                button.addTarget(self, action: #selector(cardButtonTapped(_:)), for: .touchUpInside)
                buttonContainerView.addButton(button)
            }
        } else if buttonContainerView.buttons.count == game.cards.count {
            return
        } else {
            guard let indices = game.previouslyRemovedCardIndices else { return }
            for index in indices.sorted().reversed() {
                buttonContainerView.removeButton(at: index)
            }
            assert(buttonContainerView.buttons.count == game.cards.count, "ViewController.updateCardButtonsCountFromModel(): buttonContainerView.buttons.count (\(buttonContainerView.buttons.count)) is not equal to game.cards.count (\(game.cards.count))")
            
        }
        
        buttonContainerView.updateButtonPositions()
        
        
    }

}

extension ViewController {
    
    private struct Constant {
        static let numberOfColumnsOfButtons: Int = 4
        static let buttonSpacing: CGFloat = 8.0
        static let startingNumberOfCards: Int = 12
    }
    
    var numberOfRowsOfButtons: Int {
        return 1 + (game.cards.count - 1) / Constant.numberOfColumnsOfButtons
    }
    
    var buttonWidth: CGFloat {
        return (buttonContainerView.bounds.size.width - CGFloat(Constant.numberOfColumnsOfButtons - 1) * Constant.buttonSpacing) / CGFloat(Constant.numberOfColumnsOfButtons)
    }
    
    var buttonHeight: CGFloat {
        return (buttonContainerView.bounds.size.height - CGFloat(numberOfRowsOfButtons - 1) * Constant.buttonSpacing) / CGFloat(numberOfRowsOfButtons)
    }
    
    
    
    
    
}

extension Int {
    
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
        
    }
    
}


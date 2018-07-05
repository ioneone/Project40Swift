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
    
    private var symbolChoices = SetButton.Shape.allShapes
    private var colorChoices = [UIColor.green, .red, .purple]
    private var shadeChoices = SetButton.Shading.allShadings
    
    private var cardButtons: [SetButton] = []
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var buttonContainerView: SetButtonsContainerView!
    
    lazy var swipeDownGestureRecognizer: UISwipeGestureRecognizer = {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(dealThreeMoreCards(_:)))
        swipeDown.direction = .down
        return swipeDown
    }()
    
    lazy var rotationGestureRecognizer: UIRotationGestureRecognizer = {
        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(shuffleCards))
        return rotation
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateViewFromModel()
        
        view.addGestureRecognizer(swipeDownGestureRecognizer)
        view.addGestureRecognizer(rotationGestureRecognizer)
        
    }
    
    @objc func cardButtonTapped(_ sender: SetButton) {

        guard let index = cardButtons.index(of: sender) else { return }
        game.selectCard(at: index)
        updateViewFromModel()
        
        if game.deck.isEmpty {
            sender.isUserInteractionEnabled = false
            sender.tintColor = .gray
        }
        
    }
    
    @IBAction func dealThreeMoreCards(_ sender: Any) {
        game.dealThreeMoreCards()
        updateViewFromModel()
    }
    
    @objc private func shuffleCards() {
        game.shuffleCards()
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        
        updateScoreLabelFromModel()
        
        updateCardButtonsCountFromModel()
        
        for index in cardButtons.indices {
            
            let button = cardButtons[index]
            let card = game.cards[index]
            
            if colors[card.colorIdentifier] == nil {
                colors[card.colorIdentifier] = colorChoices.remove(at: colorChoices.count.arc4Random)
            }
            
            if shades[card.shadingIdentifier] == nil {
                shades[card.shadingIdentifier] = shadeChoices.remove(at: shadeChoices.count.arc4Random)
            }
            
            if symbols[card.symbolIdentifier] == nil {
                symbols[card.symbolIdentifier] = symbolChoices.remove(at: shadeChoices.count.arc4Random)
            }
            
            button.color = colors[card.colorIdentifier]
            button.shading = shades[card.shadingIdentifier]
            button.shape = symbols[card.symbolIdentifier]
            button.count = card.countIdentifier.rawValue
            button.isSelected = game.selectedIndices.contains(index)
            
       
            
            
        }
        
        buttonContainerView.buttons = cardButtons
        
        
    }
    
    
    
    private func updateScoreLabelFromModel() {
         scoreLabel.text = "Score: \(game.score)"
    }
    
    private func updateCardButtonsCountFromModel() {
        if cardButtons.count < game.cards.count {
            for _ in 1...game.cards.count - cardButtons.count {
                let button = SetButton()
                button.addTarget(self, action: #selector(cardButtonTapped(_:)), for: .touchUpInside)
                cardButtons.append(button)
            }
        } else if cardButtons.count == game.cards.count {
            return
        } else {
            for _ in 1...cardButtons.count - game.cards.count {
                cardButtons.removeLast()
            }
        }
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
    
    var arc4Random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
        
    }
    
}


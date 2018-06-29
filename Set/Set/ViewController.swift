//
//  ViewController.swift
//  Set
//
//  Created by Junhong Wang on 6/28/18.
//  Copyright © 2018 ioneone. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private(set) lazy var game = Set(numberOfCards: cardButtons.count / 2)
    
    private var symbols = [Int:String]()
    private var colors = [Int:UIColor]()
    private var shades = [Int:CGFloat]()
    
    private var symbolChoices = "▲●■"
    private var colorChoices = [UIColor.black, .red, .blue]
    private var shadeChoices: [CGFloat] = [1, 0.5, 0.15]
    
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateViewFromModel()
    }
    
    @IBAction private func cardButtonTapped(_ sender: UIButton) {
        guard let index = cardButtons.index(of: sender) else { return }
        game.selectCard(at: index)
        updateViewFromModel()
    }
    
    @IBAction func dealThreeMoreCardsButtonTapped(_ sender: UIButton) {
        game.dealThreeMoreCards()
        updateViewFromModel()
    }
    
    
    private func updateViewFromModel() {
        
        scoreLabel.text = "Score: \(game.score)"
        
        for index in cardButtons.indices {
            let button = cardButtons[index]
            if index < game.cards.count {
                button.isUserInteractionEnabled = true
                
                var attributes = [NSAttributedStringKey:Any]()
                let card = game.cards[index]
                var symbol = ""
                
                if colors[card.colorIdentifier] == nil {
                    colors[card.colorIdentifier] = colorChoices.remove(at: colorChoices.count.arc4Random)
                }
                
                if shades[card.shadingIdentifier] == nil {
                    shades[card.shadingIdentifier] = shadeChoices.remove(at: shadeChoices.count.arc4Random)
                }
                
                if symbols[card.symbolIdentifier] == nil {
                    symbols[card.symbolIdentifier] = String(symbolChoices.remove(at: symbolChoices.index(symbolChoices.startIndex, offsetBy: symbolChoices.count.arc4Random)))
                }
                
                
                attributes[.strokeColor] = colors[card.colorIdentifier]
                attributes[.foregroundColor] = colors[card.colorIdentifier]!.withAlphaComponent(shades[card.shadingIdentifier]!)
                
                symbol = symbols[card.symbolIdentifier]!
                var string = ""
                for _ in 0..<card.numberIdentifier {
                    string += symbol
                }
                
                button.setAttributedTitle(NSAttributedString(string: string, attributes: attributes), for: .normal)
                
                button.layer.cornerRadius = 8.0
                button.backgroundColor = .white
                
                if game.selectedIndices.contains(index) {
                    button.layer.borderWidth = 3.0
                    button.layer.borderColor = UIColor.blue.cgColor
                } else {
                    button.layer.borderWidth = 0
                    button.layer.borderColor = nil
                }
                
                
                
            }
            else {
                button.isUserInteractionEnabled = false
                button.setAttributedTitle(nil, for: .normal)
                button.setTitle(nil, for: .normal)
                button.backgroundColor = nil
                button.layer.borderWidth = 0
                button.layer.borderColor = nil
            }
            
            
        }
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


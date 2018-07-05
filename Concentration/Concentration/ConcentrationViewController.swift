//
//  ViewController.swift
//  Concentration
//
//  Created by Junhong Wang on 6/27/18.
//  Copyright © 2018 ioneone. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberofPairsOfCards)
    
    var numberofPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBOutlet private weak var scoreLabel: UILabel!
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    private var emojiChoices: String!
    private var emoji: [Card:String]!
    
    private var themes = [Theme:String]()
    private var backgrounds = [Theme:[UIColor]]()
    
    private var currentTheme: Theme!
    
    private enum Theme { 
        case face
        case hand
        case animal
        case food
        case sports
        case flag
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadThemes()
        loadBackgrounds()
        pickRandomTheme()
        loadBackground()
        loadEmoji()
        
        updateFlipCountLabel()
    }
    
    private func loadEmoji() {
        emojiChoices = themes[currentTheme]
        emoji = [Card:String]()
    }
    
    private func pickRandomTheme() {
        let themeOptions = Array(themes.keys)
        currentTheme = themeOptions[themeOptions.count.arc4random]
    }
    
    private func loadBackground() {
        let backgroundSet = backgrounds[currentTheme]
        view.backgroundColor = backgroundSet?.first
        for button in cardButtons {
            button.backgroundColor = backgroundSet?.last
        }
    }
    
    private func loadBackgrounds() {
        backgrounds[.face] = [#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)]
        backgrounds[.hand] = [#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)]
        backgrounds[.animal] = [#colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)]
        backgrounds[.food] = [#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)]
        backgrounds[.sports] = [#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)]
        backgrounds[.flag] = [#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1), #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)]
    }
    
    private func loadThemes() {
        themes[.face] = "😀😃😄😗😘😎😞😡😱😰"
        themes[.hand] = "🤲👏🤞👈👋🖖🙏💪👇🤘"
        themes[.animal] = "🐶🦊🐷🐧🙉🐝🐢🐍🦋🐴"
        themes[.food] = "🍏🍎🍉🍓🥕🍅🍇🍐🍞🍖"
        themes[.sports] = "⚽️🏀🏈⚾️🎾🏐🎱🏓🥊🏹"
        themes[.flag] = "🇨🇦🇨🇳🇹🇩🇫🇷🇯🇵🇱🇷🇲🇨🇳🇪🏳️‍🌈🇦🇽"
    }

    @IBAction private func cardTapped(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
            //flipCard(withEmoji: emojiChoices[cardNumber], on: sender)
        }
        else {
            print("Chosen emoji not registered")
        }
        
    }
    
    @IBAction private func newGameButtonTapped(_ sender: UIButton) {
        reloadGame()
    }
    
    private func reloadGame() {
        game = Concentration(numberOfPairsOfCards: numberofPairsOfCards)
        pickRandomTheme()
        loadEmoji()
        loadBackground()
        updateViewFromModel()
    }
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedStringKey:Any] = [
            .strokeWidth : 5.0,
            .strokeColor : backgrounds[currentTheme]?.last
        ]
        
        let attributedString = NSAttributedString(string: "Flips: \(game.flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    private func updateViewFromModel() {
        
        updateFlipCountLabel()
        scoreLabel.text = "Score: \(game.score)"
        
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : backgrounds[currentTheme]?.last
            }
        }
        
    }
    
    private func emoji(for card: Card) -> String {
        
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomIndex))
        }
        
        return emoji[card] ?? "?"
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








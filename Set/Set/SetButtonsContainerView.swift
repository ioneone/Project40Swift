//
//  SetButtonsContainerView.swift
//  Set
//
//  Created by Junhong Wang on 7/2/18.
//  Copyright © 2018 ioneone. All rights reserved.
//

import UIKit

class SetButtonsContainerView: UIView {
    
    private(set) var buttons = [SetButton]()
    
    private(set) lazy var deckButton: UIButton = {
        let button = UIButton()
        button.setTitle("deal three more cards", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        addSubview(button)
        return button
    }()
    
    private(set) lazy var discardPileButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("discard piles", for: .normal)
        button.setTitleColor(.black, for: .normal)
        addSubview(button)
        return button
    }()
    
//    lazy var animator = UIDynamicAnimator(referenceView: self)
//
//    lazy var collisionBehavior: UICollisionBehavior = {
//        let behavior = UICollisionBehavior()
//        behavior.translatesReferenceBoundsIntoBoundary = true
//        animator.addBehavior(behavior)
//        return behavior
//    }()
//
//    lazy var itemBehavior: UIDynamicItemBehavior = {
//        let behavior = UIDynamicItemBehavior()
//        behavior.allowsRotation = false
//        behavior.elasticity = 1.0
//        behavior.resistance = 0
//        animator.addBehavior(behavior)
//        return behavior
//    }()
    
    override func layoutSubviews() {
        let padding: CGFloat = 8.0
        deckButton.frame = CGRect(x: bounds.midX + padding, y: bounds.maxY - Constant.bottomSpacing + padding, width: bounds.size.width/2 - padding, height: Constant.bottomSpacing - padding)
        discardPileButton.frame = CGRect(x: bounds.minX + padding, y: bounds.maxY - Constant.bottomSpacing + padding, width: bounds.size.width/2 - padding, height: Constant.bottomSpacing - padding)
    }
    
    override var bounds: CGRect {
        didSet {
            updateButtonPositions()
        }
    }
    
    func updateButtonPositions() {
        for index in buttons.indices {
            let button = buttons[index]
            
            if button.frame == .zero { button.frame = deckButton.frame }
            
            let column = index % Constant.numberOfColumnsOfButtons
            let row = index / Constant.numberOfColumnsOfButtons
            let newFrame = CGRect(x: CGFloat(column) * (buttonWidth + Constant.buttonSpacing), y: CGFloat(row) * (buttonHeight + Constant.buttonSpacing), width: buttonWidth, height: buttonHeight)
            
        
            var delay = 0.0
            if areAllButtonsFaceDown {
                delay = Constant.buttonAnimationDuration + Constant.buttonAnimationDelay * Double(index)
            }
            else if !button.isFaceUp && button.frame == deckButton.frame {
                
                delay += Constant.buttonAnimationDelay * Double(index - (buttons.count - Constant.addtionalCardsToDealCount))
                
                if !neededToPushOldCardsToShowNewCards {
                    delay += Constant.buttonAnimationDuration
                }
                
            }
            
            assert(delay >= 0, "SetButtonsContainerView.updateButtonPositions(): animation delay should be greater or equal to 0")
             
            UIViewPropertyAnimator.runningPropertyAnimator(
                withDuration: Constant.buttonAnimationDuration,
                delay: delay,
                options: [.curveEaseIn],
                animations: {
                    button.frame = newFrame
            }) { (position) in
                
                
                if !button.isFaceUp {
                    
                    UIView.transition(
                        with: button,
                        duration: Constant.buttonAnimationDuration,
                        options: [.transitionFlipFromLeft],
                        animations: {
                            button.isFaceUp = true
                    },
                        completion: nil
                    
                    )
                
                }
            
            }
            
            
                
            
            
            
            
            
        }
    }
    
    func addButton(_ button: SetButton) {
        buttons.append(button)
        addSubview(button)

    }
    
    func removeButton(at index: Int) {
        let button = buttons.remove(at: index)
        
//        collisionBehavior.addItem(button)
//        itemBehavior.addItem(button)
//        let push = UIPushBehavior(items: [button], mode: .continuous)
//        push.angle = (CGFloat.pi)*(3/2)
//        push.magnitude = CGFloat(0.1)
//        push.action = { [unowned push] in
//            push.dynamicAnimator?.removeBehavior(push)
//        }
//        animator.addBehavior(push)
        
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: Constant.buttonAnimationDuration,
            delay: 0,
            options: [],
            animations: {
                button.frame = self.discardPileButton.frame
                button.alpha = 0
        },
            completion: { (position) in
                button.removeFromSuperview()
        })
        
        
        
        
    }

}

extension SetButtonsContainerView {
    private struct Constant {
        static let numberOfColumnsOfButtons: Int = 4
        static let buttonSpacing: CGFloat = 8.0
        static let startingNumberOfCards: Int = 6
        
        static let buttonAnimationDuration: TimeInterval = 0.6
        static let buttonAnimationDelay: TimeInterval = 0.2
        static let buttonAnimationDelayAmplifier: Double = 30
        
        static let bottomSpacing: CGFloat = 50
        
        static let addtionalCardsToDealCount = 3
        
        static let buttonFlyAwayDuration: TimeInterval = 3.0
    }
    
    var numberOfRowsOfButtons: Int {
        return 1 + (buttons.count - 1) / Constant.numberOfColumnsOfButtons
    }
    
    var buttonWidth: CGFloat {
        return (bounds.size.width - CGFloat(Constant.numberOfColumnsOfButtons - 1) * Constant.buttonSpacing) / CGFloat(Constant.numberOfColumnsOfButtons)
    }
    
    var buttonHeight: CGFloat {
        return ((bounds.size.height - Constant.bottomSpacing) - CGFloat(numberOfRowsOfButtons - 1) * Constant.buttonSpacing) / CGFloat(numberOfRowsOfButtons)
    }
    
    var areAllButtonsFaceDown: Bool {
        for button in buttons {
            if button.isFaceUp {
                return false
            }
        }
        return true
    }
    
    var neededToPushOldCardsToShowNewCards: Bool {
        return buttons.count % Constant.numberOfColumnsOfButtons == 0
    }
    
}

extension CGFloat {
    
    var arc4random: CGFloat {
        return self * CGFloat(drand48())
    }
    
}

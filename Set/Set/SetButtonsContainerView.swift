//
//  SetButtonsContainerView.swift
//  Set
//
//  Created by Junhong Wang on 7/2/18.
//  Copyright © 2018 ioneone. All rights reserved.
//

import UIKit

class SetButtonsContainerView: UIView {
    
    var buttons: [SetButton]? { didSet { setNeedsLayout() } }
    
    override func layoutSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
        guard let setButtons = buttons else { return }
        
        for index in setButtons.indices {
            let column = index % Constant.numberOfColumnsOfButtons
            let row = index / Constant.numberOfColumnsOfButtons
            setButtons[index].frame = CGRect(x: CGFloat(column) * (buttonWidth + Constant.buttonSpacing), y: CGFloat(row) * (buttonHeight + Constant.buttonSpacing), width: buttonWidth, height: buttonHeight)
            addSubview(setButtons[index])
        }
        
    }
    
    

}

extension SetButtonsContainerView {
    private struct Constant {
        static let numberOfColumnsOfButtons: Int = 4
        static let buttonSpacing: CGFloat = 8.0
        static let startingNumberOfCards: Int = 6
    }
    
    var numberOfRowsOfButtons: Int {
        return 1 + (((buttons?.count) ?? 0) - 1) / Constant.numberOfColumnsOfButtons
    }
    
    var buttonWidth: CGFloat {
        return (bounds.size.width - CGFloat(Constant.numberOfColumnsOfButtons - 1) * Constant.buttonSpacing) / CGFloat(Constant.numberOfColumnsOfButtons)
    }
    
    var buttonHeight: CGFloat {
        return (bounds.size.height - CGFloat(numberOfRowsOfButtons - 1) * Constant.buttonSpacing) / CGFloat(numberOfRowsOfButtons)
    }
}

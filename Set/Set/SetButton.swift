//
//  SetButton.swift
//  Set
//
//  Created by Junhong Wang on 7/4/18.
//  Copyright © 2018 ioneone. All rights reserved.
//

import UIKit

class SetButton: UIButton {
    
    var shape: Shape? { didSet { setNeedsDisplay(); setNeedsLayout() } }
    var shading: Shading? { didSet { setNeedsDisplay(); setNeedsLayout()} }
    var color: UIColor? { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    var count: Int? { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                layer.borderColor = UIColor.blue.cgColor
                layer.borderWidth = 2.0
            }
            else {
                layer.borderColor = nil
                layer.borderWidth = 0
            }
        }
    }
    
    private var path = UIBezierPath()
    
    override func draw(_ rect: CGRect) {
        guard let theShape = shape else { return }
        guard let theShading = shading else { return }
        guard let theColor = color else { return }
        guard let theCount = count else { return }
        
        clearPath()
        
        draw(theShape, with: theColor, with: theCount)
        draw(theShading, with: theColor)
    }
    
    init() {
        super.init(frame: .zero)
        contentMode = .redraw
        
        layer.cornerRadius = 8.0
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SetButton {
    
    enum Shape {
        case squiggle
        case diamond
        case oval
        
        static var allShapes: [Shape] = [.squiggle, .diamond, .oval]
        
        static var spacing: CGFloat = 4.0
    }
    
    enum Shading {
        case solid
        case striped
        case unfilled
        
        static var allShadings: [Shading] = [.solid, .striped, .unfilled]
        
        static var stripeSpacing: CGFloat = 4.0
    }
    
    private func draw(_ shading: Shading, with color: UIColor) {
        switch shading {
        case .solid:
            color.setFill()
            path.fill()
        case .striped:
            path.addClip()
            var xPosition = bounds.minX
            while xPosition < bounds.maxX {
                path.move(to: CGPoint(x: xPosition, y: bounds.minY))
                path.addLine(to: CGPoint(x: xPosition, y: bounds.maxY))
                xPosition += Shading.stripeSpacing
            }
            color.setStroke()
            path.stroke()
        case .unfilled: break
        }
    }
    
    private func draw(_ shape: Shape, with color: UIColor, with count: Int) {
        assert(0 < count && count <= 3, "SetButton.draw(\(shape), with: \(color), with: \(count)): count should be greater than 0 and less than or equal to 3")
        
        let totalSize = CGSize(width: bounds.size.width/2, height: bounds.size.height/2)
        let point = CGPoint(x: bounds.midX - totalSize.width/2, y: bounds.midY - totalSize.height/2)
        
        var points = [CGPoint]()
        var size = CGSize()
        
        if count == 1 {
            points.append(point)
            size = totalSize
        }
        else if count == 2 {
            points.append(point)
            if totalSize.width > totalSize.height {
                points.append(CGPoint(x: point.x + (totalSize.width - Shape.spacing)/2 + Shape.spacing, y: point.y))
                size = CGSize(width: (totalSize.width - Shape.spacing)/2, height: totalSize.height)
            }
            else {
                points.append(CGPoint(x: point.x, y: point.y + (totalSize.height - Shape.spacing)/2 + Shape.spacing))
                size = CGSize(width: totalSize.width, height: (totalSize.height - Shape.spacing)/2)
            }
        }
        else {
            points.append(point)
            if totalSize.width > totalSize.height {
                points.append(CGPoint(x: point.x + (totalSize.width - Shape.spacing * 2)/3 + Shape.spacing, y: point.y))
                points.append(CGPoint(x: point.x + (totalSize.width - Shape.spacing * 2)*(2/3) + Shape.spacing*2, y: point.y))
                size = CGSize(width: (totalSize.width - Shape.spacing*2)/3, height: totalSize.height)
            }
            else {
                points.append(CGPoint(x: point.x, y: point.y + (totalSize.height - Shape.spacing * 2)/3 + Shape.spacing))
                points.append(CGPoint(x: point.x, y: point.y + (totalSize.height - Shape.spacing * 2)*(2/3) + Shape.spacing*2))
                size = CGSize(width: totalSize.width, height: (totalSize.height - Shape.spacing * 2)/3)
            }
        }
        
        for point in points {
            switch shape {
            case .squiggle: drawSquiggle(at: point, with: size, with: color)
            case .diamond: drawDiamond(at: point, with: size, with: color)
            case .oval: drawOval(at: point, with: size, with: color)
            }
        }
        
    }
    
    private func drawSquiggle(at point: CGPoint, with size: CGSize, with color: UIColor) {
        path.move(to: CGPoint(x: point.x, y: point.y + size.height))
        path.addLine(to: CGPoint(x: point.x + size.width/3, y: point.y))
        path.addLine(to: CGPoint(x: point.x + size.width*(2/3), y: point.y + size.height/3))
        path.addLine(to: CGPoint(x: point.x + size.width, y: point.y))
        path.addLine(to: CGPoint(x: point.x + size.width*(2/3), y: point.y + size.height))
        path.addLine(to: CGPoint(x: point.x + size.width/3, y: point.y + size.height*(2/3)))
        path.close()
        
        color.setStroke()
        path.stroke()
        
    }
    
    private func drawDiamond(at point: CGPoint, with size: CGSize, with color: UIColor) {
        path.move(to: CGPoint(x: point.x + size.width/2, y: point.y))
        path.addLine(to: CGPoint(x: point.x + size.width, y: point.y + size.height/2))
        path.addLine(to: CGPoint(x: point.x + size.width/2, y: point.y + size.height))
        path.addLine(to: CGPoint(x: point.x, y: point.y + size.height/2))
        path.close()
        
        color.setStroke()
        path.stroke()
    }
    
    private func drawOval(at point: CGPoint, with size: CGSize, with color: UIColor) {
        let radius = min(size.width/2, size.height/2)
        let center = CGPoint(x: point.x + size.width/2, y: point.y + size.height/2)
        path.move(to: CGPoint(x: center.x + radius, y: center.y))
        path.addArc(withCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
        path.move(to: CGPoint(x: center.x + radius, y: center.y))
        path.close()
        
        color.setStroke()
        path.stroke()
    }
    
    private func clearPath() {
        path.removeAllPoints()
    }
}

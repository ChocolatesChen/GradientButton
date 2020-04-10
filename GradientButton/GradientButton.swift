//
//  GradientButton.swift
//  GradientButton
//
//  Created by cg on 2020/4/10.
//  Copyright © 2020 df. All rights reserved.
//

import UIKit

let kScreenHeight           = UIScreen.main.bounds.size.height
let kScreenWidth            = UIScreen.main.bounds.size.width

func RGBA (red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat)->UIColor {
    return UIColor (red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
}
//十六进制色
func colorWithHexString(_ hexString:String)->UIColor {
    
    var cString = hexString.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines).uppercased()
    if (cString.hasPrefix("#")) {
        let index = cString.index(cString.startIndex, offsetBy:1)
        cString = String(cString[index...])
    }
    if (cString.count != 6) {
        return UIColor.red
    }
    let rIndex = cString.index(cString.startIndex, offsetBy: 2)
    let rString = String(cString[..<rIndex])
    let otherString = String(cString[rIndex...])
    let gIndex = otherString.index(otherString.startIndex, offsetBy: 2)
    let gString = String(otherString[..<gIndex])
    let bIndex = cString.index(cString.endIndex, offsetBy: -2)
    let bString = String(cString[bIndex...])
    
    var red:CUnsignedInt = 0, green:CUnsignedInt = 0, blue:CUnsignedInt = 0;
    Scanner(string: rString).scanHexInt32(&red)
    Scanner(string: gString).scanHexInt32(&green)
    Scanner(string: bString).scanHexInt32(&blue)
    return RGBA(red:CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1)
}


class GradientButton: UIButton {
    
    typealias clickAction = (_ isSelected:Bool,_ btn:GradientButton) -> Void
    private var click: clickAction?
    private var buttonSelected:Bool = false
    private var colors: [UIColor]!
    private var pathLayer:CAGradientLayer!
    convenience init(title:String,
                     fontSize:CGFloat = 10,
                     colors: [UIColor],
                     direction:GradientDirection,
                     withButtonHandler buttonHandler: @escaping (_ isSelected:Bool,_ btn:GradientButton)->Void) {
        self.init(frame:.zero)
        self.colors = colors
        setTitle(title, for: UIControl.State())
        setTitleColor(.black, for: UIControl.State())
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        self.click = buttonHandler
        addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    }
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.df_rounded(4, width: 1, color: buttonSelected ? .clear : colorWithHexString("#D0D0D0"))
    }
    func switchButton(isSelected:Bool) {
        self.buttonSelected = isSelected
        setTitleColor(isSelected ? .white : .black, for: UIControl.State())
        titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: isSelected ? .medium : .regular)
        if isSelected {
            addGradient()
            if self.pathLayer != nil {
                self.layer.insertSublayer(self.pathLayer, at: 0)
            }
        } else {
            if ((self.layer.sublayers?[0] as? CAGradientLayer) != nil) {
                self.layer.sublayers?.remove(at: 0)
            }
            self.pathLayer = nil
        }
    }
    private func addGradient(){
        self.pathLayer = self.setGradient(colors: self.colors, direction: .Horizontal)
    }
    @objc fileprivate func buttonAction(_ sender:UIButton) {
        sender.isSelected.toggle()
        self.switchButton(isSelected: sender.isSelected)
        click?(self.buttonSelected,self)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
private var gradientLayerStr: Void?
// MARK: - 渐变色
extension UIView {
    // MARK: - layer
    
    /// 添加圆角
    ///
    /// - Parameter cornerRadius: 半径
    func df_rounded(_ cornerRadius: CGFloat) {
        df_rounded(cornerRadius, width: 0, color: nil)
    }
    
    /// 添加边框
    ///
    /// - Parameters:
    ///   - borderWidth: 宽度
    ///   - borderColor: 边框颜色
    func df_border(_ borderWidth: CGFloat, color borderColor: UIColor?) {
        df_rounded(0, width: borderWidth, color: borderColor)
    }
    
    /// 添加圆角、边框
    ///
    /// - Parameters:
    ///   - cornerRadius: 半径
    ///   - borderWidth: 宽度
    ///   - borderColor: 颜色
    func df_rounded(_ cornerRadius: CGFloat, width borderWidth: CGFloat, color borderColor: UIColor?) {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor?.cgColor
        layer.masksToBounds = true
    }
    
    //枚举渐变色的方向
    enum GradientDirection {
        case Horizontal
        case Vertical
        case Right
        case Left
        case Bottom
        case Top
        case TopLeftToBottomRight
        case TopRightToBottomLeft
        case BottomLeftToTopRight
        case BottomRightToTopLeft
    }
    
    @discardableResult
    func setGradient(colors: [UIColor], direction:GradientDirection) -> CAGradientLayer {
        func setGradient(_ layer: CAGradientLayer) {
            self.layoutIfNeeded()
            var colorArr = [CGColor]()
            for color in colors {
                colorArr.append(color.cgColor)
            }
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            layer.frame = self.bounds
            CATransaction.commit()
            
            layer.colors = colorArr
            
            switch direction {
            case .Horizontal:
                layer.startPoint = CGPoint(x:0.0, y:0.0)
                layer.endPoint = CGPoint(x:1.0, y:0.0)
                
            case .Vertical:
                layer.startPoint = CGPoint(x:0.0, y:0.0)
                layer.endPoint = CGPoint(x:0.0, y:1.0)
                
            case .Right:
                layer.startPoint = CGPoint(x:0.0, y:0.5)
                layer.endPoint = CGPoint(x:1.0, y:0.5)
                
            case .Left:
                layer.startPoint = CGPoint(x:1.0, y:0.5)
                layer.endPoint = CGPoint(x:0.0, y:0.5)
                
            case .Bottom:
                layer.startPoint = CGPoint(x:0.5, y:0.0)
                layer.endPoint = CGPoint(x:0.5, y:1.0)
                
            case .Top:
                layer.startPoint = CGPoint(x:0.5, y:1.0)
                layer.endPoint = CGPoint(x:0.5, y:0.0)
                
            case .TopLeftToBottomRight:
                layer.startPoint = CGPoint(x:0.0, y:0.0)
                layer.endPoint = CGPoint(x:1.0, y:1.0)
                
            case .TopRightToBottomLeft:
                layer.startPoint = CGPoint(x:1.0, y:0.0)
                layer.endPoint = CGPoint(x:0.0, y:1.0)
                
            case .BottomLeftToTopRight:
                layer.startPoint = CGPoint(x:0.0, y:1.0)
                layer.endPoint = CGPoint(x:1.0, y:0.0)
                
            default:
                layer.startPoint = CGPoint(x:1.0, y:1.0)
                layer.endPoint = CGPoint(x:0.0, y:0.0)
            }
        }
        
        if let gradientLayer = objc_getAssociatedObject(self, &gradientLayerStr) as? CAGradientLayer {
            setGradient(gradientLayer)
            return gradientLayer
        }else {
            let gradientLayer = CAGradientLayer()
            self.layer.insertSublayer(gradientLayer , at: 0)
            setGradient(gradientLayer)
            objc_setAssociatedObject(self, &gradientLayerStr, gradientLayer, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return gradientLayer
        }
    }
}

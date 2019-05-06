//
//  Class+Extensions.swift
//  Nanolens
//
//  Created by Joshua Choi on 4/30/2019.
//  Copyright © 2018 Joshua Choi. All rights reserved.
//

import UIKit
import Accelerate
import AVFoundation
import AVKit



// MARK: - UIFont
extension UIFont {
    
    /**
     Returns the AvenirNext-Medium font with specified font size.
     - Parameter size: A CGFloat value used to set the UIFont object's size.
     */
    static func medium(size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-Medium", size: size)!
    }
    
    /**
     Returns the AvenirNext-Demibold font with specified font size.
     - Parameter size: A CGFloat value used to set the UIFont object's size.
     */
    static func demibold(size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-Demibold", size: size)!
    }
    
    /**
     Returns the AvenirNext-Bold font with specified font size.
     - Parameter size: A CGFloat value used to set the UIFont object's size.
     */
    static func bold(size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-Bold", size: size)!
    }
    
    /**
     Returns the AvenirNext-Heavy font with specified font size.
     - Parameter size: A CGFloat value used to set the UIFont object's size.
     */
    static func heavy(size: CGFloat) -> UIFont {
        return UIFont(name: "AvenirNext-Heavy", size: size)!
    }
}


// MARK: - CALayer
extension CALayer {
    
    /**
     Adds a CAGradientLayer with multiple black colors of varying alpha opacities that "scale down" throughout the view. This layer adds the darkest black color shadow at the top of the view's layer, then the lightest black color shadow at the bottom of the view's layer.
     - Parameter darkToLight: A Boolean value indicating whether the shadow should "scale down" from dark to light or light to dark. If TRUE, the view will have the darkest shadow at the top of its layer with the lightest shadow at the bottom. If FALSE, the view will have the lightest shadow at the top of its layer and the darkest shadow at the bottom.
     */
    func addGradientShadow(darkToLight: Bool) {
        // Add gradient shadows w/3 colors: super light, ultra light gray, and white
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        let black8 = UIColor.black.withAlphaComponent(0.16).cgColor
        let black7 = UIColor.black.withAlphaComponent(0.14).cgColor
        let black6 = UIColor.black.withAlphaComponent(0.12).cgColor
        let black5 = UIColor.black.withAlphaComponent(0.10).cgColor
        let black4 = UIColor.black.withAlphaComponent(0.08).cgColor
        let black3 = UIColor.black.withAlphaComponent(0.06).cgColor
        let black2 = UIColor.black.withAlphaComponent(0.04).cgColor
        let black1 = UIColor.black.withAlphaComponent(0.02).cgColor
        let black0 = UIColor.black.withAlphaComponent(0.01).cgColor
        if darkToLight == true {
            gradientLayer.colors = [black8, black7, black6, black5, black4, black3, black2, black1, black0]
        } else if darkToLight == false {
            gradientLayer.colors = [black0, black1, black2, black3, black4, black5, black6, black7, black8]
        }
        gradientLayer.locations = [0.0, 0.10, 0.20, 0.40, 0.50, 0.60, 0.80, 0.90, 1.0]
        self.insertSublayer(gradientLayer, at: 0)
    }
    
    /**
     Applies a shadow to a CAlayer (usually of a UIView object).
     - Parameter color: A CGColor value represneting the shadow's color. Defaults to .black
     - Parameter opacity: A Float value representing the shadow's opacity. Defaults to 0.5
     - Parameter offset: A CGSize value representing the shadow's blur. Defaults to CGSize(width: 0, height: 4)
     - Parameter radius: A CGSize value representing the shadow's radius. Defaults to CGFloat(4.0)
     - Parameter masksToBounds: An optional Boolean value used to determine whether the view's sublayers should clip to their superlayer's bounds. If nil, the layer's masksToBounds property will be set to FALSE. Defaults to false.
     */
    func applyShadow(
        color: CGColor = UIColor.black.cgColor,
        opacity: Float = 0.5,
        offset: CGSize = CGSize(width: 0, height: 4),
        radius: CGFloat = 4,
        masksToBounds: Bool = false
        ) {
        
        self.shadowColor = color
        self.shadowOpacity = opacity
        self.shadowOffset = offset
        self.shadowRadius = radius
        self.masksToBounds = masksToBounds
    }
    
    /**
     Add a colored-border to the bottom of the layer
     - Parameter isTop: A Boolean value indicating whether the border overlay is at the top or bottom of the layer.
     - Parameter layerHeight: The height of the bottom border.
     - Parameter layerColor: The color the bottom border should be.
     */
    func addLayerBorder(isTop: Bool, layerHeight: CGFloat, layerColor: UIColor) {
        let borderOverlay = CALayer()
        borderOverlay.backgroundColor = layerColor.cgColor
        if isTop == true {
            borderOverlay.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.bounds.width), height: layerHeight)
        } else if isTop == false {
            borderOverlay.frame = CGRect(x: CGFloat(0), y: self.bounds.height - layerHeight, width: CGFloat(self.bounds.width), height: layerHeight)
        }
        self.addSublayer(borderOverlay)
    }
}


// MARK: - TimeInterval
extension TimeInterval {
    /**
     Returns a TimeInterval object's duration in the format of hours, minutes, and seconds
     ie: 2:20:12
     */
    static func getHourMinuteSecondValue(interval: TimeInterval) -> String {
        let seconds = Int(interval) % 60
        let minutes = (Int(interval) / 60) % 60
        let hours = (Int(interval) / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    /**
     Returns a TimeInterval object's duration in the format of minutes, and seconds
     ie: 20:12
     */
    static func getMinutSecondValue(interval: TimeInterval) -> String {
        let seconds = Int(interval) % 60
        let minutes = (Int(interval) / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}



// MARK: - UIApplication
extension UIApplication {
    /// Modify the statusBar. Usage example:
    /// UIApplication.shared.statusBarView?.backgroundColor = UIColor.red
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}



// MARK: - UIButton
extension UIButton {
    
    /**
     Designs the UIButton's title and borders.
     - Parameter titleAttributes: A NSAttributedString object used to design the button's title
     - Parameter borderColor: A UIColor value to set the button's borders' color.
     - Parameter backgroundColor: A UIColor value to set the button's background color.
     - Parameter borderWidth: A CGFloat value to set the button's borders' width.
     - Paameter cornerRadii: A CGFloat value used to set the button's corner radius.
     */
    func setButtonTitle(titleAttributes: NSAttributedString, borderColor: UIColor, backgroundColor: UIColor, borderWidth: CGFloat, cornerRadii: CGFloat) {
        // Set the button's title
        self.setTitle(titleAttributes.string, for: .normal)
        // Unwrap the NSAttributedString's font
        if let font = titleAttributes.attribute(.font, at: 0, effectiveRange: nil) as? UIFont {
            self.titleLabel!.font = font
        }
        // Unwrap the NSAttributedString's foregroundColor
        if let titleColor = titleAttributes.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor {
            self.setTitleColor(titleColor, for: .normal)
        }
        // Set the button's corner radius
        self.layer.cornerRadius = cornerRadii
        // Set the button's backgroundColor
        self.backgroundColor = backgroundColor
        // Set the button's borderColor
        self.layer.borderColor = borderColor.cgColor
        // Set the button's borderWidth
        self.layer.borderWidth = borderWidth
        // Clips its subviews within this button's bounds
        self.clipsToBounds = true
    }
    
    /**
     Applies a horizontal gradient title to the button's label.
     - Parameter colors: An array of UIColor values used to apply the gradient to the button's text.
     - Parameter titleAttributes: An NSAttributedString value to set the button's title and font (no need to set colors, because the gradient's color will be set).
     - Parameter cornerRadii: A CGFloat value representing the corner radius of the button.
     - Parameter backgroundColor: A UIColor value used to set the button's background.
     - Parameter borderColor: A UIColor value used to set the button's border color.
     - Parameter borderWidth: A CGFloat value used to set the button's border width.
     */
    func setGradientTitle(colors: [UIColor],
                          titleAttributes: NSAttributedString,
                          cornerRadii: CGFloat,
                          backgroundColor: UIColor = .white,
                          borderColor: UIColor = .clear,
                          borderWidth: CGFloat = 0) {
        // self
        self.backgroundColor = backgroundColor
        self.setAttributedTitle(titleAttributes, for: .normal)
        self.layer.cornerRadius = cornerRadii
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        
        // MARK: - CAGradientLayer
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.colors = colors.map({$0.cgColor})
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    /**
     Set the button's image with gradient colors.
     - Parameter colors: An array of UIColor values.
     - Parameter image: A UIImage value used to set the image for this button.
     */
    func setGradientOnImage(_ colors: [UIColor], _ image: UIImage) {
        // self
        self.backgroundColor = backgroundColor
        self.setImage(image, for: .normal)
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        
        // MARK: - CAGradientLayer
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.colors = colors.map({$0.cgColor})
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    /**
     Sets the button's image and insets
     - Parameter image: An optional UIImage for the button. Set this to NIL if you want to hide the image from being displayed
     - Parameter insets: A UIEdgeInset value for the button's contentInset.
     - Parameter tintColor: A UIColor for the button's tint. Defaults to white.
     - Parameter backgroundColor: A UIColor for the button's background color.
     - Paameter applyShadow: A Boolean value to determine whether the button's layer should apply a CALayer shadow. Defaults to TRUE.
     */
    func setButtonImage(image: UIImage?, insets: UIEdgeInsets, tintColor: UIColor = UIColor.white, backgroundColor: UIColor = UIColor.clear, applyShadow: Bool = true) {
        // Set the button's image
        self.setImage(image != nil ? image!.withRenderingMode(.alwaysTemplate) : nil, for: .normal)
        self.contentEdgeInsets = insets
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
        
        // Apply the shadow if applicable
        if applyShadow == true {
            self.layer.applyShadow()
        }
    }
}



// MARK: - UIColor
extension UIColor {
    
    /// Returns the #fcfcfc hex color
    static var offWhite: UIColor {
        // UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.0)
        // #fcfcfc
        return UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.0)
    }
    
    /// Returns the #007AFF hex color
    static var babyBlue: UIColor {
        // UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
        // #007AFF
        return UIColor(red: 0.00, green: 0.48, blue: 1.00, alpha: 1.0)
    }
    
    /// Returns the #242424 hex color
    static var charcoal: UIColor {
        // UIColor(red: 0.14, green: 0.14, blue: 0.14, alpha: 1.0)
        // #242424
        return UIColor(red: 0.14, green: 0.14, blue: 0.14, alpha: 1.0)
    }
    
    /// Returns the #FF0042 hex color
    static var infared: UIColor {
        // UIColor(red: 1, green: 0, blue: 0.26, alpha: 1)
        // #FF0042
        return UIColor(red: 1, green: 0, blue: 0.26, alpha: 1)
    }
    
    /// Returns the #BB00FF hex color
    static var royalPurple: UIColor {
        // UIColor(red: 0.73, green: 0.00, blue: 1.0, alpha: 1.0)
        // #BB00FF
        return UIColor(red: 0.54, green: 0.00, blue: 1.00, alpha: 1.0)
    }
    
    /// Returns the #FFEF00 hex color
    static var kidYellow: UIColor {
        // UIColor(red: 1.0, green: 0.94, blue: 0.00, alpha: 1.0)
        // #FFEF00
        return UIColor(red: 1.0, green: 0.94, blue: 0.00, alpha: 1.0)
    }
    
    /// Generates a random UIColor
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0)
    }
    
    /**
     Used to utilize HEX Color values instead of UIColor's RGB components. USAGE: let color2 = UIColor(rgb: ff0050)
     - Parameter red: The red HEX color value.
     - Parameter green: The green HEX color value.
     - Parameter blue: The blue HEX color value.
     */
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}




// MARK: - UIScreen
extension UIScreen {
    /// Determines if the device is the iPhone X model
    static var isXModel: Bool {
        // Unwrap the application's key window
        guard let appKeyWindow = UIApplication.shared.keyWindow else {
            return false
        }
        
        // Get the top safe area insets
        return appKeyWindow.safeAreaInsets.bottom > CGFloat(0.0)
    }
    
    /// Returns both the top and bottom safe area insets if any
    static var allSafeAreaInsets: CGFloat {
        // Unwrap the application's key window
        guard let appKeyWindow = UIApplication.shared.keyWindow else {
            return 0.0
        }
        // Return the sum of both the top and bottom safe area insets
        return appKeyWindow.safeAreaInsets.top + appKeyWindow.safeAreaInsets.bottom
    }
    
    /// Returns the top safe area insets, if any
    static var topSafeAreaInset: CGFloat {
        // Unwrap the application's key window
        guard let appKeyWindow = UIApplication.shared.keyWindow else {
            return 0.0
        }
        // Return the top safe area insets
        return appKeyWindow.safeAreaInsets.top
    }
    
    /// Returns the bottom safe area insets, if any
    static var bottomSafeAreaInset: CGFloat {
        // Unwrap the application's key window
        guard let appKeyWindow = UIApplication.shared.keyWindow else {
            return 0.0
        }
        // Return the bottom safe area insets
        return appKeyWindow.safeAreaInsets.bottom
    }
    
    /// Returns the application's status bar's height
    static var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.maxY
    }
}



// MARK: - UIView
extension UIView {
    
    /**
     Returns a copy of the view object (frame included).
     Usage/ie: let copiedView = UIView().copiedView()
     */
    func copiedView() -> UIView? {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as? UIView
    }
    
    /**
     NOTE: The MVC principle designed by Apple wants us to access views from the view controller class. This method allows us to access the parent view controller class using the view.
     ie: if let parentViewController = view.isViewController {...}
     */
    var inViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    /**
     Draws a circular mask around the view object.
     - Parameter forView: The UIView object to draw a circular mask around its layer for.
     - Parameter borderWidth: The width of the outer border of the UIView's layer.
     - Parameter borderColor: The UIColor of the border.
     */
    func makeCircular(borderWidth: CGFloat, borderColor: UIColor) {
        self.layer.cornerRadius = self.frame.size.width/2
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        self.layoutIfNeeded()
    }
    
    /**
     Rounds the corners of a view object. Should use when the sides of a long UIButton (width > height) should be rounded.
     - Parameter borderWidth: A CGFloat value used to define width of the view layer's border (outline).
     - Parameter borderColor: A UIColor value used to define color of the view layer's border color.
     - Parameter cornerRadii: A CGFloat value used to define the corner radius of the view's layer.
     */
    func drawSides(borderWidth: CGFloat, borderColor: UIColor, cornerRadii: CGFloat) {
        self.layer.cornerRadius = cornerRadii
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        self.layoutIfNeeded()
    }
    
    /**
     Sets the view's background with a color gradient
     - Parameter colorOne: The first color of the gradient.
     - Parameter colorTwo: The second color of the gradient.
     */
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    /**
     Brings an array of other view objects (generally subviews) to the front and applies a shadow to their layer.
     - Parameter objects: An array of UIView objects
     - Parameter useAutoLayout: A Boolean value that determines whether the view's autoresizing mask is translated into Auto Layout constraints. Set this value to TRUE if you want to modify the views' size/location using the view's frame, bounds, or center properties using a static, frame-based layout within Auto Layout.
     */
    func addShadowForGroup(objects: [UIView], useAutoLayout: Bool) {
        for viewObject in objects {
            // Apply the shadow to the view objects
            viewObject.layer.applyShadow()
            viewObject.translatesAutoresizingMaskIntoConstraints = useAutoLayout
            // Bring the view objects to the front
            self.addSubview(viewObject)
            self.bringSubviewToFront(viewObject)
        }
    }
    
    /**
     Adds a view object in its parent view and sets up its horizontal and vertical alignment constraints directly in the parent view.
     - Parameter parentView: The parent UIView that adds the view object in its parent view class
     - Parameter insertAt: An Int value representing which z-position layer the view should be inserted into as a sub view.
     */
    func setCenterConstraints(parentView: UIView, insertAt: Int = 0) {
        parentView.insertSubview(self, at: insertAt)
        self.centerXAnchor.constraint(equalTo: parentView.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: parentView.centerYAnchor).isActive = true
    }
}



// MARK: - UIViewController
extension UIViewController {
    
    /**
     Configures the view controller's UIStatusBar to hide.
     */
    func hideStatusBar() {
        UIApplication.shared.isStatusBarHidden = true
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    /**
     Configures the view controller's UIStatusBar to show and set to light.
     */
    func setStatusBarLight() {
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    /**
     Configures the view controller's UIStatusBar to show and set to defaut.
     */
    func setStatusBarDefault() {
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .default
        self.setNeedsStatusBarAppearanceUpdate()
    }
}





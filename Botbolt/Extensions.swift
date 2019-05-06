//
//  Class+Extensions.swift
//  Nanolens
//
//  Created by Joshua Choi on 5/20/18.
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



// MARK: - Array
extension Array {
    /**
     Removes multiple values from an array by specifying the index positions to remove.
     - Parameter indices: An array of Int values representing the position of items to remove in a given array.
     */
    mutating func removeMultiple(_ indices: [Int]) {
        // Initialized Int value representing the last index in the array
        var lastIndex: Int? = nil
        
        // Loop through the array
        for index in indices.sorted(by: >) {
            // Unwrap the last index - if not last, then continue the loop
            guard lastIndex != index else {
                continue
            }
            // Remove the item
            remove(at: index)
            // Set the lst index as the current position in the loop
            lastIndex = index
        }
    }
}

extension Array where Element: Comparable {
    /**
     Returns the index and value of the largest element in the array.
     */
    public func argmax() -> (Int, Element) {
        precondition(self.count > 0)
        var maxIndex = 0
        var maxValue = self[0]
        for i in 1..<self.count {
            if self[i] > maxValue {
                maxValue = self[i]
                maxIndex = i
            }
        }
        return (maxIndex, maxValue)
    }
}

extension Array where Element: Equatable {
    
    /**
     Remove duplicate values from an array
     */
    func unique() -> Array {
        return reduce(into: []) { result, element in
            if !result.contains(element) {
                result.append(element)
            }
        }
    }
    
    /**
     Removes an element from an array by filtering out the array without the specified object.
     - Parameter obj: Any object to remove from the element.
     */
    mutating func remove(_ obj: Element) {
        self = self.filter { $0 != obj }
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



// MARK: - CGRect
extension CGRect {
    func dividedIntegral(fraction: CGFloat, from fromEdge: CGRectEdge) -> (first: CGRect, second: CGRect) {
        let dimension: CGFloat
        
        switch fromEdge {
        case .minXEdge, .maxXEdge:
            dimension = self.size.width
        case .minYEdge, .maxYEdge:
            dimension = self.size.height
        }
        
        let distance = (dimension * fraction).rounded(.up)
        var slices = self.divided(atDistance: distance, from: fromEdge)
        
        switch fromEdge {
        case .minXEdge, .maxXEdge:
            slices.remainder.origin.x += 1
            slices.remainder.size.width -= 1
        case .minYEdge, .maxYEdge:
            slices.remainder.origin.y += 1
            slices.remainder.size.height -= 1
        }
        
        return (first: slices.slice, second: slices.remainder)
    }
}




// MARK: - Character
extension Character {
    /// Determines if a character is an emoji or not.
    func isEmoji() -> Bool {
        return Character(UnicodeScalar(UInt32(0x1d000))!) <= self && self <= Character(UnicodeScalar(UInt32(0x1f77f))!)
            || Character(UnicodeScalar(UInt32(0x2100))!) <= self && self <= Character(UnicodeScalar(UInt32(0x26ff))!)
    }
}



// MARK: - CIImage
extension CIImage {
    /**
     Casts a CIImage to a UIImage.
     */
    func toUIImage() -> UIImage? {
        let context: CIContext = CIContext.init(options: nil)
        if let cgImage: CGImage = context.createCGImage(self, from: self.extent) {
            return UIImage(cgImage: cgImage)
        } else {
            return nil
        }
    }
}



// MARK: - CGImage
extension CGImagePropertyOrientation {
    /**
     Converts UIImageOrientation to CGImageOrientation for use in computer vision analysis
     - Parameter uiImageOrientation: A UIImage.Orientation property.
     */
    init(_ uiImageOrientation: UIImage.Orientation) {
        switch uiImageOrientation {
        case .up:
            self = .up
        case .down:
            self = .down
        case .left:
            self = .left
        case .right:
            self = .right
        case .upMirrored:
            self = .upMirrored
        case .downMirrored:
            self = .downMirrored
        case .leftMirrored:
            self = .leftMirrored
        case .rightMirrored:
            self = .rightMirrored
        }
    }
}



// MARK: - Date
extension Date {
    
    /**
     Gets the date of a Date object and returns a readable String value. Defaults to "LLL, yyy" (ABBREVIATED MONTH, Year)
     - Parameter date: A Date object to return a String value for. The format is fixed to: "LLL, yyy" or ie: Jul, 1997
     - Parameter dateFormat: A String value to set the DateFormatter object. Use the following formats to return different types of String:
     
     */
    static func getString(_ date: Date, _ dateFormat: String = "LLL, yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let readableDate = dateFormatter.string(from: date)
        return readableDate
    }
    
    /**
     Gets the shorted time of a DateCompenent instance represented as "s ago/m ago/h ago etc."
     - Parameter date: The Date instance to compare and calculate its difference for.
     */
    static func getNTimeAgo(date: Date) -> String {
        let now = Date()
        let components: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfMonth]
        let difference = (Calendar.current as NSCalendar).components(components, from: date, to: now, options: [])
        
        // logic what to show : Seconds, minutes, hours, days, or weeks
        if difference.second! <= 0 {
            return "now"
            
        } else if difference.second! > 0 && difference.minute! == 0 {
            return "\(difference.second!)s ago"
            
        } else if difference.minute! > 0 && difference.hour! == 0 {
            return "\(difference.minute!)m ago"
            
        } else if difference.hour! > 0 && difference.day! == 0 {
            return "\(difference.hour!)h ago"
            
        } else if difference.day! > 0 && difference.weekOfMonth! == 0 {
            return "\(difference.day!)d ago"
            
        } else {
            let createdDate = DateFormatter()
            createdDate.dateFormat = "MMM d, yyyy"
            return createdDate.string(from: date)
        }
    }
}



// MARK: - FileManager
extension FileManager {
    /**
     Create a new directory for the new movie file to write to in the documents directory.
     - Parameter url: Returns an optional URL object.
     */
    static func getNewURL(_ pathComponent: String) -> URL? {
        // MARK: - FileManager
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        // Setup the file type (movie)
        let fileURL = documentsURL?.appendingPathComponent(pathComponent)
        return fileURL
    }
}



// MARK: - Int
extension Int {
    /**
     Returns an Integer value as a String separated by commas.
     - Parameter value: An Int value
     */
    func separated() -> String {
        // Create a NumberFormatter object
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        // Cast the value as a string and return its value in this convenience method
        return numberFormatter.string(from: NSNumber(value: self))!
    }
    
    /**
     Determins if an Int value is a prime number.
     */
    func isPrime() -> Bool {
        switch self {
        case 0, 1:
            return false
        case 2, 3:
            return true
        default:
            for i in 2...Int(sqrt(Double(self))) {
                if self % i == 0 {
                    return false
                }
            }
            return true
        }
    }
}



// MARK: - Sequence
extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}



// MARK: - String
extension String {
    
    /// Generates a unique String value using the device's UUID.
    static var uniqueId: String {
        return UUID().uuidString
    }
    
    /// Return an optional array of URL values representing a website.
    func getLinks() -> [URL]? {
        /// Initialized array of URL values
        var urls: [URL] = [URL]()
        
        // MARK: - NSDataDetector
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
        
        // Loop through the matches
        for match in matches {
            guard let range = Range(match.range, in: self) else { continue }
            urls.append(URL(string: String(self[range]))!)
        }
        
        return urls
    }
    
    /// Returns an optional array of String values representing phone numbers.
    func getPhoneNumbers() -> [String]? {
        
        // MARK: - NSTextCheckingResult.CheckingType
        let types: NSTextCheckingResult.CheckingType = [.phoneNumber]
        let detector = try? NSDataDetector(types:types.rawValue)
        
        // Parse the string
        let range = NSMakeRange(0, self.utf16.count)
        let matches = detector?.matches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range:range)
        
        // Filter out phone number match types and map them to the phone numbers' string values
        guard let allMatches = matches?.filter({$0.resultType == .phoneNumber}).map({$0.phoneNumber!}) else {
            return nil
        }
        
        // Return all the matches found
        return allMatches
    }
    
    /// Returns an optional array of Date objects representing dates found in a String.
    func getDates() -> [Date]? {
        // MARK: - NSTextCheckingResult.CheckingType
        let types: NSTextCheckingResult.CheckingType = [.date]
        let detector = try? NSDataDetector(types: types.rawValue)
        
        // Parse the string
        let range = NSMakeRange(0, self.utf16.count)
        let matches = detector?.matches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range:range)
        
        // Filter out date match types and map them to the Date object values
        guard let allMatches = matches?.filter({$0.resultType == .date}).map({$0.date!}) else {
            return nil
        }
        
        // Return all the matches found
        return allMatches
    }
    
    /// Returns an array of String values representing street addresses found in a String.
    func getAddresses() -> [String]? {
        // MARK: - NSTextCheckingResult.CheckingType
        let types: NSTextCheckingResult.CheckingType = [.address]
        let detector = try? NSDataDetector(types:types.rawValue)
        
        // Parse the string
        let range = NSMakeRange(0, self.utf16.count)
        let matches = detector?.matches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range:range)
        
        /// Initialized String value used to return all the addresses found in the string
        var addresses: [String] = [String]()
        addresses.removeAll(keepingCapacity: false)
        
        // MARK: - NSMutableDictionary
        let addressComponents = NSMutableDictionary()
        
        // Unwrap the found matches
        guard let allMatches = matches else {
            return nil
        }
        
        // Loop through the matches
        for i in 0..<allMatches.count {
            // Ensure that the match result type is an address
            if allMatches[i].resultType == .address {
                addressComponents.addEntries(from: allMatches[i].addressComponents!)
            }
        }
        
        // Ensure all components of the address' street, city, and state exist
        if addressComponents["Street"] != nil && addressComponents["City"] != nil && addressComponents["State"] != nil {
            // Initialized String to store the address
            var address: String = ""
            
            // Get the street
            if let street = addressComponents["Street"] as? String {
                address += "\(street),"
            }
            
            // Get the city
            if let city = addressComponents["City"] as? String {
                address += " \(city)"
            }
            
            // Get the state
            if let state = addressComponents["State"] as? String {
                address += " \(state)"
            }
            
            // Append the address
            addresses.append(address)
        }
        
        // Return the addresses
        return addresses
    }
    
    /// Generates a random String with a specified length.
    /// - Parameter length: An Int value representing how long this String value should be.
    static func randomString(_ length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    
    /// Determines if String is an email or not. Returns TRUE if so.
    func isValidEmail() -> Bool {
        let email = self.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
        if email.contains("@") && email.contains(".") {
            return true
        } else {
            return false
        }
    }
    
    /// Returns a UIImage from a UTF string value.
    func image() -> UIImage {
        let size = CGSize(width: 100.00, height: 100.00)
        UIGraphicsBeginImageContextWithOptions(size, false, 1);
        UIColor.clear.set()
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        (self as NSString).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 100)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    /// Determines if String value has NO String INCLUDING new lines and spaces.
    var isBlank: Bool {
        let s = self
        let cset = CharacterSet.newlines.inverted
        let r = s.rangeOfCharacter(from: cset)
        let ok = s.isEmpty || r == nil
        return ok
    }
    
    /// Removes the all Emoji's in a string. Usage: <stringVariable>.stringByRemovingEmoji()
    /// - Returns String: Returns the String by removing ALL emoji characters.
    func stringByRemovingEmoji() -> String {
        return String(self.filter{!$0.isEmoji()})
    }
    
    /// Generates a single, random Emoji.
    /// - Returns String: Returns the random Emoji (as a String).
    static var randomEmoji: String {
        let range = [UInt32](0x1F601...0x1F64F)
        let ascii = range[Int(drand48() * (Double(range.count)))]
        let emoji = UnicodeScalar(ascii)?.description
        return emoji!
    }
    
    /// Generates a random string value with its given length
    /// - Parameter length: The n-number of characters for the output of the String this method returns, delegated by its Int value.
    static func randomString(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
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



// MARK: - UICollectionViewCell
extension UICollectionViewCell {
    /// Returns a 3 by 3 CGSize with a ratio 3/3*2 ratio respective to the device screen's height
    static var cubedSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.width/3 * 2)
    }
    
    /// Returns a 2/3 ratio CGSize value reflecting the device's width and the device's height.
    static var squaredSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.width/3 * 2)
    }
    
    /// Returns a 3 by 3 CGSize with a ratio 3/3 ratio respective to the device screen's width
    static var perfectCubedSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.width/3)
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



// MARK: - UIImage
extension UIImage {
    
    /// MARK: - ScalingMode (represents a scaling mode)
    enum ScalingMode {
        /// Apsect Fill
        case aspectFill
        /// Aspect Fit
        case aspectFit
        
        /**
         Calculates the aspect ratio between two sizes.
         - Parameter size: A CGSize used to calculate the ratio
         - Parameter scalingMode: Another CGSize used to calculate the ratio
         
         - Parameter CGFloat: Returns the aspect ratio b/w the two sizes.
         */
        func aspectRatio(between size: CGSize, and otherSize: CGSize) -> CGFloat {
            let aspectWidth  = size.width/otherSize.width
            let aspectHeight = size.height/otherSize.height
            
            switch self {
            case .aspectFill:
                return max(aspectWidth, aspectHeight)
            case .aspectFit:
                return min(aspectWidth, aspectHeight)
            }
        }
    }
    
    /**
     Scales an image to fit within a bounds with a size governed by the passed size. Also keeps the aspect ratio.
     - Parameter newSize: A CGSize of the bounds the image must fit within.
     - Parameter scalingMode: A desired scaling mode.
     
     - Parameter image: A UIImage returned from the method.
     */
    func scaled(to newSize: CGSize, scalingMode: UIImage.ScalingMode = .aspectFill) -> UIImage {
        
        let aspectRatio = scalingMode.aspectRatio(between: newSize, and: size)
        
        /* Build the rectangle representing the area to be drawn */
        var scaledImageRect = CGRect.zero
        
        scaledImageRect.size.width  = size.width * aspectRatio
        scaledImageRect.size.height = size.height * aspectRatio
        scaledImageRect.origin.x    = (newSize.width - size.width * aspectRatio) / 2.0
        scaledImageRect.origin.y    = (newSize.height - size.height * aspectRatio) / 2.0
        
        /* Draw and retrieve the scaled image */
        UIGraphicsBeginImageContext(newSize)
        
        draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
    
    
    /**
     Take the height or width of the image — whichever is greater — and set that dimension equal to the maxDimension argument. Next, to maintain the image’s aspect ratio, scale the other dimension accordingly. Next, redraw the original image into the new frame. Finally, return the scaled image back to the calling function.
     - Parameter maxDimension: A CGFloat value used to resize the image for pre-processing (defaults to 640).
     */
    func scaleImage(_ maxDimension: CGFloat = 640.00) -> UIImage? {
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        
        if size.width > size.height {
            let scaleFactor = size.height / size.width
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            let scaleFactor = size.width / size.height
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        draw(in: CGRect(origin: .zero, size: scaledSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    /**
     Redraws an image to a preferred size. Useful for re-drawing assets for UIBarButtonItems.
     - Parameter targetSize: A CGSize value used to return a new image with its preferred size.
     */
    func resizeImage(_ targetSize: CGSize) -> UIImage {
        // Get the ratio of the image with relative to the target size
        let widthRatio  = targetSize.width  / self.size.width
        let heightRatio = targetSize.height / self.size.height
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // Return the new image
        return newImage!
    }
    
    /**
     Convenience constructor used to draw a UIImage out of a UIView by rendering a layer over the view with the view being transparent (not opaque)
     - Parameter view: The UIView to draw for.
     - Parameter isOpaque: A Boolean value used to determine whether the views behind it should be black or not.
     • Usage: let image = UIImage(view: myView)
     */
    convenience init(view: UIView, isOpaque: Bool = false) {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, isOpaque, 0.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
    
    /**
     Convenience constructor used to draw a UIImage out of a UIView by drawing a hierarchy layer over it with the view being opaque.
     - Parameter screenshotView: The UIView to draw its hierarchy for.
     • Usage: let screenshotView = UIImage(screenshotView: myView).
     */
    convenience init(screenshotView: UIView) {
        UIGraphicsBeginImageContextWithOptions(screenshotView.frame.size, true, 0.0)
        screenshotView.drawHierarchy(in: screenshotView.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
    
    /**
     Create a UIImage out of a UILabel.
     - Parameter label: The UILabel to draw an image for.
     - Returns UIImage: Returns a UIImage value drawn with graphics.
     */
    func imageFromLabel(label: UILabel) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}



// MARK: - URL
extension URL {
    /**
     Returns a Data object from a given URL value. Typically used for video.
     - Parameter error: An Error object used to return if the url to data conversion failed.
     - Parameter data: An optional, Data object representing the URL value.
     */
    func getData(completionHandler: @escaping (_ error: Error?, _ data: Data?) -> ()) {
        do {
            // Cast the video url as a Data object
            let dataFromURL = try Data.init(contentsOf: self)
            // Pass the values in the completion handler
            completionHandler(nil, dataFromURL)
        } catch let error {
            print("URL extension method .getData failed with error: \(error.localizedDescription)")
            // Pass the values in the completion handler
            completionHandler(error, nil)
        }
    }
    
    /**
     Returns a new URL path from the documents directory. Us
     - Parameter pathComponent: A String value representing the file type (ie: "movie.mp4") to append to the file path.
     */
    static func new(_ pathComponent: String = "/movie.mp4") -> URL? {
        // MARK: - FileManager
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        
        // Setup the file type (movie)
        let fileURL = documentsURL?.appendingPathComponent(pathComponent)
        
        // Remove the file path if already exists
        if let fileURLPath = fileURL?.path {
            // Remove the file url path for creating this new setup
            unlink((fileURLPath as NSString).utf8String)
        }
        
        return fileURL
        
        //        // Create a temporary directory to store the edited video's URL
        //        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        //        let pathToMovie = documentsPath + "\(pathComponent)"
        //
        //        // Remove the path if it already exists
        //        unlink((pathToMovie as NSString).utf8String)
        //
        //        // Delegate where the new video should write to
        //        return URL.init(fileURLWithPath: pathToMovie)
    }
    
    /**
     Gets the video size from a URL.
     - Parameter url: A URL value representing the path to the video.
     */
    static func videoSize(_ url: URL) -> CGSize? {
        guard let track = AVAsset(url: url as URL).tracks(withMediaType: AVMediaType.video).first else {
            return nil
        }
        let size = track.naturalSize.applying(track.preferredTransform)
        return CGSize(width: abs(size.width), height: abs(size.height))
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





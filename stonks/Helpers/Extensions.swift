//
//  Extensions.swift
//  yousters-subs
//
//  Created by Ян Мелоян on 12.06.2020.
//  Copyright © 2020 molidl. All rights reserved.
//

import Foundation
import UIKit

extension NSRegularExpression {
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}


extension String {
    func split(by length: Int) -> [String] {
        var startIndex = self.startIndex
        var results = [Substring]()

        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            results.append(self[startIndex..<endIndex])
            startIndex = endIndex
        }

        return results.map { String($0) }
    }
    
    func emojiHash() -> String {
        // HashEmoji.txt is a line separated file of 256 emojis (1 per byte)
        guard let path = Bundle.main.path(forResource: "HashEmoji", ofType: "txt"),
            let emojiData = try? String(contentsOfFile: path, encoding: .utf8)
            else {
                return self
        }
        
        let emojis = emojiData.components(separatedBy: .newlines)
        
        var str = ""

        let length = Int(self.count / 4)
        let arr = self.split(by: length).map({String($0).data(using: .utf8)!})
        
        for elem in arr {
            var sum = 0
            for letter in elem {
                sum += Int(letter)
            }
            str.append(emojis[sum % 256])
        }
        
        return str
    }
}

extension URL {
    func absoluteStringByTrimmingQuery() -> String? {
        if var urlcomponents = URLComponents(url: self, resolvingAgainstBaseURL: false) {
            urlcomponents.query = nil
            return urlcomponents.string
        }
        return nil
    }
}

extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}

extension UIImage {
    
    func getImageURL(complition: @escaping (URL)->Void) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            let imgName = UUID().uuidString
            let documentDirectory = NSTemporaryDirectory()
            let localPath = documentDirectory.appending(imgName + ".jpg")
            
            let data = self.jpegData(compressionQuality: 0.8)! as NSData
            data.write(toFile: localPath, atomically: true)
            let photoURL = URL(fileURLWithPath: localPath)
            print(photoURL)
            
            DispatchQueue.main.async {
                complition(photoURL)
            }
        }
    }
}

extension String {

    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }

    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }

    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
}

extension NSMutableAttributedString {
    
    @discardableResult
    public func setAsLink(textToFind:String) -> Bool {

        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            
            //self.addAttribute(.link, value: linkURL, range: foundRange)
            self.addAttribute(.underlineStyle, value: 1, range: foundRange)
            self.addAttribute(.foregroundColor, value: UIColor.bgColor, range: foundRange)
            return true
        }
        return false
    }
}

extension UIStackView {
    func setBackgroundColor(color:UIColor, raduis:CGFloat = 0) {
        let bg = UIView()
        bg.backgroundColor = color
        addSubview(bg)
        bg.layer.cornerRadius = raduis
        bg.clipsToBounds = true
        bg.fillSuperview()
    }
}

extension Date {
    ///
    /// Provides a humanised date. For instance: 1 minute, 1 week ago, 3 months ago
    ///
    /// - Parameters:
    //      - numericDates: Set it to true to get "1 year ago", "1 month ago" or false if you prefer "Last year", "Last month"
    ///
    func timeAgo(numericDates:Bool) -> String {
        let calendar = Calendar.current
        let now = Date()
        let earliest = self < now ? self : now
        let latest =  self > now ? self : now
        
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfMonth, .month, .year, .second]
        let components: DateComponents = calendar.dateComponents(unitFlags, from: earliest, to: latest)

        if let year = components.year {
            if (year % 10 >= 5) {
                return "\(year) лет назад"
            }
            if (year % 10 >= 2) {
                return "\(year) года назад"
            } else if (year >= 1) {
                return numericDates ?  "1 год назад" : "В прошлом году"
            }
        }
        if let month = components.month {
            if (month % 10 >= 5) {
                return "\(month) месяцев назад"
            }
            if (month % 10 >= 2) {
                return "\(month) месяца назад"
            } else if (month % 10 >= 1) {
                return numericDates ? "1 месяц назад" : "В прошлом месяце"
            }
        }
        if let weekOfMonth = components.weekOfMonth {
            if (weekOfMonth % 10 >= 5) {
                return "\(weekOfMonth) недель назад"
            }
            if (weekOfMonth % 10 >= 2) {
                return "\(weekOfMonth) недели назад"
            } else if (weekOfMonth % 10 >= 1) {
                return numericDates ? "1 неделю назад" : "На прошлой неделе"
            }
        }
        if let day = components.day {
            if (day % 10 >= 5) {
                return "\(day) дней назад"
            }
            if (day % 10 >= 2) {
                return "\(day) дня назад"
            } else if (day % 10 >= 1) {
                return numericDates ? "1 день назад" : "Вчера"
            }
        }
        if let hour = components.hour {
            if (hour % 10 >= 5) {
                return "\(hour) часов назад"
            }
            if (hour % 10 >= 2) {
                return "\(hour) часа назад"
            } else if (hour % 10 >= 1) {
                return numericDates ? "1 час назад" : "Час назад"
            }
        }
        if let minute = components.minute {
            if (minute % 10 >= 5) {
                return "\(minute) минут назад"
            }
            if (minute % 10 >= 2) {
                return "\(minute) минуты назад"
            } else if (minute % 10 >= 1) {
                return numericDates ? "1 минуту назад" : "Минуту назад"
            }
        }
        if let second = components.second {
            if (second % 10 >= 5) {
                return "\(second) секунд назад"
            }
            if (second % 10 >= 3) {
                return "\(second) секунды назад"
            }
        }
        return "Только что"
    }
}

extension UIScrollView {

    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(x:0, y:childStartPoint.y,width: 1,height: self.frame.height), animated: animated)
        }
    }

    // Bonus: Scroll to top
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }

    // Bonus: Scroll to bottom
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }

}

extension UIViewController {
    func wrapInNavigationController(with title:String? = nil) -> UINavigationController {
        let nav = ToomyNavigationController(rootViewController: self)
        self.title = title
        
        return nav
    }
}

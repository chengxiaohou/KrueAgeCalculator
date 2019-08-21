

import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius:CGFloat {
        get{
            return self.layer.cornerRadius
        }set{
            self.layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderWidth:CGFloat{
        get{
            return self.layer.borderWidth
        }set{
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor:UIColor{
        get{
            return UIColor(cgColor: self.layer.borderColor ?? UIColor.white.cgColor)
        }set{
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    func addShadowView2(){
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 1
        self.layer.cornerRadius = 25
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.clipsToBounds = false
        self.layer.masksToBounds = false
    }
    
    func shake() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 12, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 12, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        
        layer.add(shake, forKey: "position")
    }
}

extension UIViewController {
    
    func getAlertController(title:String?, message:String?, callback:(()->(Void))? = nil) -> UIAlertController{
        
        var alertController:UIAlertController!
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            
            alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        }
        else{
            
            alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        }
        return alertController
    }
}

extension Date {
    
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}

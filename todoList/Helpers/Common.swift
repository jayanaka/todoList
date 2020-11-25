//
//  Common.swift
//  todoList
//
//  Copyright © 2020 Chathura Jayanaka. All rights reserved.
//

import UIKit
import SwiftMessages

class Common {
    static let themeColor = "#E66E72"
    
    // Message Type
    static let ErrorMessage = 1
    static let InfoMessage = 2
    static let WarningMessage = 3
    static let SuccessMessage = 4
    
    static func getDateValues() -> (String, String, String) {
        
        let calendar = Calendar.current
        let date = Date()
        let dateComponents = calendar.component(.day, from: date)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal
        let day = numberFormatter.string(from: dateComponents as NSNumber) ?? ""
        
        let dateFormatterMonth = DateFormatter()
        dateFormatterMonth.dateFormat = "LLLL"
        let month = dateFormatterMonth.string(from: date)

        let dateFormatterDate = DateFormatter()
        dateFormatterDate.dateFormat = "EEEE"
        let weekDay = dateFormatterDate.string(from: date)
        
        return (weekDay, day, month)
    }
    
    static func createAttributedStringBold(textNormal: String, textBold: String, fontSize: CGFloat) -> NSAttributedString {
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: fontSize)]
        let attributedString = NSMutableAttributedString(string: textBold, attributes: attrs)

        let normalString = NSMutableAttributedString(string: textNormal)

        attributedString.append(normalString)
        return attributedString
    }
    
    // Show Message - validation & Errors
      static func showMessage(type: Int, title: String, message: String) {
          if !message.isEmpty {
              //let error = MessageView.viewFromNib(layout: .cardView)
              let error = MessageView.viewFromNib(layout: .messageView)
              var config = SwiftMessages.defaultConfig
              config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
    
              switch type {
              case ErrorMessage:
                  error.configureTheme(.error)
                  error.configureContent(title: "Hey There!", body: "Please try swiping to dismiss this message.", iconImage: UIImage(named:"ic_warning.png"), iconText: "", buttonImage: nil, buttonTitle: "") { _ in
                     // SwiftMessages.hide()
                  }
                  error.titleLabel?.isHidden = true
                  
              case InfoMessage:
                  error.configureTheme(.info)
                  
              case WarningMessage:
                  error.configureTheme(.warning)
                  
              case SuccessMessage:
                  error.configureTheme(.success)
                  
              default:
                  error.configureTheme(.info)
              }
              
              error.configureContent(title: "", body: message)
              error.button?.setTitle("Stop", for: .normal)
              error.button?.isHidden = true
          
              SwiftMessages.show(config: config, view: error)
          }
      }

}

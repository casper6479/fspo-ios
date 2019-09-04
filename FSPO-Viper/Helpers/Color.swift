//
//  Color.swift
//  FSPO-Viper
//
//  Created by Николай Борисов on 07/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit

extension UIColor {
    static var ITMOBlue = UIColor(red: 25/255, green: 70/255, blue: 186/255, alpha: 1)
    static let backgroundGray = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
    static let ITMORed = UIColor(red: 236/255, green: 11/255, blue: 67/255, alpha: 1)
    static let whiteColor = UIColor.white
    static var mainColor = UIColor(red: 80/255, green: 58/255, blue: 226/255, alpha: 1)
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
//extension UIColor {
//    static let classInit: Void = {
//        let blackMehtod = class_getClassMethod(UIColor.self, #selector(getter: black))
//        let myBlackMethod = class_getClassMethod(UIColor.self, #selector(getter: myBlack))
//        method_exchangeImplementations(blackMehtod!, myBlackMethod!)
//
//        let whiteMethod = class_getClassMethod(UIColor.self, #selector(getter: white))
//        let myWhiteMethod = class_getClassMethod(UIColor.self, #selector(getter: myWhite))
//        method_exchangeImplementations(whiteMethod!, myWhiteMethod!)
//    }()
//    @objc open class var myBlack: UIColor {
//        print("black")
//        return UIColor(red: 1, green: 0, blue: 0)
//    }
//    @objc open class var myWhite: UIColor {
//        print("white")
//        return UIColor(red: 0, green: 0, blue: 0)
//    }
//}

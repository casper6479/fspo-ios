//
//  ToastExtension.swift
//  FSPO-Viper
//
//  Created by Николай Борисов on 26/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import UIKit

func showMessage(message: String, y: CGFloat) {
    let height = message.height(withConstrainedWidth: 200, font: UIFont(name: "ALSSchlangesans-Bold", size: 12.0)!)
    let yPosition = UINavigationController().navigationBar.frame.height + UIApplication.shared.statusBarFrame.height
    let toastLabel = UILabel(frame: CGRect(x: (UIApplication.shared.keyWindow?.frame.size.width)!/2 - 100, y: yPosition + y, width: 200, height: height + 16))
    toastLabel.numberOfLines = 0
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(1)
    toastLabel.textColor = UIColor.white
    toastLabel.textAlignment = .center
    toastLabel.font = UIFont(name: "ALSSchlangesans-Bold", size: 12.0)
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = toastLabel.frame.height / 2
    toastLabel.clipsToBounds  =  true
    UIApplication.shared.keyWindow?.addSubview(toastLabel)
    UIView.animate(withDuration: 4.0, delay: 1, options: .curveEaseOut, animations: {
        toastLabel.alpha = 0.0
    }, completion: { _ in
        toastLabel.removeFromSuperview()
    })
}

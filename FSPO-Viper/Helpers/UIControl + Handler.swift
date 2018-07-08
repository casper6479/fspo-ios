//
//  Control.swift
//  FSPO-Viper
//
//  Created by Николай Борисов on 08/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation
import UIKit

private var controlHandlerKey: Int8 = 0

extension UIControl {
    public func addHandler(for controlEvents: UIControlEvents, handler: @escaping (UIControl) -> Void) {

        let target = CocoaTarget<UIControl>(handler)
        objc_setAssociatedObject(self, &controlHandlerKey, target, .OBJC_ASSOCIATION_RETAIN)
        self.addTarget(target, action: #selector(target.sendNext), for: controlEvents)
    }
}

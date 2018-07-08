//
//  CocoaTarget.swift
//  FSPO-Viper
//
//  Created by Николай Борисов on 08/07/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation

internal final class CocoaTarget<Value>: NSObject {
    private let action: (Value) -> Void
    internal init(_ action: @escaping (Value) -> Void) {
        self.action = action
    }
    @objc internal func sendNext(_ receiver: Any?) {
        if let rec = receiver as? Value {
            action(rec)
        }
    }
}

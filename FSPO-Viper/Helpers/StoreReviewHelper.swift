//
//  BiometricLayout.swift
//  FSPO
//
//  Created by Николай Борисов on 07/09/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation
import StoreKit

struct StoreReviewHelper {
    static func incrementAppOpenedCount() {
        var appOpenCount = UserDefaults.standard.integer(forKey: "appOpenedCount")
        appOpenCount += 1
        UserDefaults.standard.set(appOpenCount, forKey: "appOpenedCount")
    }
    static func checkAndAskForReview() {
        let appOpenCount = UserDefaults.standard.integer(forKey: "appOpenedCount")
        switch appOpenCount {
        case 10, 50:
            StoreReviewHelper().requestReview()
        case _ where appOpenCount % 100 == 0 :
            StoreReviewHelper().requestReview()
        default:
            print("App run count is : \(appOpenCount)")
        }
    }
    fileprivate func requestReview() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        }
    }
}

//
//  Dictionary+JSON.swift
//  FSPO
//
//  Created by Николай Борисов on 12/03/2019.
//  Copyright © 2019 Николай Борисов. All rights reserved.
//

import UIKit

extension Dictionary {
    var jsonStringRepresentaiton: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,
                                                            options: [.prettyPrinted]) else {
                                                                return nil
        }
        return String(data: theJSONData, encoding: .utf8)
    }
}

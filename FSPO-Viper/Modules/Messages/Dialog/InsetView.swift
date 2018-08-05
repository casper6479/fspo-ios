//
//  InsetView.swift
//  FSPO-Viper
//
//  Created by Николай Борисов on 05/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Foundation
import UIKit

class InsetView: UIView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.2) {
            self.backgroundColor = self.backgroundColor?.withAlphaComponent(0.8)
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.2) {
            self.backgroundColor = self.backgroundColor?.withAlphaComponent(1)
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.2) {
            self.backgroundColor = self.backgroundColor?.withAlphaComponent(1)
        }
    }
}

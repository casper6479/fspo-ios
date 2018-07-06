//
//  NewsInterfaces.swift
//  FSPO-Viper
//
//  Created by Николай Борисов on 06/07/2018.
//  Copyright (c) 2018 Николай Борисов. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit

enum NewsNavigationOption {
}

protocol NewsWireframeInterface: WireframeInterface {
    func navigate(to option: NewsNavigationOption)
}

protocol NewsViewInterface: ViewInterface {
}

protocol NewsPresenterInterface: PresenterInterface {
}

protocol NewsInteractorInterface: InteractorInterface {
}
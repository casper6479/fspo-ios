//
//  Connectivity.swift
//  FSPO
//
//  Created by Николай Борисов on 15/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Alamofire

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

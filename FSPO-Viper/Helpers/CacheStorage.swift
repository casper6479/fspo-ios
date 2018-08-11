//
//  CacheStorage.swift
//  FSPO
//
//  Created by Николай Борисов on 10/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Cache

let diskConfig = DiskConfig(name: "FSPO", expiry: .never)
let memoryConfig = MemoryConfig(expiry: .never, countLimit: 150, totalCostLimit: 150)

let storage = try? Storage(
    diskConfig: diskConfig,
    memoryConfig: memoryConfig,
    transformer: TransformerFactory.forData()
)
func updateCache(with data: Data, forKey key: String) {
    storage?.async.setObject(
        data,
        forKey: key,
        expiry: .never,
        completion: { result in
            switch result {
            case .value:
                print("cache filled")
            case .error(let error):
                print("Error while updating cache: \(error)")
            }
    })
}
func clearCache(forKey key: String) {
    storage?.async.removeObject(forKey: key, completion: { result in
        switch result {
        case .value:
            print("cache cleared")
        case .error(let error):
            print("Error while clearing cache: \(error)")
        }
    })
}

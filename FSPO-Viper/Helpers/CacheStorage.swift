//
//  CacheStorage.swift
//  FSPO
//
//  Created by Николай Борисов on 10/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Cache
import FileProvider
import UIKit

let diskConfig = DiskConfig(name: "FSPO", expiry: .never)

let memoryConfig = MemoryConfig(expiry: .never, countLimit: 150, totalCostLimit: 150)

let storage = try? Storage(
    diskConfig: diskConfig,
    memoryConfig: memoryConfig,
    transformer: TransformerFactory.forData()
)

func updateCache(with data: Data, forKey key: String, expiry: Expiry) {
    storage?.async.setObject(
        data,
        forKey: key,
        expiry: expiry,
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
class ScheduleStorage {
    func setExludedFromBackup() {
        var url = try? FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true).appendingPathComponent("Schedule")
        var resuorceValues = URLResourceValues()
        resuorceValues.isExcludedFromBackup = true
        try? url?.setResourceValues(resuorceValues)
        print(try? url?.resourceValues(forKeys: [.isExcludedFromBackupKey]).isExcludedFromBackup)
    }
    let storage = try? DiskStorage(
        config: DiskConfig(
            name: "FSPO-Schedule",
            expiry: .seconds(604800),
            directory: try? FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true).appendingPathComponent("Schedule")),
        transformer: TransformerFactory.forData())
    func updateDisk(with data: Data, forKey key: String, expiry: Expiry) {
        try? storage?.setObject(data, forKey: key, expiry: expiry)
    }
    func clearDisk(forKey key: String) {
        try? storage?.removeObject(forKey: key)
    }
}

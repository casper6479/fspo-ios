//
//  Cache Helper.swift
//  TodaySchedule
//
//  Created by Николай Борисов on 13/08/2018.
//  Copyright © 2018 Николай Борисов. All rights reserved.
//

import Cache

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
    func updateDisk(with data: Data, forKey key: String) {
        try? storage?.setObject(data, forKey: key)
    }
    func clearDisk(forKey key: String) {
        try? storage?.removeObject(forKey: key)
    }
}

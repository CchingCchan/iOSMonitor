//
//  DeviceStatusApp.swift
//  DeviceStatus
//
//  Created by mac on 2024/1/8.
//

import SwiftUI

@main
struct DeviceStatusApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(MemoryUsageMonitor())
        }
    }
}

//
//  MemoryUsageMonitor.swift
//  DeviceStatus
//
//  Created by mac on 2024/1/8.
//

import SwiftUI

class MemoryUsageMonitor: ObservableObject {
    @Published var memoryUsage: Double = 0
    @Published var runTime: TimeInterval = 0.0
    @Published var codeBlackRunTime1: CGFloat = 0
    @Published var codeBlackRunTime2: CGFloat = 0
    @Published var codeBlackRunTime3: CGFloat = 0
    let fileURL = URL(fileURLWithPath: NSTemporaryDirectory().appending("performance_data.csv"))
    
    private var timer: Timer?
    
    init() {
        startMonitoring()
    }
    
    func startMonitoring() {
        DispatchQueue.global(qos: .background).async {
            while true {
                let usage = self.getMemoryUsage()
                DispatchQueue.main.async {
                    self.memoryUsage = Double(usage) / 1024.0 / 1024.0
                }
                sleep(1)
            }
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.runTime += 1.0
            self.writeDataToCSV()
        }
        codeBlock()
    }
    
    func writeDataToCSV() {
        
        let dataString = "\(Date().timeIntervalSince1970),\(memoryUsage),\(runTime),\(codeBlackRunTime1),\(codeBlackRunTime2),\(codeBlackRunTime3)\n"
        
        if let data = dataString.data(using: .utf8) {
            if FileManager.default.fileExists(atPath: fileURL.path) {
                if let fileHandle = try? FileHandle(forWritingTo: fileURL) {
                    fileHandle.seekToEndOfFile()
                    fileHandle.write(data)
                    fileHandle.closeFile()
                    print(fileURL)
                }
            } else {
                try? data.write(to: fileURL)
            }
        }
    }
    
    //    func writeDataToCSV() {
    //        let dataString = "\(Date().timeIntervalSince1970),\(memoryUsage),\(runTime),\(codeBlackRunTime1),\(codeBlackRunTime2),\(codeBlackRunTime3)\n"
    //
    //        if let data = dataString.data(using: .utf8) {
    //            if FileManager.default.fileExists(atPath: fileURL.path) {
    //                if let fileHandle = try? FileHandle(forWritingTo: fileURL) {
    //                    fileHandle.seekToEndOfFile()
    //                    fileHandle.write(data)
    //                    fileHandle.closeFile()
    //                    print("Data appended to existing CSV file.")
    //                }
    //            } else {
    //                do {
    //                    try data.write(to: fileURL)
    //                    print("Data exported to CSV file.")
    //                } catch {
    //                    print("Failed to write data to CSV file. Error: \(error.localizedDescription)")
    //                }
    //            }
    //        } else {
    //            print("Failed to convert data to UTF-8 encoding.")
    //        }
    //    }
    
    func exploreCSV() {
        let shareSheet = UIHostingController(rootView: ShareSheet(activityItems: [fileURL]))
        UIApplication.shared.windows.first?.rootViewController?.present(shareSheet, animated: true, completion: nil)
    }
    
    
    
    
    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }
    
    func getMemoryUsage() -> UInt64 {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info_data_t>.size) / 4
        
        let _ = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        
        return info.resident_size
    }
    
    func codeBlock() {
        codeBlockExecutionTime01()
        codeBlockExecutionTime02()
        codeBlockExecutionTime03()
    }
    
    func codeBlockExecutionTime01() {
        let startTime = DispatchTime.now()
        
        var sum = 0
        for i in 1...666666 {
            sum += i
        }
        
        let endTime = DispatchTime.now()
        let elapsedTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
        let timeInterval = Double(elapsedTime) / 1_000_000_000
        codeBlackRunTime1 = timeInterval
        print("Code block execution time: \(String(format: "%.2f", timeInterval)) s")
    }
    func codeBlockExecutionTime02() {
        let startTime = DispatchTime.now()
        
        var sum = 0
        for i in 1...444444 {
            sum += i
        }
        
        let endTime = DispatchTime.now()
        let elapsedTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
        let timeInterval = Double(elapsedTime) / 1_000_000_000
        codeBlackRunTime2 = timeInterval
        print("Code block execution time: \(String(format: "%.2f", timeInterval)) s")
    }
    func codeBlockExecutionTime03() {
        let startTime = DispatchTime.now()
        
        var sum = 0
        for i in 1...2222222 {
            sum += i
        }
        
        let endTime = DispatchTime.now()
        let elapsedTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
        let timeInterval = Double(elapsedTime) / 1_000_000_000
        codeBlackRunTime3 = timeInterval
        print("Code block execution time: \(String(format: "%.2f", timeInterval)) s")
    }
    
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to do here
    }
}

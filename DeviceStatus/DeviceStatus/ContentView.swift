//
//  ContentView.swift
//  DeviceStatus
//
//  Created by mac on 2024/1/8.
//

import SwiftUI
import SwiftUICharts

struct ContentView: View {
    @EnvironmentObject var memoryMonitor: MemoryUsageMonitor
    @State var memoryUsage:[Double] = []
    @State var appRunTime:[Double] = []
    
    var body: some View {
        VStack {
            Button {
                memoryMonitor.exploreCSV()
            } label: {
                Text("导出文件")
            }
            
            List {
                Section("内存占用情况"){
                    HStack{
                        Text("Memory Usage:")
                        Text("\(memoryMonitor.memoryUsage)")
                    }
                }
                Section("程序运行时间"){
                    HStack{
                        Text("App Run Time:")
                        Text(String(format: "%.0f", memoryMonitor.runTime) + "s")
                    }
                }
                Section("代码块执行时间"){
                    Text("\(memoryMonitor.codeBlackRunTime1)")
                    Text("\(memoryMonitor.codeBlackRunTime2)")
                    Text("\(memoryMonitor.codeBlackRunTime3)")
                }
                Section {
                    LineView(data: memoryUsage, title: "内存实时监控占用情况", legend: "Memory Usage")
                }
                .frame(height:400)
                Section {
                    LineView(data: appRunTime, title: "程序运行时间", legend: "App Run Time")
                }
                .frame(height:400)
                Section {
                    PieChartView(data: [memoryMonitor.codeBlackRunTime1,memoryMonitor.codeBlackRunTime2,memoryMonitor.codeBlackRunTime3], title: "代码块执行时间")
                }
                .frame(width: UIScreen.main.bounds.width,height:300)
            }
        }
        .onChange(of: memoryMonitor.memoryUsage) { newValue in
            memoryUsage.append(Double(newValue) )
        }
        .onChange(of: memoryMonitor.runTime) { newValue in
            appRunTime.append(Double(newValue) )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




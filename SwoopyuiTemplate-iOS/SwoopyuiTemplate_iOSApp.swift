//
// SwoopyUI entry app.

import SwiftUI
import PythonSupport
import SwoopyuiCore

@main
struct SwoopyuiTemplate_iOSApp: App {
    @State var swoopyuiPythonPort = 0 // The port will be generated by the python host.
    var body: some Scene {
        WindowGroup {
            if swoopyuiPythonPort == 0 {
                // if the port still not being generated, Then show a temporarily placeholder.
                HStack {
                    Text("Loading..")
                }.onAppear() {
                    let swoopyuiConnectfilePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("swoopyui_temp").appendingPathComponent("swoopyui_connect.txt")
                    
                    if FileManager.default.fileExists(atPath: swoopyuiConnectfilePath.path()) {
                        try! FileManager.default.removeItem(at: swoopyuiConnectfilePath)
                    }
                    
                    let pyhostThread = Thread {
                        startPythonSwoopyuiHost()
                    }
                    pyhostThread.start()
                    
                    while FileManager.default.fileExists(atPath: swoopyuiConnectfilePath.path()) == false {}
                    Thread.sleep(forTimeInterval: 0.3)
                    
                    swoopyuiPythonPort = Int(try! String(contentsOf: swoopyuiConnectfilePath))!
                }
            } else {
                // When the port is generated and python host is done starting, show the swoopyui app.
                SwoopyuiInitApp(hostPort: swoopyuiPythonPort)
            }
        }
    }
}

//
//  BluetoothUIApp.swift
//  BluetoothUI
//
//  Created by Ethan Hess on 3/3/26.
//

import SwiftUI

@main
struct BluetoothUIApp: App {
    
    //MARK: Systems thinking (app entry point)
    
    //MARK: Great for models like session / auth, navigation and app state that should be global.
    
    //If a view model will only be used by one view though it's generally better that view is the owner so in this case we could also move into content view instead of inject here
    
    let service = BLETileService()
    
    var body: some Scene {
        WindowGroup {
            ContentView(service: service)
        }
    }
}

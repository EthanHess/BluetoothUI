//
//  BluetoothUIApp.swift
//  BluetoothUI
//
//  Created by Ethan Hess on 3/3/26.
//

import SwiftUI

@main
struct BluetoothUIApp: App {
    
    //MARK: Systems thinking
    
    //MARK: Great for models like session / auth, navigation and app state that should be global.
    
    //If a view model will only be used by one view though it's generally better that view is the owner
    
    //Can move this into content view
    let service = BLETileService()
    
    var body: some Scene {
        WindowGroup {
            ContentView(service: service)
        }
    }
}

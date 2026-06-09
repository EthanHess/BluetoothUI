//
//  ImageCache.swift
//  BluetoothUI
//
//  Created by Ethan Hess on 4/14/26.
//

import SwiftUI

//MARK: AI suggestion (tracking tasks that are in flight)
//Preventing duplication

actor ImageCache {
    static let shared = ImageCache()
    
    private var storage: [String: Image] = [:]
    private var inFlight: [String: Task<Image?, Never>] = [:] //prevent duplicate requests

    //@escaping may be unecessary here, try without (or remove closure entirely)
    func imageForKey(for key: String, fetch: @escaping () async -> Image?) async -> Image? {
        if let cached = storage[key] { return cached }
            
        if let task = inFlight[key] { return await task.value }
            
        let task = Task {
            let result = await fetch()
            if let result { storage[key] = result }
            inFlight[key] = nil
            return result
        }
            
        inFlight[key] = task
        return await task.value
    }

    func clear() {
        storage.removeAll()
        inFlight.removeAll()
    }
}

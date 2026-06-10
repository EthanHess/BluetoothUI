//
//  BluetoothViewModel.swift
//  BluetoothUI
//
//  Created by Ethan Hess on 6/10/26.
//

import SwiftUI

@MainActor
@Observable
class BluetoothViewModel {
    var tiles : [BLETile] = []
    var loading = false
    
    private let service: BLETileService
    
    init(service: BLETileService) {
        self.service = service
    }
    
    func loadTiles() async {
        loading = true
        do {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            tiles = try await service.fetchJSON()
            loading = false
        } catch {
            //MARK: Present error UI in app state (like internet connections etc.)
            loading = false
        }
    }
}

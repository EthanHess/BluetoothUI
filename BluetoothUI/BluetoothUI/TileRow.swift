//
//  TileRow.swift
//  BluetoothUI
//
//  Created by Ethan Hess on 6/10/26.
//

import SwiftUI

struct TileRow : View {
    
    @State private var helper: RowHelper
    
    init(tile: BLETile, service: any RowProvider) {
        _helper = State(
            initialValue: RowHelper(tile: tile, service: service)
        )
    }
    
    @ViewBuilder
    private var content: some View {
        switch helper.loadState {
        case .idle, .loading:
            ProgressView()
        case .loaded(let image):
            image.resizable().frame(width: 25, height: 25)
        case .failed:
            Image(systemName: "xmark.circle")
        }
    }
    
    var body: some View {
        HStack {
            Text(helper.tile.itemType)
            content
        }.customBackground()
        .task(id: helper.tile.bluetoothID) {
            await helper.loadData()
        }
    }
}


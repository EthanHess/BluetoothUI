//
//  Models.swift
//  BluetoothUI
//
//  Created by Ethan Hess on 6/2/26.
//

//MARK: Data models

import UIKit


struct BLETile : Decodable, Identifiable {
    let id : UUID
    var bluetoothID : String
    var itemType : String
    
    enum CodingKeys: String, CodingKey {
        case bluetoothID
        case itemType
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.bluetoothID = try container.decode(String.self, forKey: .bluetoothID)
        self.itemType = try container.decode(String.self, forKey: .itemType)
        self.id = UUID()
    }
}

//
//  DataModel.swift
//  BluetoothUI
//
//  Created by Ethan Hess on 3/3/26.
//

import SwiftUI

//MARK: iOS 17+ way to do observe published data

//@DataActor //custom global actor ensuring thread safety

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

struct JSONFileWrapper: Decodable {
    let items: [BLETile] //tiles are nested in "items" key so can do this
}

protocol ServiceProtocol {
    func fetchTiles() async throws -> [BLETile]
}

//MARK: Notify some error service or give ViewModel error string in case of internet / request failure or whatever
final class BLETileService : ServiceProtocol {
    func fetchTiles() async throws -> [BLETile] {
        let (data, _) = try await URLSession.shared.data(from: API.tilesURL())
        return try JSONDecoder().decode([BLETile].self, from: data)
    }
    
    func fetchJSON() async throws -> [BLETile] {
        do {
            let data = try Data(contentsOf: API.jsonLocal())
            return try JSONDecoder().decode(JSONFileWrapper.self, from: data).items
        } catch {
            return []
        }
    }
}


//MARK: Move this
struct API {
    static func tilesURL() throws -> URL {
        guard let url = URL(string: "https://bleservice.com/tiles") else {
            throw URLError(.badURL)
        }
        return url
    }
    
    static func jsonLocal() throws -> URL {
        guard let url = Bundle.main.url(forResource: "Data", withExtension: "json") else {
            throw URLError(.badURL)
        }
        return url
    }
}





//MARK: Old stuff

struct Tile : Identifiable {
    var id = UUID()
    var bluetoothID : String
    var itemType : ItemType
    
    //MARK: TODO Add / observe current location (CLLocation)
}

enum ItemType: String, Codable {
    case shippingContainer
    case crate
    case box
    case trailer
    case truck
}


//MARK: If we wrap our network in this we'd want a middleman
@globalActor actor DataActor {
    static let shared = DataActor()
}




//MARK: May need to add this to bypass security

//<key>NSAppTransportSecurity</key>
//<dict>
//    <key>NSAllowsLocalNetworking</key>
//    <true/>
//</dict>


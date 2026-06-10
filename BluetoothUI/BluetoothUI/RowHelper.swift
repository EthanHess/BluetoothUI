//
//  RowHelper.swift
//  BluetoothUI
//
//  Created by Ethan Hess on 6/2/26.
//

import UIKit
import SwiftUI


@Observable
final class RowHelper {
    let tile: BLETile
    let service: any RowProvider
    
    private var isLoading = false //Prevent against duplicate calls
    
    var loadState: LoadState<Image> = .idle
    
    init(tile: BLETile, service: any RowProvider) {
        self.tile = tile
        self.service = service
    }
    
    func loadData() async {
        guard case .idle = loadState else { return }
        loadState = .loading

        let image = await service.fetchImage(id: tile.bluetoothID)

        //This is current context Task (like inside .task { } called on view)
        if Task.isCancelled { return }

        loadState = .loaded(image)
    }
}


//MARK: As of iOS + @Observable it can be useful to have a model for the whole list

struct RowService {
    func fetchDetailData(id: String) async throws -> String? {
        try? await Task.sleep(for: .milliseconds(500))
        if Bool.random() { throw NetworkError.failedRequest }
        return "Yo: \(id)"
    }
    
    func fetchImageData(id: String) async throws -> Image? {
        try? await Task.sleep(nanoseconds: 1_500_000_000)
        if Bool.random() { throw NetworkError.failedRequest }
        return Image("checkmark.circle")
    }
}

protocol RowProvider {
    func fetchDetail(id: String) async -> String
    func fetchImage(id: String) async -> Image
}

extension RowService : RowProvider {
    func fetchDetail(id: String) async -> String {
        do {
            return try await fetchDetailData(id: id) ?? ""
        } catch {
            return "Failed"
        }
    }

    func fetchImage(id: String) async -> Image {
        do {
            return try await fetchImageData(id: id) ?? Image(systemName: "questionmark.circle.fill")
        } catch {
            return Image(systemName: "questionmark.circle.fill")
        }
    }
}


//MARK: For Row VM (experimenting with generics)
enum LoadState<T> {
    case idle
    case loading
    case loaded(T) //Pass Image in this case, generics are useful if data is something else
    case failed
}

//MARK: For Row Service
enum NetworkError: Error {
    case failedRequest
    case internetTimeout
    case badResponse
    case decodingFailed
}


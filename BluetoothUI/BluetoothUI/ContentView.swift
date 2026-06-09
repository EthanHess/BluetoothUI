//
//  ContentView.swift
//  BluetoothUI
//
//  Created by Ethan Hess on 3/3/26.
//

import SwiftUI
import RealityKit
import MapKit

//MARK: Problems -> Solution

//MARK: Loading lots of items -> pagination

//MARK: Network calls firing more than once -> Task.cancel() (Especially true in tables, cache + cancel) (.task(id: ) can help too)

//MARK: Closures retain what they capture risking strong reference cycle -> weakify (only reference types)

//MARK: Loading lots of data initially -> Background thread or Task.detached { }

//MARK: Data races -> actors + @MainActor for UI updates

//MARK: UIViewRepresentable -> UIKit func. in SwiftUI


struct ContentView: View {
  
    @State private var bleViewModel : BluetoothViewModel
    
    //MARK: Service for row since "prepareForReuse" isn't a thing
    private let service = RowService()
    
    init(service: BLETileService) {
        _bleViewModel = State(initialValue: BluetoothViewModel(service: service))
    }
    
    //San Fran :) (TODO add MapView)
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.3317, longitude: -122.0325086),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        VStack {
            //More flexibility for custom layouts
            if bleViewModel.loading == true {
                ZStack {
                    RealityView { content in
                        let sceneItems = SatelliteFactory.createSatelliteScene()
                        for entity in sceneItems {
                            content.add(entity)
                        }
                    } update: { content in
                        
                    }
                }.background(
                    Color.black
                ).cornerRadius(10).customStyleShadow()
            } else {
                //More UI versatility in some cases but less functionality than a List
                //Lazy loads views as they come onscreen but not necessarily data
                ScrollView {
                    LazyVStack {
                        ForEach(bleViewModel.tiles) { tile in
                            TileRowVM(tile: tile, service: service).onAppear {
                                if tile.id == bleViewModel.tiles.last?.id {
                                    //MARK: TODO load more here
                                }
                            }
                        }
                    }.background(
                        Color.black
                    ).cornerRadius(5)
                }
            }
        }.task {
            await bleViewModel.loadTiles()
        }.background(
            Color.black
        )
        .padding()
    }
}

//MARK: Row view model example

struct TileRowVM : View {
    
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
            image.resizable()
        case .failed:
            Image(systemName: "xmark.circle")
        }
    }
    
    //MARK: Add to modifiers, this is ugly 
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






//Better to just delete this?
#Preview {
    ContentView(service: BLETileService())
}




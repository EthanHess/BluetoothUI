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
    
    //MARK: Service for row since UIKit "prepareForReuse" isn't a thing in SwiftUI, that logic will be handled elsewhere
    
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
                            TileRow(tile: tile, service: service).onAppear {
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


#Preview {
    ContentView(service: BLETileService())
}




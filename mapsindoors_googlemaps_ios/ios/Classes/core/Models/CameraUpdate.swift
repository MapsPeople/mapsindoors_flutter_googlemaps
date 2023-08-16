//
//  CameraUpdate.swift
//  mapsindoors_googlemaps_ios
//
//  Created by Tim Mikkelsen on 26/07/2023.
//

import MapsIndoors

//Internal structs used to decode the camera json above
struct CameraUpdate: Codable {
    let position: CameraPosition?
    let mode: String
    let point: MPPoint?
    let bounds: MPGeoBounds?
    let padding: Int?
    let width: Int?
    let height: Int?
    let zoom: Float?
}

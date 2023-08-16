//
//  CameraPosition.swift
//  mapsindoors_googlemaps_ios
//
//  Created by Tim Mikkelsen on 26/07/2023.
//
import MapsIndoors

struct CameraPosition: Codable {
    let zoom: Float
    let tilt: Float
    let bearing: Float
    let target: MPPoint
}

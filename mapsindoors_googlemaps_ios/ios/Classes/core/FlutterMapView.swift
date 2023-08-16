//
//  FlutterMapView.swift
//  mapsindoors_googlemaps_ios
//
//  Created by Tim Mikkelsen on 26/07/2023.
//

import MapsIndoors


protocol FlutterMapView {
    func animateCamera(cameraUpdate: CameraUpdate, duration: Int) throws
    func moveCamera(cameraUpdate: CameraUpdate) throws
}

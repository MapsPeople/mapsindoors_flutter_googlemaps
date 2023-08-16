//
//  DirectionsRendererListenerMethodChannel.swift
//  mapsindoors_ios
//
//  Created by Martin Hansen on 21/02/2023.
//

import Foundation
import Flutter
import UIKit
import MapsIndoors
import MapsIndoorsCodable

public class DirectionsRendererMethodChannel: NSObject {
    
    static var isListeningForLegChanges: Bool = false

    enum Methods: String {
        case DRE_clear
        case DRE_getSelectedLegFloorIndex
        case DRE_nextLeg
        case DRE_previousLeg
        case DRE_selectLegIndex
        case DRE_setAnimatedPolyline
        case DRE_setCameraAnimationDuration
        case DRE_setCameraViewFitMode
        case DRE_setOnLegSelectedListener
        case DRE_setPolyLineColors
        case DRE_setRoute
        case DRE_useContentOfNearbyLocations
        
        func call(arguments: [String: Any]?, mapsIndoorsData: MapsIndoorsData, result: @escaping FlutterResult) {
            let runner: (_ arguments: [String: Any]?, _ mapsIndoorsData: MapsIndoorsData, _ result: @escaping FlutterResult) -> Void
            
            if (mapsIndoorsData.mapControl != nil && mapsIndoorsData.directionsRenderer == nil) {
                mapsIndoorsData.directionsRenderer = mapsIndoorsData.mapControl?.newDirectionsRenderer()
            }
            
            switch self {
            case .DRE_clear:                            runner = clear
            case .DRE_getSelectedLegFloorIndex:         runner = getSelectedLegFloorIndex
            case .DRE_nextLeg:                          runner = nextLeg
            case .DRE_previousLeg:                      runner = previousLeg
            case .DRE_selectLegIndex:                   runner = selectLegIndex
            case .DRE_setAnimatedPolyline:              runner = setAnimatedPolyline
            case .DRE_setCameraAnimationDuration:       runner = setCameraAnimationDuration
            case .DRE_setCameraViewFitMode:             runner = setCameraViewFitMode
            case .DRE_setOnLegSelectedListener:         runner = setOnLegSelectedListener
            case .DRE_setPolyLineColors:                runner = setPolyLineColors
            case .DRE_setRoute:                         runner = setRoute
            case .DRE_useContentOfNearbyLocations:      runner = useContentOfNearbyLocations
            }
            
            runner(arguments, mapsIndoorsData, result)
        }
                
        func clear(arguments: [String: Any]?, mapsIndoorsData: MapsIndoorsData, result: @escaping FlutterResult) {
            mapsIndoorsData.directionsRenderer?.clear()
            
            result(nil)
        }
        
        func getSelectedLegFloorIndex(arguments: [String: Any]?, mapsIndoorsData: MapsIndoorsData, result: @escaping FlutterResult) {
            let legIndex = mapsIndoorsData.directionsRenderer?.routeLegIndex
            if (legIndex != nil) {
                result(mapsIndoorsData.directionsRenderer?.route?.legs[legIndex!].end_location.zLevel.int32Value)
            }
            
            result(nil)
        }
        
        func nextLeg(arguments: [String: Any]?, mapsIndoorsData: MapsIndoorsData, result: @escaping FlutterResult) {
            guard let renderer = mapsIndoorsData.directionsRenderer else {
                result(FlutterError(code: "Unable to change leg: The directionsRenderer is not set", message: "DRE_nextLeg", details: nil))
            
                return
            }
            let success = renderer.nextLeg()
            
            renderer.animate(duration: 5)

            if (DirectionsRendererMethodChannel.isListeningForLegChanges) {
                mapsIndoorsData.directionsRendererMethodChannel?.invokeMethod("onLegSelected", arguments: renderer.routeLegIndex)
            }

            result(nil)
        }
        
        func previousLeg(arguments: [String: Any]?, mapsIndoorsData: MapsIndoorsData, result: @escaping FlutterResult) {
            guard let renderer = mapsIndoorsData.directionsRenderer else {
                result(FlutterError(code: "Unable to change leg: The directionsRenderer is not set", message: "DRE_previousLeg", details: nil))
                return
            }
            let success = renderer.previousLeg()
            
            renderer.animate(duration: 5)

            if (DirectionsRendererMethodChannel.isListeningForLegChanges) {
                mapsIndoorsData.directionsRendererMethodChannel?.invokeMethod("onLegSelected", arguments: renderer.routeLegIndex)
            }
            
            result(nil)
        }
        
        func selectLegIndex(arguments: [String: Any]?, mapsIndoorsData: MapsIndoorsData, result: @escaping FlutterResult) {
            guard let args = arguments else {
                result(FlutterError(code: "Initialized called without arguments", message: "DRE_selectLegIndex", details: nil))
                return
            }
            
            guard let legIndex = args["legIndex"] as? Int else {
                result(FlutterError(code: "Could not initialise MapsIndoors", message: "DRE_selectLegIndex", details: nil))
                return
            }
            
            guard let renderer = mapsIndoorsData.directionsRenderer else {
                result(FlutterError(code: "Unable to select leg: The directionsRenderer is not set", message: "DRE_selectLegIndex", details: nil))
                return
            }
            
            guard let route = mapsIndoorsData.directionsRenderer!.route else {
                result(FlutterError(code: "No route set", message: "DRE_selectLegIndex", details: nil))
                return
            }
            
            guard legIndex >= 0 else {
                result(nil)
                return
            }

            guard legIndex < (route.legs.count) else {
                result(nil)
                return
            }


            renderer.routeLegIndex = legIndex
            
            renderer.animate(duration: 5)


            if (DirectionsRendererMethodChannel.isListeningForLegChanges) {
                mapsIndoorsData.directionsRendererMethodChannel?.invokeMethod("onLegSelected", arguments: renderer.routeLegIndex)
            }
            
            result(nil)
        }
        
        func setAnimatedPolyline(arguments: [String: Any]?, mapsIndoorsData: MapsIndoorsData, result: @escaping FlutterResult) {
            guard let args = arguments else {
                result(FlutterError(code: "Initialized called without arguments", message: "DRE_setAnimatedPolyline", details: nil))
                return
            }
            
            guard let durationMs = args["durationMs"] as? Int else {
                result(FlutterError(code: "Could not initialise MapsIndoors", message: "DRE_setAnimatedPolyline", details: nil))
                return
            }
            
            mapsIndoorsData.directionsRenderer?.animate(duration: TimeInterval(durationMs))
            result(nil)
        }
        
        func setCameraAnimationDuration(arguments: [String: Any]?, mapsIndoorsData: MapsIndoorsData, result: @escaping FlutterResult) {
            result(nil)
        }
        
        func setCameraViewFitMode(arguments: [String: Any]?, mapsIndoorsData: MapsIndoorsData, result: @escaping FlutterResult) {
            guard let args = arguments else {
                result(FlutterError(code: "Initialized called without arguments", message: "DRE_setCameraViewFitMode", details: nil))
                return
            }
            
            guard let cameraFit = args["cameraFitMode"] as? Int else {
                result(FlutterError(code: "Could not initialise MapsIndoors", message: "DRE_setCameraViewFitMode", details: nil))
                return
            }
            let cameraFitMode = MPCameraViewFitMode(rawValue: cameraFit)
            if (cameraFitMode != nil) {
                mapsIndoorsData.directionsRenderer?.fitMode = cameraFitMode!
            }
            
            result(nil)
        }
        
        func setOnLegSelectedListener(arguments: [String: Any]?, mapsIndoorsData: MapsIndoorsData, result: @escaping FlutterResult) {
            DirectionsRendererMethodChannel.isListeningForLegChanges = true
            
            result(nil)
        }
        
        func setPolyLineColors(arguments: [String: Any]?, mapsIndoorsData: MapsIndoorsData, result: @escaping FlutterResult) {
            guard let args = arguments else {
                result(FlutterError(code: "Initialized called without arguments", message: "DRE_setPolyLineColors", details: nil))
                return
            }
            
            guard let color = args["foreground"] as? String else {
                result(FlutterError(code: "Could not initialise MapsIndoors", message: "DRE_setPolyLineColors", details: nil))
                return
            }
            
            let regex = try! NSRegularExpression(pattern: "^#[0-9A-Fa-f]{6}$|^#[0-9A-Fa-f]{8}$")
            let range = NSRange(location: 0, length: color.utf16.count)

            if (regex.matches(in: color, range: range).count == 1) {
                mapsIndoorsData.directionsRenderer?.pathColor = UIColor(fromHexString: color)!
            } else {
                result(FlutterError(code: "Color is not a hex color", message: "DRE_setPolyLineColors", details: nil))
            }
            
            result(nil)
        }
        
        func setRoute(arguments: [String: Any]?, mapsIndoorsData: MapsIndoorsData, result: @escaping FlutterResult) {
            guard let args = arguments else {
                result(FlutterError(code: "Initialized called without arguments", message: "DRE_setRoute", details: nil))
                return
            }
            
            guard let routeJson = args["route"] as? String else {
                result(FlutterError(code: "Could not initialise MapsIndoors", message: "DRE_setRoute", details: nil))
                return
            }
            
            do {
                let route = try JSONDecoder().decode(MPRouteCodable.self, from: Data(routeJson.utf8))
                mapsIndoorsData.directionsRenderer?.route = route
                mapsIndoorsData.directionsRenderer?.routeLegIndex = 0
                mapsIndoorsData.directionsRenderer?.animate(duration: 5)
            }
            catch {
                result(FlutterError(code: "Could not initialise MapsIndoors", message: error.localizedDescription, details: nil))
                return
            }
            
            result(nil)
        }
        
        func useContentOfNearbyLocations(arguments: [String: Any]?, mapsIndoorsData: MapsIndoorsData, result: @escaping FlutterResult) {
            result(nil)
        }
    }
    
}

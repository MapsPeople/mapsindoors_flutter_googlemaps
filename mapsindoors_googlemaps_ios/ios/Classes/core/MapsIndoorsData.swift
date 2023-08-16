//
//  MapsIndoorsData.swift
//  mapsindoors_ios
//
//  Created by Martin Hansen on 21/02/2023.

import Foundation
import UIKit
import MapsIndoors
import MapsIndoorsCore
import Flutter
import MapsIndoorsCodable

protocol MapsIndoorsReadyDelegate: AnyObject {
    func isReady(error: MPError?)
}

protocol LiveDataDelegate: AnyObject {
    func dataReceived(liveUpdate: MPLiveUpdate)
}

public class MapsIndoorsData: NSObject {
    
    private var _mapView: FlutterMapView? = nil
    private var _mapControl: MPMapControl? = nil
    private var _mapControlMethodChannel: FlutterMethodChannel? = nil
    private var _mapControlFloorSelector: FlutterMethodChannel? = nil
    private var _mapsIndoorsMethodChannel: FlutterMethodChannel? = nil
    private var _directionsRendererMethodChannel: FlutterMethodChannel? = nil
    private var _positionProvider: FlutterPositionProvider? = nil
    private var _directionsRenderer: MPDirectionsRenderer? = nil
    private var _floorSelector: CustomFloorSelector? = nil
    
    var delegate: [MapsIndoorsReadyDelegate] = []
    
    var liveDataDelegate: LiveDataDelegate?
    
    var mapControlListenerDelegate: MapControlDelegate?
    
    var mapView: FlutterMapView? {
        set { _mapView = newValue }
        get { return _mapView }
    }

    var mapControl: MPMapControl? {
        set { _mapControl = newValue }
        get { return _mapControl }
    }
    
    var isMapControlInitialized: Bool {
        get { return _mapControl == nil }
    }
    
    var isMapsIndoorsReady: Bool {
        get { return MPMapsIndoors.shared.ready }
    }
    
    func mapsIndoorsReady(error: MPError?) {
        delegate.forEach { onReady in
            onReady.isReady(error: error)
        }
    }
    
    var mapControlMethodChannel: FlutterMethodChannel? {
        set { _mapControlMethodChannel = newValue }
        get { return _mapControlMethodChannel }
    }
    
    var directionsRendererMethodChannel: FlutterMethodChannel? {
        set { _directionsRendererMethodChannel = newValue }
        get { return _directionsRendererMethodChannel }
    }

    var mapsIndoorsMethodChannel: FlutterMethodChannel? {
        set { _mapsIndoorsMethodChannel = newValue }
        get { return _mapsIndoorsMethodChannel }
    }
    
    var mapControlFloorSelector: FlutterMethodChannel? {
        set { _mapControlFloorSelector = newValue }
        get { return _mapControlFloorSelector }
    }
    
    var positionProvider: FlutterPositionProvider? {
        set { _positionProvider = newValue }
        get { return _positionProvider }
    }
    
    var directionsRenderer: MPDirectionsRenderer? {
        set { _directionsRenderer = newValue }
        get { return _directionsRenderer }
    }
    
    var floorSelector: MPCustomFloorSelector? {
        set { _floorSelector = newValue as? CustomFloorSelector }
        get { return _floorSelector }
    }
}

public class CustomFloorSelector: UIView, MPCustomFloorSelector {
    public var isAutoFloorChangeEnabled = true
    
    public var methodChannel: FlutterMethodChannel? = nil
    
    public var building: MapsIndoors.MPBuilding?
    
    public var delegate: MapsIndoors.MPFloorSelectorDelegate?
    
    public var floorIndex: NSNumber?
    
    init(isAutoFloorChangeEnabled: Bool = true, methodChannel: FlutterMethodChannel) {
        super.init(frame: CGRect())
        self.methodChannel = methodChannel
        self.isAutoFloorChangeEnabled = isAutoFloorChangeEnabled
        self.delegate = FloorSelectorDelegate(floorSelector: self)
    }
    
    required init?(coder: NSCoder) {
        super.init(frame: CGRect())
    }
    
    public func onShow() {
        if (building != nil) {
            var floors = building?.floors?.values.map {MPFloorCodable(withFloor: $0)}
            let jsonData = try! JSONEncoder().encode(floors)
            let resultJson = String(data: jsonData, encoding: String.Encoding.utf8)
            
            methodChannel?.invokeMethod("setList", arguments: resultJson)
        }
        let map = ["show": true]
        methodChannel?.invokeMethod("show", arguments: map)
    }
    
    public func onHide() {
        let map = ["show": false]
        methodChannel?.invokeMethod("show", arguments: map)
    }
    
    public func onUserPositionFloorChange(floorIndex: Int) {
        methodChannel?.invokeMethod("setUserPositionFloor", arguments: floorIndex)
    }
}

public class FloorSelectorDelegate: MPFloorSelectorDelegate {
    private var customFloorSelector: CustomFloorSelector
    
    init(floorSelector: CustomFloorSelector) {
        customFloorSelector = floorSelector
    }
    
    public func onFloorIndexChanged(_ floorIndex: NSNumber) {
        if (customFloorSelector.isAutoFloorChangeEnabled) {
            customFloorSelector.floorIndex = floorIndex
        }
    }
}

public class FlutterPositionProvider: MPPositionProvider {
    public var latestPosition: MapsIndoors.MPPositionResult?
    
    public var name = "default"
    public var delegate: MapsIndoors.MPPositionProviderDelegate?
    public var mapsIndoorsData: MapsIndoorsData?
        
    public func setLatestPosition(positionResult: MPPositionResult) {
        if (latestPosition?.floorIndex != positionResult.floorIndex) {
            let floorSelector = mapsIndoorsData?.floorSelector as? CustomFloorSelector
            floorSelector?.onUserPositionFloorChange(floorIndex: positionResult.floorIndex)
        }
        
        delegate?.onPositionUpdate(position: positionResult)
        latestPosition = positionResult
    }
}

public class MapControlLiveDataDelegate: LiveDataDelegate {
    var methodChannel: FlutterMethodChannel? = nil
    
    init(methodChannel: FlutterMethodChannel) {
        self.methodChannel = methodChannel
    }
    
    func dataReceived(liveUpdate: MapsIndoors.MPLiveUpdate) {
        let domain = liveUpdate.topic.domainType
        let location = MPMapsIndoors.shared.locationWith(locationId: liveUpdate.itemId)
        if (location != nil && domain != nil) {
            let locationData = try? JSONEncoder().encode(MPLocationCodable(withLocation: location!))
            if (locationData != nil) {
                let locationString = String(data: locationData!, encoding: String.Encoding.utf8)
                let map = ["location": locationString, "domainType": domain]
                methodChannel?.invokeMethod("onLiveLocationUpdate", arguments: map)
            }
        }
    }
}

public class MapControlDelegate: MPMapControlDelegate {
    var methodChannel: FlutterMethodChannel
    
    var respondToTap: Bool = false
    var consumeTap: Bool = false
    
    var respondToTapIcon: Bool = false
    var consumeTapIcon: Bool = false
    
    var respondToDidChangeFloorIndex: Bool = false
    
    var respondToDidChangeBuilding: Bool = false
    
    var respondToDidChangeVenue: Bool = false
    
    var respondToDidChangeLocation: Bool = false
    var consumeChangeLocation: Bool = false
    
    var respondToDidTapInfoWindow: Bool = false
    
    init(methodChannel: FlutterMethodChannel) {
        self.methodChannel = methodChannel
    }
    
    public func didTap(coordinate: MPPoint) -> Bool {
        if (respondToTap) {
            var map = [String: Any?]()
            let pointData = try? JSONEncoder().encode(coordinate)
            if (pointData != nil) {
                map["point"] = String(data: pointData!, encoding: String.Encoding.utf8)
            }
            methodChannel.invokeMethod("onMapClick", arguments: map)
            return consumeTap
        }else {
            return false
        }
    }
    
    public func didTapIcon(location: MPLocation) -> Bool {
        if (respondToTapIcon) {
            methodChannel.invokeMethod("onMarkerClick", arguments: location.locationId)
            return consumeTapIcon
        }else {
            return false
        }
    }
    
    public func didChange(floorIndex: Int) -> Bool {
        if (respondToDidChangeFloorIndex) {
            var map = [String: Any]()
            map["floor"] = floorIndex
            methodChannel.invokeMethod("onFloorUpdate", arguments: map)
        }
        return false
    }
    
    public func didChange(selectedVenue: MPVenue?) -> Bool {
        if (respondToDidChangeVenue) {
            var venueString: String? = nil
            if (selectedVenue != nil) {
                let venueData = try? JSONEncoder().encode(MPVenueCodable(withVenue: selectedVenue!))
                if (venueData != nil) {
                    venueString = String(data: venueData!, encoding: String.Encoding.utf8)
                }
            }
            methodChannel.invokeMethod("onVenueFoundAtCameraTarget", arguments: venueString)
        }
        return false
    }
    
    public func didChange(selectedBuilding: MPBuilding?) -> Bool {
        if (respondToDidChangeBuilding) {
            var buildingString: String? = nil
            if (selectedBuilding != nil) {
                let buildingData = try? JSONEncoder().encode(MPBuildingCodable(withBuilding: selectedBuilding!))
                if (buildingData != nil) {
                    buildingString = String(data: buildingData!, encoding: String.Encoding.utf8)
                }
            }
            methodChannel.invokeMethod("onBuildingFoundAtCameraTarget", arguments: buildingString)
        }
        return false
    }
    
    public func didChange(selectedLocation: MPLocation?) -> Bool {
        if (respondToDidChangeLocation) {
            var locationString: String? = nil
            if (selectedLocation != nil) {
                let locationData = try? JSONEncoder().encode(MPLocationCodable(withLocation: selectedLocation!))
                if (locationData != nil) {
                    locationString = String(data: locationData!, encoding: String.Encoding.utf8)
                }
            }
            methodChannel.invokeMethod("onLocationSelected", arguments: locationString)
        }
        return false
    }
    
    public func didTapInfoWindow(location: MPLocation) -> Bool {
        if (respondToDidTapInfoWindow) {
            methodChannel.invokeMethod("onInfoWindowClick", arguments: location.locationId)
        }
        return false
    }
}

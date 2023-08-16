import Flutter
import GoogleMaps
import MapsIndoors
import MapsIndoorsCore

class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    private var mapsIndoorsData: MapsIndoorsData

    init(
        messenger: FlutterBinaryMessenger,
        mapsIndoorsData: MapsIndoorsData
    ) {
        self.messenger = messenger
        self.mapsIndoorsData = mapsIndoorsData
        super.init()
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
          return FlutterStandardMessageCodec.sharedInstance()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FLNativeView(
            frame: frame,
            arguments: args,
            binaryMessenger: messenger,
            mapsIndoorsData: mapsIndoorsData)
    }
}

class FLNativeView: NSObject, FlutterPlatformView, MPMapControlDelegate, FlutterMapView {
    
    private var _GMSView: GMSMapView?
    private let MP_APIKEY = "mapspeople"
    private var mapsIndoorsData: MapsIndoorsData? = nil
    private var args: Any? = nil

    init(
        frame: CGRect,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?,
        mapsIndoorsData: MapsIndoorsData
    ) {
        super.init()

        self.args = args
        self.mapsIndoorsData = mapsIndoorsData;
        _GMSView = GMSMapView.init(frame: frame, camera: GMSCameraPosition())

        if (MPMapsIndoors.shared.ready) {
            mapsIndoorsIsReady()
        }else {
            mapsIndoorsData.delegate.append(MIReadyDelegate(view: self))
        }
        
        mapsIndoorsData.mapView = self
        // To fix an odd bug, where the map center would be in the top left corner of the view.
        // It should be the center of the view.
        _GMSView?.moveCamera(GMSCameraUpdate.setCamera(GMSCameraPosition()))
    }

    func view() -> UIView {
        return _GMSView!
    }
    
    func mapsIndoorsIsReady() {
        if (mapsIndoorsData?.mapView != nil) {
            DispatchQueue.main.async { [self] in
                let config = MPMapConfig.init(gmsMapView: _GMSView!, googleApiKey: "")
                let mapControl = MPMapsIndoors.createMapControl(mapConfig: config)
                if (mapControl != nil) {
                    //TODO: parse config
                    mapControl?.showUserPosition = true
                    //pretend config^
                    mapsIndoorsData!.mapControl = mapControl
                    
                    mapsIndoorsData!.mapControlMethodChannel?.invokeMethod("create", arguments: nil)
                    
                    mapsIndoorsData?.directionsRenderer = nil
                }else {
                    mapsIndoorsData!.mapControlMethodChannel?.invokeMethod("create", arguments: MPError.unknownError)
                }
            }
        }
    }
    
    func animateCamera(cameraUpdate: CameraUpdate, duration: Int) throws {
        guard let update = makeGMSCameraUpdate(cameraUpdate: cameraUpdate) else {
            throw MPError.unknownError
        }
        _GMSView?.animate(with: update)
    }
    
    func moveCamera(cameraUpdate: CameraUpdate) throws {
        guard let update = makeGMSCameraUpdate(cameraUpdate: cameraUpdate) else {
            throw MPError.unknownError
        }
        _GMSView?.moveCamera(update)
    }
    
    func makeGMSCameraUpdate(cameraUpdate: CameraUpdate) -> GMSCameraUpdate? {
        let update: GMSCameraUpdate
        
        switch cameraUpdate.mode {
        case "fromPoint":
            guard let point = cameraUpdate.point else {
                return nil
            }
            update = GMSCameraUpdate.setTarget(point.coordinate)
        case "fromBounds":
            guard let bounds = cameraUpdate.bounds else {
                return nil
            }
            update = GMSCameraUpdate.fit(GMSCoordinateBounds(coordinate: bounds.northEast, coordinate: bounds.southWest), withPadding: CGFloat(integerLiteral: cameraUpdate.padding!))
        case "zoomBy":
            update = (GMSCameraUpdate.zoom(by: cameraUpdate.zoom!))
        case "zoomTo":
            update = (GMSCameraUpdate.zoom(to: cameraUpdate.zoom!))
        case "fromCameraPosition":
            guard let position = cameraUpdate.position else {
                return nil
            }
            update = (GMSCameraUpdate.setCamera(GMSCameraPosition(latitude: CLLocationDegrees(cameraUpdate.position!.target.latitude), longitude: CLLocationDegrees(position.target.longitude), zoom: position.zoom, bearing: CLLocationDirection(floatLiteral: Double(position.bearing)), viewingAngle: Double(position.tilt)) ))
        default:
            return nil
        }
        
        return update
    }
}

class MIReadyDelegate: MapsIndoorsReadyDelegate {
    let view: FLNativeView
    
    init(view: FLNativeView) {
        self.view = view
    }
    
    func isReady(error: MPError?) {
        if (error == MPError.invalidApiKey || error == MPError.networkError || error == MPError.unknownError ) {
            //TODO: Do nothing i guees?
        }else {
            view.mapsIndoorsIsReady()
        }
    }
}

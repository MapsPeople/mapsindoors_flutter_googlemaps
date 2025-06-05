# ReadMe

A federated Flutter plugin for integrating with the native MapsIndoors SDK.

| Platform     | Android | iOS   |
| ------------ | ------- | ----- |
| **Supports** | SDK 21+ | 14.0+ |

## Features

Use this plugin to:

- Show indoor mapping and navigation.
- Perform real-time wayfinding.
- See location live updates.
​
This plugin is based on the MapsIndoors V4 SDK for Android and iOS.

## Getting Started
​
Add MapsIndoors to your `pubspec.yaml`.
​
```yaml
mapsindoors_googlemaps: ^4.2.1
```

### Android

#### Android Google Maps Setup

To get the underlying Google Map to function, you need to perform the following steps:
​
1. Navigate to `android/app/src/main/res/value`.
2. Create a file in this folder called `google_maps_api_key.xml`.
3. Copy and paste the below code snippet and replace `YOUR_KEY_HERE` with your Google Maps API key.

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="google_maps_key">YOUR_KEY_HERE</string>
</resources>
```

#### MapsIndoors Gradle Setup

To ensure the plugin is able to resolve its MapsIndoors Gradle dependency, do the following:

1. Navigate to the app's project level `build.gradle`.
2. add `maven { url 'https://maven.mapsindoors.com/' }` to `allprojects`/`repositories` after `mavenCentral()`
​
```groovy
allprojects {
    repositories {
        google()
        mavenCentral()
        maven { url 'https://maven.mapsindoors.com/' }
    }
}
```
### iOS

#### iOS Google Maps Setup

To get the underlying Google Map to function, you need to perform the following steps:

#### Providing API key

1. Get an API key for Google Maps as described here: [Getting an API Key](https://developers.google.com/maps/documentation/ios-sdk/get-api-key)
2. Navigate to `iOS/Runner/Info.plist`.
3. Add a new key named "GoogleMapsAPIKey" with your Google Maps API key as content.

## Usage

This section has examples of code for the following tasks:

- [Showing your Map](#showing-your-map)
- [Showing a Route](#showing-a-route)
- [Searching Locations](#searching-locations)
- [Changing the look with DisplayRules](#changing-the-look-with-displayrules)
<!-- * [Adding a Position Provider](#adding-a-position-provider) -->

### Showing your Map

This snippet shows how to set up `MapsIndoors` in a Flutter application. First, the `MapsIndoorsWidget` is added to the application's build tree.
​
Optionally we can add a `MPFloorSelector` to the map. Here we use `MPDefaultFloorSelector` as it is provided with the MapsIndoors package. The selector must be added both to the build tree as well as to `MapControl` in order to function correctly.
​
Once `initState()` has been called, `MapsIndoors` begins initialization, and once that is done successfully, `MapControl` begins initialization.
​
Once `MapControl` is initialized we can invoke the `goTo` method to move the camera to the default venue.

```Dart
import 'package:mapsindoors/mapsindoors.dart' as MapsIndoors;
import 'package:mapsindoors/mapsindoors_library.dart';

void main() {
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
        return const MaterialApp(
            // replace the string with your own api key
            home: MapWidget("demo"),
        );
    }
}

class MapWidget extends StatefulWidget {
    final String apiKey;

    const MapWidget({Key? key, required this.apiKey}) : super(key: key);

    @override
    MapWidgetState createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
    // Let's build a floor selector widget here, we need to add this to MapControl later.
    final _floorSelectorWidget = MPDefaultFloorSelector();
    // MapControl will be initialized after MapsIndoors.
    late final MapsIndoorsWidget _mapController;
​
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Container(
                // Add the MapsIndoors Widget to your Widget, it will automatically fill the container it is placed in.
                child: _mapController = MapsIndoorsWidget(
                    // build with the default floor selector, this is optional.
                    floorSelector: _floorSelectorWidget,
                    // set an optional starting location for the camera, this starts the camera above Los Angeles
                    initialCameraPosition: MPCameraPosition(zoom: 7, MPPoint.withCoordinates(longitude: -118.0165, latitude: 33.9457))
                    readyListener: _mapControlReadyListener,
                ),
            ),
        );
    }
​
    @override
    void initState() {
        super.initState();
        // Start initializing mapsindoors.
        loadMapsIndoors(widget.apiKey);
    }
​
    void _mapControlReadyListener(MPError? error) async {
        if (error == null) {
            // if no errors occured during MapControl load, then we can start using the map
            // Here we move the camera to the default venue.
            _mapController.goTo(await getDefaultVenue());

        } else {
            print("Creating mapcontrol faced an issue: $err");
        }
    }
}
```

### Showing a Route

This code snippet initializes the `MPDirectionsService` and `MPDirectionsRenderer` classes, and uses `_mapControl` which has been initialized elsewhere.

The `showRouteToLocation` function is used to query a route from the user's current position to a specified location using `directionsService.getRoute()`.

If successful, the route is displayed on the map using `directionsRenderer.setRoute(route)`.

```Dart
// We assume MapControl has already been initialized
late final _mapControl;
​
// The user is positioned somewhere in the world
var _userLocation = MPPoint.withCoordinates(longitude: -98.44, latitude: 35.16);
/// Query a route to a location from the user's position
void showRouteToLocation(MPLocation location) async {
    // initialize services
    final directionsService = MPDirectionsService();
    final directionsRenderer = MPDirectionsRenderer();
​
    // get the route from userlocation to the location
    directionsService.getRoute(origin: _userPosition, destination: location.point).then((route) {
        // When we have the route, we can show it on the map
        directionsRenderer.setRoute(route);
    }).catchError((err) => print("An error occured: $err")); // otherwise handle the error
}
```

### Searching Locations

This code snippet shows a function called `searchForParking` that takes a single argument of type `MPPoint`. The function uses `MapsIndoors` to search for locations matching the query string `"parking"` near the point specified.

It mathces in the locations' descriptions, names, and external IDs to the query string. Once the search is complete, it is possible to update/get information from the locations (not specified in the code snippet).

```Dart
/// This method searches for locations 
void searchForParking(MPPoint point) {
    final mpq = MPQuery.builder()
    // Set the search string
    ..setQuery("parking")
    // Set the point where we would like to search around
    ..setNear(point)
    // We are searcing in the locations description, name and external id.
    ..setQueryProperties([MPLocationPropertyNames.description.name, MPLocationPropertyNames.name.name, MPLocationPropertyNames.externalId.name]);
    // Apply the query on MapsIndoors.
    getLocationsByQuery(query: mpq.build()).then((locations) {
        print("number of paring near the point: ${locations?.length}");
        // do something with the locations
    });
}
```

### Changing the look with DisplayRules

This code snippet shows three ways to manipulate display rules in the MapsIndoors SDK.

The `hideLocationsByDefault()` method hides all markers that are not explicitly visible by setting the main display rule to not visible.

The `showLocationsByDefault()` method ensures all markers are shown by setting the main display rule to visible.

The `changeTypePolygonColor(String type, Color color)` method changes the fill color for all polygons belonging to a specific type. It gets the display rule for the specified type using `getDisplayRuleByName`, and sets the fill color using `setPolygonFillColor`.

These methods can all be used to customize the display of markers and polygons on the map.

```Dart
/// This method changes the main display rule to hide all markers,
/// This will cause all locations that are not explicitly visible to be hidden.
void hideLocationsByDefault() async {
    final MPDisplayRule? main = await getMainDisplayRule();
    main?.setVisible(false);
}
​
/// This method changes the main display rule to show all markers,
/// This will cause all locations that are not explicitly visible to be shown.
void showLocationsByDefault() async {
    final MPDisplayRule? main = await getMainDisplayRule();
    main?.setVisible(true);
}
​
/// This method changes the fill color for all polygons belonging to a specific [type]
void changeTypePolygonColor(String type, Color color) async {
    final MPDisplayRule? rule = await getDisplayRuleByName(type);
    rule?.setPolygonFillColor(color);
}
```
import 'package:flutter/material.dart';
import 'package:mapsindoors_googlemaps/mapsindoors.dart';
import 'package:mapsindoors_example/route_handler.dart';
import 'package:mapsindoors_example/example_position_provider.dart';

void main() {
  runApp(const MapsIndoorsDemoApp());
}

class MapsIndoorsDemoApp extends StatelessWidget {
  const MapsIndoorsDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter MapsIndoors Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // 'demo' is solution that shows a map of the white house
      home: const Map(
        apiKey: 'demo',
      ),
    );
  }
}

/// The widget that will contain the map
class Map extends StatefulWidget {
  const Map({super.key, required this.apiKey});
  final String apiKey;

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  // We use the scaffold to construct a drawer for search results, and a bottomsheet for location details
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController? _controller;

  late MapsIndoorsWidget _mapControl;

  // set up a postion provider, this one we can update manually
  final _positionProvider = ExamplePositionProvider();

  // List used to populate the search results drawer
  List<MPLocation> _searchResults = [];
  // coordinate used as origin point for directions
  final _userPosition = MPPoint.withCoordinates(
      longitude: -77.03740973527613,
      latitude: 38.897389429704695,
      floorIndex: 0);
  RouteHandler? _routeHandler;

  @override
  void initState() {
    super.initState();
    loadMapsIndoors(widget.apiKey).then((error) {
      // if no error occured during loading, then we can start using the SDK
      if (error == null) {
        // add the position provider to MapsIndoors
        setPositionProvider(_positionProvider);

        // do stuff like fetching locations
      }
    });
  }

  void onMapControlReady(MPError? error) async {
    if (error == null) {
      // Add a listener for location selection events, we do not want to stop the SDK from moving the camera, so we do not comsume the event
      _mapControl
        ..setOnLocationSelectedListener(onLocationSelected, false)
        ..goTo(await getDefaultVenue());

      // update the position provider to be our hardcoded user position
      _positionProvider.updatePosition(_userPosition,
          accuracy: 25, bearing: 0.0, floorIndex: 0);
    } else {
      // if loading mapcontrol failed inform the user
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Map load failed: $error"),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // we change the titlebar into a searching widget
        title: SearchWidget(
          onSubmitted: search,
        ),
      ),
      // add a drawer that can display search results
      drawer: Drawer(
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              child: _searchResults.isNotEmpty
                  ? ListView.builder(
                      itemBuilder: (ctx, i) {
                        return ListTile(
                          onTap: () {
                            // when clicking on a location in the search results we will close the drawer and open a bottom sheet with that locations details
                            _mapControl.selectLocation(_searchResults[i]);
                            _scaffoldKey.currentState?.closeDrawer();
                          },
                          title: Text(_searchResults[i].name),
                        );
                      },
                      itemCount: _searchResults.length,
                    )
                  :
                  // show something if the search returned no results
                  const Icon(
                      Icons.search_off,
                      color: Colors.black,
                      size: 100.0,
                    ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _mapControl = MapsIndoorsWidget(
              readyListener: onMapControlReady,
            ),
          ],
        ),
      ),
    );
  }

  /// make a query in MapsIndoors on the search text
  void search(String value) {
    // we should clear the search filter when the query is empty
    if (value.isEmpty) {
      _mapControl.clearFilter();
      setState(() {
        _searchResults = [];
      });
      return;
    }
    // make a query with the search text
    MPQuery query = (MPQueryBuilder()..setQuery(value)).build();
    // we just want to see the top 30 results, as not to be overwhelmed
    MPFilter filter = (MPFilterBuilder()..setTake(30)).build();

    // fetch all (max 30) locations that match the query
    getLocationsByQuery(query: query, filter: filter).then((locations) {
      if (locations != null && locations.isNotEmpty) {
        // show search results drawer
        setState(() {
          _searchResults = locations;
          _scaffoldKey.currentState?.openDrawer();
        });
        // filter the map to only show matches
        _mapControl.setFilterWithLocations(locations, MPFilterBehavior.DEFAULT);
      }
    }).catchError((err) {
      // handle the error, for now just show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Search failed: $err"),
        backgroundColor: Colors.red,
      ));
    });
  }

  /// enable livedata for availability, occupancy and position domains
  void enableLiveData() {
    _mapControl
      ..enableLiveData(LiveDataDomainTypes.availability.name)
      ..enableLiveData(LiveDataDomainTypes.occupancy.name)
      ..enableLiveData(LiveDataDomainTypes.position.name);
  }

  /// opens bottomsheet with details about the selected location
  void onLocationSelected(MPLocation? location) {
    // if no location is selected, close the sheet
    if (location == null) {
      _controller?.close();
      _controller = null;
      return;
    }
    // if an active route is displayed, remove it from view
    _routeHandler?.removeRoute();
    // show location details
    _controller = _scaffoldKey.currentState?.showBottomSheet((context) {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.only(bottom: 50.0, left: 100, right: 100),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 30,
            ),
            Text(location.name),
            const SizedBox(
              height: 30,
            ),
            Text("Description: ${location.description}"),
            const SizedBox(
              height: 30,
            ),
            Text("Building: ${location.buildingName} - ${location.floorName}"),
            const SizedBox(
              height: 30,
            ),
            // when clicked will create a route from the user position to the location
            ElevatedButton(
              onPressed: () => _routeHandler = RouteHandler(
                  origin: _userPosition,
                  destination: location.point,
                  scaffold: _scaffoldKey.currentState!),
              child: const Row(
                children: [
                  Icon(Icons.keyboard_arrow_left_rounded),
                  SizedBox(
                    width: 5,
                  ),
                  Text("directions")
                ],
              ),
            ),
          ],
        ),
      );
    });
    _controller?.closed.then((value) => _mapControl.selectLocation(null));
  }
}

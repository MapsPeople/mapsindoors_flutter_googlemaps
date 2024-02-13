import 'package:flutter/material.dart';
import 'package:mapsindoors_googlemaps/mapsindoors.dart';

/// Encapsulates routing
class RouteHandler {
  RouteHandler(
      {required MPPoint origin,
      required MPPoint destination,
      required ScaffoldState scaffold}) {
    _service.setTravelMode(MPDirectionsService.travelModeDriving);
    _service.getRoute(origin: origin, destination: destination).then((route) {
      _route = route;
      _renderer.setRoute(route);
      _renderer.setOnLegSelectedListener(onLegSelected);
      showRoute(scaffold);
    });
  }
  final _service = MPDirectionsService();
  final _renderer = MPDirectionsRenderer();
  PersistentBottomSheetController? _controller;
  late final MPRoute _route;
  // backing field for the current route leg index
  int _currentIndex = 0;

  int get currentIndex {
    return _currentIndex;
  }

  // clamp the index to be in the correct range
  set currentIndex(int index) {
    _currentIndex = index.clamp(0, _route.legs!.length - 1);
  }

  // updates the state of the routehandler if the route is updated externally, eg. by tapping the next marker on the route
  void onLegSelected(int legIndex) {
    _controller?.setState!(() => currentIndex = legIndex);
  }

  // opens the route on a bottom sheet
  void showRoute(ScaffoldState scaffold) {
    _controller = scaffold.showBottomSheet((context) {
      return Container(
        padding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // goes a step back on the route
            IconButton(
              onPressed: () async {
                currentIndex--;
                await _renderer.selectLegIndex(currentIndex);
              },
              icon: const Icon(Icons.keyboard_arrow_left),
              iconSize: 50,
            ),
            // displays the route instructions
            Expanded(
              child: Text(
                expandRouteSteps(_route.legs![currentIndex].steps!),
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            ),
            // goes a step forward on the route
            IconButton(
              onPressed: () async {
                currentIndex++;
                await _renderer.selectLegIndex(currentIndex);
              },
              icon: const Icon(Icons.keyboard_arrow_right),
              iconSize: 50,
            ),
          ],
        ),
      );
    });
    // if the bottom sheet is closed, then clear the route
    _controller?.closed.then((val) {
      _renderer.clear();
    });
  }

  // external handle to clear the route
  void removeRoute() {
    _renderer.clear();
    _controller?.close();
  }

  // expands the step instructions into a single string for the entire leg
  String expandRouteSteps(List<MPRouteStep> steps) {
    String sum = "${steps[0].maneuver}";
    for (final step in steps.skip(1)) {
      sum += ", ${step.maneuver}";
    }
    return sum;
  }
}

/// A search field widget that fits the app bar
class SearchWidget extends StatelessWidget {
  final Function(String val)? onSubmitted;
  const SearchWidget({
    super.key,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
          icon: Icon(
            Icons.search,
            color: Colors.grey,
          ),
          hintText: "Search...",
          hintStyle: TextStyle(color: Colors.grey)),
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.black),
      onSubmitted: onSubmitted,
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapsindoors_googlemaps/mapsindoors.dart';

import 'package:mapsindoors_example/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('MapControl', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      final Finder fab = find.byType(ElevatedButton);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      // Emulate a tap on the floating action button.
      await tester.tap(fab);

      // Trigger a frame.
      await tester.pumpAndSettle(const Duration(seconds: 4));

      var ready = false;
      while (ready == false) {
        await tester.pumpAndSettle(const Duration(seconds: 1));
        ready = await isMapsIndoorsReady() ?? false;
      }

      final app.MapWidgetState state = tester.state(find.byType(app.MapWidget));

      MapsIndoorsWidget mapControl = state.mapController;

      expect(mapControl, isNot(null));

      /// Get venue from mapsindoors and move towards it
      ///
      /// expected get current venue to return the venue
      {
        MPVenue? fetchedVenue = (await getVenues())?.getAll().first;

        expect(fetchedVenue, isNot(null));

        await mapControl.selectVenue(fetchedVenue!, true);

        MPVenue? venue = await mapControl.getCurrentVenue();

        expect(venue, equals(fetchedVenue));
      }

      /// Get building from mapsindoors and move towards it
      ///
      /// expected get current building to return the building
      {
        MPBuilding? fetchedBuilding = (await getBuildings())?.getAll().first;

        expect(fetchedBuilding, isNot(null));

        mapControl.selectBuilding(fetchedBuilding!, true);
        await tester.pumpAndSettle(const Duration(seconds: 1));

        MPBuilding? building = await mapControl.getCurrentBuilding();

        expect(building, equals(fetchedBuilding));

        // we know there is a building with a floor here, check that now
        MPFloor? floor = await mapControl.getCurrentBuildingFloor();

        expect(floor?.floorIndex, building?.initialFloorIndex);
      }

      /// Set map padding, then get it again
      ///
      /// expected get returns padding
      {
        expect(mapControl.mapViewPaddingBottom, isNot(99));

        await mapControl.setMapPadding(55, 66, 77, 99);

        expect(await mapControl.mapViewPaddingStart, equals(55));

        expect(await mapControl.mapViewPaddingTop, equals(66));

        expect(await mapControl.mapViewPaddingEnd, equals(77));

        expect(await mapControl.mapViewPaddingBottom, equals(99));
      }

      /// get map style
      ///
      /// expected: mapstyle on mapcontrol is contained in mapsindoors
      {
        List<MPMapStyle>? styles = await getMapStyles();

        expect(styles, isNot(null));
        expect(styles?.length, isNot(0));

        MPMapStyle? currentStyle = await mapControl.mapStyle;

        expect(currentStyle, isNot(null));

        expect(styles?.contains(currentStyle), equals(true));

        // Test is conditioned on more than 1 style for the current solution
        if (styles!.length > 1) {
          styles.remove(currentStyle);

          MPMapStyle? newStyle = await mapControl.mapStyle;

          expect(newStyle, isNot(currentStyle));
        }
      }

      /// is floor selector hidden
      ///
      /// expected: not hidden, then hidden
      {
        bool? isFloorSelectorHidden = await mapControl.isFloorSelectorHidden;

        expect(isFloorSelectorHidden, false);

        await mapControl.hideFloorSelector(true);

        isFloorSelectorHidden = await mapControl.isFloorSelectorHidden;

        expect(isFloorSelectorHidden, true);
      }

      /// Filter
      ///
      /// expected: nothing, test is to ensure the platform does not crash
      {
        // check that it does not crash when no filter is in use
        await mapControl.clearFilter();

        // filter with all values filled
        MPFilter filterFilled = (MPFilterBuilder()
              ..setCategories(["one", "two"])
              ..setDepth(2)
              ..setFloorIndex(10)
              ..setGeometry(MPBounds(northeast: MPPoint.withCoordinates(longitude: 89.0, latitude: 90.0), southwest: MPPoint.withCoordinates(longitude: 1.0, latitude: 2.0)))
              ..setIgnoreLocationActiveStatus(true)
              ..setIgnoreLocationSearchableStatus(false)
              ..setLocations(["location"])
              ..setParents(["venue"])
              ..setSkip(20)
              ..setTake(3)
              ..setMapExtend(MPBounds(northeast: MPPoint.withCoordinates(longitude: 56.55467, latitude: 91.2345234), southwest: MPPoint.withCoordinates(longitude: -45.213342634, latitude: -20.4234))))
            .build();

        // filter with some values filled
        MPFilter filterSemi = (MPFilterBuilder()
              ..setDepth(2)
              ..setFloorIndex(10)
              ..setMapExtend(MPBounds(northeast: MPPoint.withCoordinates(longitude: 56.55467, latitude: 91.2345234), southwest: MPPoint.withCoordinates(longitude: -45.213342634, latitude: -20.4234))))
            .build();

        // filter with no values filled
        MPFilter filterNone = MPFilterBuilder().build();

        // behavior with values filled
        MPFilterBehavior behavior = (MPFilterBehavior.builder()
              ..setAllowFloorChange(false)
              ..setAnimationDuration(20000)
              ..setMoveCamera(true)
              ..setShowInfoWindow(false)
              ..setZoomToFit(false))
            .build();

        await mapControl.setFilter(filterFilled, behavior);
        await mapControl.setFilter(filterSemi, behavior);
        await mapControl.clearFilter();
        await mapControl.setFilter(filterNone, behavior);

        await mapControl.clearFilter();

        await mapControl.setFilter(filterFilled, MPFilterBehavior.DEFAULT);
        await mapControl.setFilter(filterSemi, MPFilterBehavior.DEFAULT);
        await mapControl.clearFilter();
        await mapControl.setFilter(filterNone, MPFilterBehavior.DEFAULT);

        // cleanup
        await mapControl.clearFilter();

        // Check the other setFilter
        List<MPLocation>? locations = (await getLocations())?.take(5).toList();

        await mapControl.setFilterWithLocations(locations!, behavior);
        await mapControl.setFilterWithLocations(locations, MPFilterBehavior.DEFAULT);
        await mapControl.clearFilter();

        await mapControl.setFilterWithLocations([], behavior);
        await mapControl.clearFilter();
      }

      {
        // Reset the listener as it might cause havoc in the app otherwise
        mapControl.setOnLocationSelectedListener(null, true);

        MPLocation? location = (await getLocations())?.first;

        await mapControl.selectLocation(location);
        await mapControl.deSelectLocation();
        await mapControl.selectLocation(location);
        await mapControl.selectLocation(null);

        MPSelectionBehavior behavior = (MPSelectionBehavior.builder()
              ..setAllowFloorChange(false)
              ..setAnimationDuration(0)
              ..setMoveCamera(false)
              ..setZoomToFit(true)
              ..setShowInfoWindow(true))
            .build();

        await mapControl.selectLocation(location, behavior);
        await mapControl.selectLocation(null, behavior);

        await mapControl.deSelectLocation();

        await mapControl.selectLocation(location, MPSelectionBehavior.DEFAULT);
        await mapControl.selectLocation(null, MPSelectionBehavior.DEFAULT);

        await mapControl.deSelectLocation();
      }

      /// goto
      {
        MPVenue? venue = (await getVenues())?.getAll().last;
        MPBuilding? building = (await getBuildings())?.getAll().last;
        MPFloor? floor = building?.floors.last;
        MPLocation? location = (await getLocations())?.last;

        await mapControl.goTo(venue);
        await mapControl.goTo(building);
        await mapControl.goTo(location);
        await mapControl.goTo(null);
        // This is temporary until iOS has implemented floor as an entity
        if (Platform.isAndroid) {
          await mapControl.goTo(floor);
        }
      }

      /// getcurrentzoom
      {
        final zoom = await mapControl.getCurrentMapsindoorsZoom();

        expect(zoom, isNot(null));
      }

      /// user position
      {
        bool? isPositionShown = await mapControl.isUserPositionShown;

        expect(isPositionShown, true);

        await mapControl.setShowUserPosition(false);

        isPositionShown = await mapControl.isUserPositionShown;

        expect(isPositionShown, false);
      }

      /// livedata
      {
        // disable something that has not been set
        mapControl.disableLiveData(LiveDataDomainTypes.count.name);
        // enable all
        mapControl.enableLiveData(LiveDataDomainTypes.any.name);
        // enable one
        mapControl.enableLiveData(LiveDataDomainTypes.availability.name);
        // remove the one
        mapControl.disableLiveData(LiveDataDomainTypes.availability.name);
        // remove all
        mapControl.disableLiveData(LiveDataDomainTypes.any.name);
      }

      // listeners
      {
        // check case where listener has not been added yet
        mapControl.removeOnCameraEventListner((event) => {});

        mapControl.addOnCameraEventListner((event) => {});
        mapControl.removeOnCameraEventListner((event) => {});

        mapControl.addOnFloorUpdateListener((floor) => {});
        mapControl.removeOnFloorUpdateListener((floor) => {});

        mapControl.setOnCurrentVenueChangedListener((venue) => {});

        mapControl.setOnCurrentBuildingChangedListener((building) => {});

        // check in case the initial value has not been set
        mapControl.setOnLocationSelectedListener((location) => {}, true);
        mapControl.setOnLocationSelectedListener((locaiton) => {}, true);

        mapControl.setOnMapClickListener((point, locations) => {}, true);
        mapControl.setOnMapClickListener(null, true);

        mapControl.setOnMarkerClickListener((locId) => {}, true);
        mapControl.setOnMarkerClickListener(null, true);

        mapControl.setOnMarkerInfoWindowClickListener((locId) => {});
        mapControl.setOnMarkerInfoWindowClickListener(null);
      }

      /// Camera mainpulation
      {
        final MPCameraPosition originalPosition = await mapControl.getCurrentCameraPosition();
        final MPCameraPosition copyPosition = (MPCameraPositionBuilder.fromPosition(originalPosition)..tilt = 20).build();

        expect(originalPosition.bearing, copyPosition.bearing);
        expect(originalPosition.zoom, copyPosition.zoom);
        expect(originalPosition.tilt, isNot(copyPosition.tilt));

        MPCameraPosition position = MPCameraPosition(zoom: 20, target: MPPoint.withCoordinates(longitude: 0, latitude: 0));

        await mapControl.moveCamera(MPCameraUpdate.fromCameraPosition(position));

        MPCameraUpdate update = MPCameraUpdate.fromPoint(MPPoint.withCoordinates(longitude: 10, latitude: 10));

        await mapControl.moveCamera(update);

        update = MPCameraUpdate.fromPoint(MPPoint.withCoordinates(longitude: 1000, latitude: -1000));

        await mapControl.moveCamera(update);

        update = MPCameraUpdate.fromBounds(bounds: MPBounds(northeast: MPPoint.withCoordinates(longitude: 20, latitude: 20), southwest: MPPoint.withCoordinates(longitude: -20, latitude: -20)), padding: 200);

        await mapControl.moveCamera(update);

        update = MPCameraUpdate.zoomBy(2);

        await mapControl.moveCamera(update);

        update = MPCameraUpdate.zoomBy(-2);

        await mapControl.moveCamera(update);

        update = MPCameraUpdate.zoomBy(2000);

        update = MPCameraUpdate.zoomTo(1);

        await mapControl.moveCamera(update);

        update = MPCameraUpdate.zoomTo(22);

        await mapControl.moveCamera(update);

        update = MPCameraUpdate.zoomTo(2000);

        await mapControl.moveCamera(update);

        update = MPCameraUpdate.zoomTo(-1);

        await mapControl.moveCamera(update);

        await mapControl.animateCamera(MPCameraUpdate.fromCameraPosition(originalPosition), 20000);

        await mapControl.animateCamera(MPCameraUpdate.fromCameraPosition(position));

        await mapControl.animateCamera(MPCameraUpdate.fromCameraPosition(originalPosition), 100);
      }
    });
  });
}

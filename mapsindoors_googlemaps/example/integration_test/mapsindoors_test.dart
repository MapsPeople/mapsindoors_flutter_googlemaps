import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mapsindoors_googlemaps/mapsindoors.dart';
import 'package:mapsindoors_example/example_position_provider.dart';

import 'package:mapsindoors_example/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('MapsIndoors', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      MPError? loaded = await loadMapsIndoors("mapspeople");
      expect(loaded, null);

      MPDisplayRule? defaultDisplayRule = await getDefaultDisplayRule();
      expect(defaultDisplayRule?.dispalyRuleName, "default");

      MPDisplayRule? mainDisplayRule = await getMainDisplayRule();
      expect(mainDisplayRule?.dispalyRuleName, "main");

      MPDisplayRule? mainByName = await getDisplayRuleByName("main");
      expect(mainByName?.dispalyRuleName, "main");

      String? apiKey = await getAPIKey();
      expect(apiKey, "mapspeople");

      List<String>? languages = await getMapsIndoorsAvailableLanguages();
      expect(languages?.length, 3);

      MPBuildingCollection? buildings = await getBuildings();
      expect(buildings?.size, 5);

      MPVenueCollection? venues = await getVenues();
      expect(venues?.size, 5);

      MPVenue? defaultVenue = await getDefaultVenue();
      expect(defaultVenue, isNotNull);
      expect(defaultVenue?.administrativeId, "Stigsborgvej");

      MPCategoryCollection? categories = await getCategories();
      expect(categories?.size, 18);

      String? language = await getMapsIndoorsLanguage();
      expect(language, "en");

      MPSolution? solution = await getSolution();
      expect(solution?.availableLanguages.length, 3);

      MPLocation? location = await getLocationById("296994c98023439eac1f20d4");
      expect(location?.name, "Canteen");

      List<MPLocation>? locations = await getLocations();
      expect(locations?.isNotEmpty, true);

      List<String> externalIds = ["0.32.05"];
      List<MPLocation>? externalIdLocations = await getLocationsByExternalIds(externalIds);

      expect(externalIdLocations?.length, 1);
      expect(externalIdLocations?[0].name, "Canteen");

      MPQuery query = MPQuery.builder().build();
      MPFilter filter = (MPFilterBuilder()..setTypes(["Canteen"])).build();
      List<MPLocation>? locationsByFilter = await getLocationsByQuery(query: query, filter: filter);
      expect(locationsByFilter?.isNotEmpty, true);

      query = (MPQuery.builder()..setQuery("apisjgaelgasdf asdoæfk oæskg æaskf nasdlfnasue")).build();
      filter = MPFilterBuilder().build();
      locationsByFilter = await getLocationsByQuery(query: query, filter: filter);
      expect(locationsByFilter?.isNotEmpty, false);

      List<MPMapStyle>? mapstyles = await getMapStyles();
      expect(mapstyles?.length, 1);
      expect(mapstyles?[0].displayName, "default");

      ExamplePositionProvider posProv = ExamplePositionProvider();
      setPositionProvider(posProv);
      expect(getPositionProvider()?.name, "random");

      bool? validApi = await isAPIKeyValid();
      expect(validApi, true);

      bool? ready = await isMapsIndoorsReady();
      expect(ready, true);

      MPUserRoleCollection? userRoles = await getUserRoles();
      expect(userRoles?.size != 0, true);

      applyUserRoles(userRoles!.getAll());

      var currAvailableUseRoles = await getAppliedUserRoles();
      expect(currAvailableUseRoles?.length, userRoles.size);

      applyUserRoles([]);

      currAvailableUseRoles = await getAppliedUserRoles();
      expect(currAvailableUseRoles?.length, 0);

      // This is temporary until iOS has implemented ReverseGeoCode feature
      if (Platform.isAndroid) {
        MPGeocodeResult? result = await reverseGeoCode(MPPoint.withCoordinates(longitude: 9.9508396, latitude: 57.0582701, floorIndex: 0));
        expect(result?.rooms.length, 1);
        expect(result?.floors[0].floorIndex, 0);
      }

      await setMapsIndoorsLanguage("da");
      expect(await getMapsIndoorsLanguage(), "da");

      /*// Finds the floating action button to tap on.
      final Finder fab = find.byTooltip('Increment');

      // Emulate a tap on the floating action button.
      await tester.tap(fab);

      // Trigger a frame.
      await tester.pumpAndSettle();

      // Verify the counter increments by 1.
      expect(find.text('1'), findsOneWidget);*/
    });
  });
}

part of mapsindoors;

/// gets the platform name and build version
Future<String?> getPlatformVersion() => UtilPlatform.instance.getPlatformVersion();

/// Loads content from the MapsIndoors solution matching the given API [key].
///
/// Use the [MPError] to determine if the SDK has loaded successfully.
Future<MPError?> loadMapsIndoors(String key) => MapsindoorsPlatform.instance.load(key);

/// Retrieve the default display rule (hardcoded display rule in the SDK).
///
/// Requires that [loadMapsIndoors] has successfully executed.
Future<MPDisplayRule?> getDefaultDisplayRule() => Future.value(MapsindoorsPlatform.instance.createDisplayRuleWithName("default"));

/// Retrieve the main display rule (can be configured in the CMS).
///
/// Requires that [loadMapsIndoors] has successfully executed.
Future<MPDisplayRule?> getMainDisplayRule() => Future.value(MapsindoorsPlatform.instance.createDisplayRuleWithName("main"));

/// Retrieve the display rule for the given [location]
///
/// Requires that [loadMapsIndoors] has successfully executed.
Future<MPDisplayRule?> getDisplayRuleByLocation(FutureOr<MPLocation> location) async {
  final exists = await MapsindoorsPlatform.instance.locationDisplayRuleExists((await location).id);
  if (exists == true) {
    return MapsindoorsPlatform.instance.createDisplayRuleWithName((await location).id.value);
  } else {
    return null;
  }
}

/// Retrieve the display rule with a given [name].
///
/// Requires that [loadMapsIndoors] has successfully executed.
Future<MPDisplayRule?> getDisplayRuleByName(String name) async {
  final exists = await MapsindoorsPlatform.instance.displayRuleNameExists(name);
  if (exists == true) {
    return MapsindoorsPlatform.instance.createDisplayRuleWithName(name);
  } else {
    return null;
  }
}

/// Retrieve the corresponding display rule for the given [MPSolutionDisplayRuleEnum].
///
/// Requires that [loadMapsIndoors] has successfully executed.
Future<MPDisplayRule?> getSolutionDisplayRule(MPSolutionDisplayRuleEnum solutionDisplayRule) => Future.value(MapsindoorsPlatform.instance.createDisplayRuleWithName(solutionDisplayRule.name));

/// Add a one time [listener] to be invoked when MapsIndoors is ready
void addOnMapsIndoorsReadyListener(OnMapsIndoorsReadyListener listener) => MapsindoorsPlatform.instance.addOnMapsIndoorsReadyListener(listener);

/// Remove a MapsIndoors ready listener
void removeOnMapsIndoorsReadyListener(OnMapsIndoorsReadyListener listener) => MapsindoorsPlatform.instance.removeOnMapsIndoorsReadyListener(listener);

/// Checks if there is on device data (embedded/locally stored) available. For this to return true,
/// data has to be available for all solution data types ([MPLocation], [MPBuilding]...)
///
/// Returns true if data is available, otherwise returns false
Future<bool?> checkOfflineDataAvailability() => MapsindoorsPlatform.instance.checkOfflineDataAvailability();

/// Clears the internal state of MapsIndoors SDK. Any loaded content is purged from memory.
///
/// Invoke [loadMapsIndoors] to start the SDK anew.
void destroyMapsIndoors() => MapsindoorsPlatform.instance.destroy();

/// [disable] SDK event logging through MapsIndoors. No logs will be created or send with this disabled.
///
/// By default it is enabled. But disabled in the CMS meaning logs will be created but never uploaded.
Future<void> disableMapsIndoorsEventLogging(bool disable) => MapsindoorsPlatform.instance.disableEventLogging(disable);

/// Retrieves the API key that was set by using [loadMapsIndoors]
///
/// Returns the API key, or "" if no key has been set
Future<String?> getAPIKey() => MapsindoorsPlatform.instance.getAPIKey();

/// Returns a list of the current solution's available languages
Future<List<String>?> getMapsIndoorsAvailableLanguages() => MapsindoorsPlatform.instance.getAvailableLanguages();

/// Gets a collection of all buildings for the current API key
Future<MPBuildingCollection?> getBuildings() => MapsindoorsPlatform.instance.getBuildings();

/// Gets a collection of all categories for the current API key
Future<MPCategoryCollection?> getCategories() => MapsindoorsPlatform.instance.getCategories();

/// Returns the current solution's default language
Future<String?> getMapsIndoorsDefaultLanguage() => MapsindoorsPlatform.instance.getDefaultLanguage();

/// Gets the current SDK language
Future<String?> getMapsIndoorsLanguage() => MapsindoorsPlatform.instance.getLanguage();

/// Retrieves a [MPLocation] by its [id]
Future<MPLocation?> getLocationById(String id) => MapsindoorsPlatform.instance.getLocationById(id);

/// Gets all locations (a list of [MPLocation] objects) for the current API Key
Future<List<MPLocation>?> getLocations() => MapsindoorsPlatform.instance.getLocations();

/// Runs a query on all the available [MPLocation]s with an optional [MPQuery] and/or [MPFilter]
Future<List<MPLocation>?> getLocationsByQuery({MPQuery? query, MPFilter? filter}) => MapsindoorsPlatform.instance.getLocationsByQuery(query, filter);

/// Retrieves a list of [MPLocation]s by external [ids]
Future<List<MPLocation>?> getLocationsByExternalIds(List<String> ids) => MapsindoorsPlatform.instance.getLocationsByExternalIds(ids);

/// Gets a list of available map styles
Future<List<MPMapStyle>?> getMapStyles() => MapsindoorsPlatform.instance.getMapStyles();

/// Returns the current position provider, if any is set
MPPositionProviderInterface? getPositionProvider() => MapsindoorsPlatform.instance.getPositionProvider();

/// Set a new position provider, or pass null to remove the current one
///
/// Positioning starts as soon as the provider is set and has produced a position
void setPositionProvider(MPPositionProviderInterface? provider) => MapsindoorsPlatform.instance.setPositionProvider(provider);

/// Gets the [MPSolution] for the current API key
Future<MPSolution?> getSolution() => MapsindoorsPlatform.instance.getSolution();

/// Gets a collection of all venues for the current API key
Future<MPVenueCollection?> getVenues() => MapsindoorsPlatform.instance.getVenues();

/// Check if the current API key is valid
Future<bool?> isAPIKeyValid() => MapsindoorsPlatform.instance.isAPIKeyValid();

/// Check if [loadMapsIndoors] has been called
Future<bool?> isMapsIndoorsInitialized() => MapsindoorsPlatform.instance.isInitialized();

/// Check if the SDK is initialized and ready for use
Future<bool?> isMapsIndoorsReady() => MapsindoorsPlatform.instance.isReady();

/// Sets the SDK's internal language.
///
/// By default, the SDK language can be:
/// <ul>
/// <li>the solution's default language ([MPSolution.defaultLanguage])</li>
/// <li>the current device language, if the MapsIndoors data isn't available (ie: first app run without network access)</li>
/// </ul>
Future<bool?> setMapsIndoorsLanguage(String language) => MapsindoorsPlatform.instance.setLanguage(language);

/// Main data synchronization method
///
/// If not manually invoked, [MapsIndoorsWidget] will invoke it when built
Future<MPError?> synchronizeMapsIndoorsContent() => MapsindoorsPlatform.instance.synchronizeContent();

/// Gets the User Roles for the current solution
///
/// Note that role names are localized
Future<MPUserRoleCollection?> getUserRoles() => MapsindoorsPlatform.instance.getUserRoles();

/// Returns the list of [MPUserRole] that is currently applied
Future<List<MPUserRole>?> getAppliedUserRoles() => MapsindoorsPlatform.instance.getAppliedUserRoles();

/// Applies a list of [MPUserRole]s to the SDK which will get the UserRole specific locations.
Future<void> applyUserRoles(List<MPUserRole> userRoles) => MapsindoorsPlatform.instance.applyUserRoles(userRoles);

/// Get a [MPGeocodeResult] that contains lists of [MPLocation] (grouped by [MPLocationType]),
/// where the [point] is inside the locations geometry. When no floor index is set, locations on all floors are queried.
Future<MPGeocodeResult?> reverseGeoCode(MPPoint point) => MapsindoorsPlatform.instance.reverseGeoCode(point);

/// Gets the default venue for this solution
Future<MPVenue?> getDefaultVenue() => MapsindoorsPlatform.instance.getDefaultVenue();

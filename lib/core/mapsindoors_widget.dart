part of '../mapsindoors.dart';

/// A [UniqueWidget] that contains the map used by MapsIndoors
class MapsIndoorsWidget extends UniqueWidget {
  final MPFloorSelector? floorSelector;
  final MPMapLabelFont? mapLabelFont;
  final int? textSize;
  final bool? showFloorSelector;
  final bool? showInfoWindowOnClick;
  final bool? showUserPosition;
  final bool? enabletileFadeIn;
  final MPSelectionMode? buildingSelectionMode;
  final MPSelectionMode? floorSelectionMode;
  final num? mapsIndoorsTransitionLevel;
  final Alignment? floorSelectorAlignment;
  final bool useDefaultMapsIndoorsStyle;
  final OnMapReadyListener? readyListener;

  /// Build the widget, MapsIndoors currently supports the following platforms:
  /// * Android
  /// * iOS
  ///
  /// Has optional [MPFloorSelector] widget. Package includes a [MPDefaultFloorSelector].
  ///
  /// [floorSelectorAlignment] defaults to [Alignment.centerRight] if none is provided.
  MapsIndoorsWidget({
    this.mapLabelFont,
    this.textSize,
    this.showFloorSelector,
    this.showInfoWindowOnClick,
    this.showUserPosition,
    this.enabletileFadeIn,
    this.buildingSelectionMode,
    this.floorSelectionMode,
    this.mapsIndoorsTransitionLevel,
    this.floorSelector,
    this.floorSelectorAlignment,
    this.readyListener,
    this.useDefaultMapsIndoorsStyle = true,
  }) : super(key: const GlobalObjectKey(MapsIndoorsWidget)) {
    if (readyListener != null) {
      MapcontrolPlatform.instance.setOnMapControlReadyListener(readyListener!);
    }
  }

  @override
  State<StatefulWidget> createState() => _MapsIndoorsState();

  /// Get the currently selected venue
  Future<MPVenue?> getCurrentVenue() {
    return MapcontrolPlatform.instance.getCurrentVenue();
  }

  /// Select a venue, optionally move the camera to the given venue
  Future<void> selectVenue(FutureOr<MPVenue?> venue, bool moveCamera) async {
    return MapcontrolPlatform.instance.selectVenue(await venue, moveCamera);
  }

  /// Get the currently selected building
  Future<MPBuilding?> getCurrentBuilding() {
    return MapcontrolPlatform.instance.getCurrentBuilding();
  }

  /// Select a building, optionally move the camera to the given building
  Future<void> selectBuilding(
      FutureOr<MPBuilding?> building, bool moveCamera) async {
    return MapcontrolPlatform.instance
        .selectBuilding(await building, moveCamera);
  }

  /// Invoke this method to restore the map to its default state (POIs shown based on their display rules, etc.)
  Future<void> clearFilter() {
    return MapcontrolPlatform.instance.clearFilter();
  }

  /// Use this method to display temporary locations, not points of interests location. Use [clearFilter()] to exit this state
  ///
  /// Returns true if any locations are available
  Future<bool> setFilter(MPFilter filter, MPFilterBehavior behavior) {
    return MapcontrolPlatform.instance.setFilter(filter, behavior);
  }

  /// Use this method to display temporary locations, not points of interests location. Use [clearFilter()] to exit this state
  Future<void> setFilterWithLocations(
      List<MPLocation?> locations, MPFilterBehavior behavior) {
    return MapcontrolPlatform.instance
        .setFilterWithLocations(locations, behavior);
  }

  /// Shows or hides the [MPFloorSelectorInterface], i.e. hiding the View from [MapsIndoorsWidget]
  ///
  /// [MapsIndoorsWidget] will still receive relevant events on floor updates, building change etc.
  ///
  /// The Interface will also receive the events, making it possible to show/hide in real time,
  /// without refreshing the map.
  Future<void> hideFloorSelector(bool hide) {
    return MapcontrolPlatform.instance.hideFloorSelector(hide);
  }

  // setInfoWindowAdapter

  // setClusterIconAdapter

  /// Sets padding on the map.
  Future<void> setMapPadding(int start, int top, int end, int bottom) {
    return MapcontrolPlatform.instance.setMapPadding(start, top, end, bottom);
  }

  /// Sets the map style for MapsIndoors tiles
  ///
  /// [mapstyle] is a [MPMapStyle] object, a list of available [MPMapStyle]s can be fetched via [getMapStyles]
  Future<void> setMapStyle(MPMapStyle mapstyle) {
    return MapcontrolPlatform.instance.setMapStyle(mapstyle);
  }

  /// Gets the current map style of MapsIndoors tiles
  Future<MPMapStyle?> get mapStyle {
    return MapcontrolPlatform.instance.getMapStyle();
  }

  /// Gets the Map View bottom padding
  Future<int?> get mapViewPaddingBottom {
    return MapcontrolPlatform.instance.getMapViewPaddingBottom();
  }

  /// Gets the Map View end padding
  Future<int?> get mapViewPaddingEnd {
    return MapcontrolPlatform.instance.getMapViewPaddingEnd();
  }

  /// Gets the Map View start padding
  Future<int?> get mapViewPaddingStart {
    return MapcontrolPlatform.instance.getMapViewPaddingStart();
  }

  /// Gets the Map View top padding
  Future<int?> get mapViewPaddingTop {
    return MapcontrolPlatform.instance.getMapViewPaddingTop();
  }

  /// Enables/disables the info window on user-selected locations
  ///
  /// The info window is shown by default when the user selects a location (by tapping on it)
  Future<void> showInfoWindowOnClickedLocation(bool show) {
    return MapcontrolPlatform.instance.showInfoWindowOnClickedLocation(show);
  }

  /// Returns the visibility state of the currently used [MPFloorSelectorInterface].
  Future<bool?> get isFloorSelectorHidden {
    return MapcontrolPlatform.instance.isFloorSelectorHidden();
  }

  /// Call this to deselect a location previously selected with [selectLocation(MPLocation, MPSelectionBehavior)]
  Future<void> deSelectLocation() {
    return MapcontrolPlatform.instance.deSelectLocation();
  }

  /// Sets the current visible floor to the given floorIndex one
  ///
  /// For floor names/z-index pairs check the value returned by [MPBuilding.floors]
  Future<void> selectFloor(int floorIndex) {
    return MapcontrolPlatform.instance.selectFloor(floorIndex);
  }

  /// Focus the map on the given [MPEntity].
  ///
  /// Examples of classes of type [MPEntity] are: [MPVenue], [MPBuilding],
  /// [MPBuilding], [MPLocation].
  Future<void> goTo(FutureOr<MPEntity?> entity) async {
    return MapcontrolPlatform.instance.goTo(await entity);
  }

  /// Selects a location based on a [MPLocation] object.
  ///
  /// Optionally apply a [MPSelectionBehavior]
  ///
  /// Use [deSelectLocation()] or send null instead of a [MPLocation] to un-select the location.
  Future<void> selectLocation(FutureOr<MPLocation?> location,
      [MPSelectionBehavior? behavior]) async {
    return MapcontrolPlatform.instance.selectLocation(
        await location, behavior ?? MPSelectionBehavior.DEFAULT);
  }

  /// Selects a location based on a id string object.
  ///
  /// Optionally apply a [MPSelectionBehavior]
  ///
  /// Use [deSelectLocation] or send null instead of a [MPLocation] to un-select the location.
  Future<void> selectLocationById(String id, [MPSelectionBehavior? behavior]) {
    return MapcontrolPlatform.instance
        .selectLocationById(id, behavior ?? MPSelectionBehavior.DEFAULT);
  }

  /// Returns the current [MPFloor] of the current [MPBuilding] in focus
  Future<MPFloor?> getCurrentBuildingFloor() {
    return MapcontrolPlatform.instance.getCurrentBuildingFloor();
  }

  /// Returns the current floor index or [MPFloor.defaultGroundFloorIndex] if no [MPBuilding] is in focus
  Future<int?> getCurrentFloorIndex() {
    return MapcontrolPlatform.instance.getCurrentFloorIndex();
  }

  /// Replaces the default FloorSelector with a custom one.
  Future<void> setFloorSelector(MPFloorSelectorInterface floorSelector) {
    return MapcontrolPlatform.instance.setFloorSelector(floorSelector, false);
  }

  /// Get the zoom level that MapsIndoors is currently using for display icons etc. on the map
  Future<num?> getCurrentMapsindoorsZoom() {
    return MapcontrolPlatform.instance.getCurrentMapsIndoorsZoom();
  }

  /// Renders the positioning blue dot at the last known user position on the map
  Future<void> setShowUserPosition(bool show) {
    return MapcontrolPlatform.instance.showUserPosition(show);
  }

  /// Returns the current visibility state of the user location icon (blue dot)
  Future<bool?> get isUserPositionShown {
    return MapcontrolPlatform.instance.isUserPositionShown();
  }

  /// Enables live data on a specific domain and uses MapsIndoors standard graphic implementation
  ///
  /// Uses a domainType string, use [LiveDataDomainTypes] to get supported strings
  Future<void> enableLiveData(String domainType,
      [OnLiveLocationUpdateListener? listener]) {
    return MapcontrolPlatform.instance.enableLiveData(domainType, listener);
  }

  /// Disables live data for a specific domainType
  Future<void> disableLiveData(String donaminType) {
    return MapcontrolPlatform.instance.disableLiveData(donaminType);
  }

  /// Removes highlight status from all highlighted locations
  Future<void> clearHighlight() {
    return MapcontrolPlatform.instance.clearHighlight();
  }

  /// Set a collection of locations to be highlighted, this is different from [setFilter] in that other locations are not removed,
  /// but the highlighted locations will always be visible and will have a badge added to show that it is highlighted.
  Future<void> setHighlight(
      List<MPLocation> locations, MPHighlightBehavior behavior) {
    return MapcontrolPlatform.instance.setHighlight(locations, behavior);
  }

  /// Get the current building selection mode
  Future<MPSelectionMode> getBuildingSelectionMode() {
    return MapcontrolPlatform.instance.getBuildingSelectionMode();
  }

  /// Set the building selection mode
  Future<void> setBuildingSelectionMode(MPSelectionMode mode) {
    return MapcontrolPlatform.instance.setBuildingSelectionMode(mode);
  }

  /// Get the current floor selection mode
  Future<MPSelectionMode> getFloorSelectionMode() {
    return MapcontrolPlatform.instance.getFloorSelectionMode();
  }

  /// Set the floor selection mode
  Future<void> setFloorSelectionMode(MPSelectionMode mode) {
    return MapcontrolPlatform.instance.setFloorSelectionMode(mode);
  }

  /// Add a camera event listener, invoked when a camera event occurs (e.g. moved, idle) (see [MPCameraEvent])
  void addOnCameraEventListner(MPCameraEventListener listener) {
    MapcontrolPlatform.instance.addOnCameraEventListner(listener);
  }

  /// Remove a camera event listener
  void removeOnCameraEventListner(MPCameraEventListener listener) {
    MapcontrolPlatform.instance.removeOnCameraEventListner(listener);
  }

  /// Add a listener object to catch floor changes made by either the user or the positioning service
  void addOnFloorUpdateListener(OnFloorUpdateListener listener) {
    MapcontrolPlatform.instance.addOnFloorUpdateListener(listener);
  }

  /// Remove a floor update listener
  void removeOnFloorUpdateListener(OnFloorUpdateListener listener) {
    MapcontrolPlatform.instance.removeOnFloorUpdateListener(listener);
  }

  /// Set a location selection listener, invoked when a location is selected,
  /// either by tapping on it, or programmatically with [selectLocation]
  void setOnLocationSelectedListener(OnLocationSelectedListener? listener,
      [bool? consumeEvent]) {
    MapcontrolPlatform.instance
        .setOnLocationSelectedListener(listener, consumeEvent);
  }

  /// Set a listener for when the map has been tapped
  void setOnMapClickListener(OnMapClickListener? listener,
      [bool? consumeEvent]) {
    MapcontrolPlatform.instance.setOnMapClickListener(listener, consumeEvent);
  }

  /// Set a marker click event listener, invoked when a marker is clicked
  void setOnMarkerClickListener(OnMarkerClickListener? listener,
      [bool? consumeEvent]) {
    MapcontrolPlatform.instance
        .setOnMarkerClickListener(listener, consumeEvent);
  }

  /// Set a info window click listener, invoked when an info window is clicked
  void setOnMarkerInfoWindowClickListener(
      OnMarkerInfoWindowClickListener? listener) {
    MapcontrolPlatform.instance.setOnMarkerInfoWindowClickListener(listener);
  }

  /// Uses a camera update to animate the camera.
  ///
  /// [duration] how long the animation should take.
  Future<void> animateCamera(MPCameraUpdate update, [int? duration]) {
    return MapcontrolPlatform.instance.animateCamera(update, duration);
  }

  /// Saves the current position of the camera into a [MPCameraPosition].
  Future<MPCameraPosition> getCurrentCameraPosition() {
    return MapcontrolPlatform.instance.currentCameraPosition();
  }

  /// Uses a camera update to move the camera instantly.
  Future<void> moveCamera(MPCameraUpdate update) {
    return MapcontrolPlatform.instance.moveCamera(update);
  }

  /// Set a current building changed event listener, which is invoked when the currently selected building changes
  void setOnCurrentBuildingChangedListener(
      OnBuildingFoundAtCameraTargetListener? listener) {
    MapcontrolPlatform.instance.setOnCurrentBuildingChangedListener(listener);
  }

  /// Set a current venue changed event listener, which is invoked when the currently selected venue changes
  void setOnCurrentVenueChangedListener(
      OnVenueFoundAtCameraTargetListener? listener) {
    MapcontrolPlatform.instance.setOnCurrentVenueChangedListener(listener);
  }

  /// Change the appearance of the labels of POIs.
  ///
  /// [textSize] changes the size of the text in pts.
  /// [color] changes the color of the text in RGB format.
  /// [showHalo] enables/disables the white halo around the text.
  ///
  /// If any value is null, the corresponding field will not be updated.
  Future<void> setLabelOptions(
      {num? textSize, String? color, bool showHalo = false}) {
    return MapcontrolPlatform.instance
        .setLabelOptions(textSize, color, showHalo);
  }

  /// Set a list of features to be hidden from the map.
  ///
  /// [features] the features to be hidden
  ///
  /// Setting a new list will override any existing list.
  /// Setting null will make all features visible.
  Future<void> setHiddenFeatures(FutureOr<List<MPFeatureType>> features) async {
    return MapcontrolPlatform.instance.setHiddenFeatures(await features);
  }

  /// Get the list of features hidden on the map
  ///
  /// If null is returned, then no features are currently hidden
  Future<List<MPFeatureType>> getHiddenFeatures() {
    return MapcontrolPlatform.instance.getHiddenFeatures();
  }
}

class _MapsIndoorsState extends State<MapsIndoorsWidget> {
  @override
  Widget build(BuildContext context) {
    // This is used in the platform side to register the view.
    const String viewType = '<map-view>';
    // Pass parameters to the platform side.

    final Map<String, dynamic> creationParams = <String, dynamic>{
      "mapConfig": jsonEncode({
        "textSize": widget.textSize,
        "showFloorSelector": widget.showFloorSelector,
        "showInfoWindowOnLocationClicked": widget.showInfoWindowOnClick,
        "showUserPosition": widget.showUserPosition,
        "typeface": widget.mapLabelFont?.typeface,
        "color": widget.mapLabelFont?.color,
        "showHalo": widget.mapLabelFont?.showHalo,
        "buildingSelectionMode": widget.buildingSelectionMode?.index,
        "floorSelectionMode": widget.floorSelectionMode?.index,
        "tileFadeInEnabled": widget.enabletileFadeIn,
        "mapsindoorsTransitionLevel": widget.mapsIndoorsTransitionLevel,
        "useDefaultMapsIndoorsStyle": widget.useDefaultMapsIndoorsStyle,
      }),
      "floorSelectorAutoFloorChange":
          widget.floorSelector?.isAutoFloorChangeEnabled == true
    };

    final floorSelector = widget.floorSelector ?? MPDefaultFloorSelector();
    MapcontrolPlatform.instance.setFloorSelector(floorSelector, true);
    final StatefulWidget ret;

    if (Platform.isAndroid) {
      ret = AndroidView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (Platform.isIOS) {
      ret = UiKitView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else {
      throw UnimplementedError();
    }

    return Flexible(
      fit: FlexFit.tight,
      flex: 1,
      child: Stack(children: [
        ret,
        Align(
          alignment: widget.floorSelectorAlignment ?? Alignment.centerRight,
          child: floorSelector,
        )
      ]),
    );
  }
}

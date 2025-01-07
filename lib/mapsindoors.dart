/// Starting point for all MapsIndoors functionality
library mapsindoors;

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

import 'package:mapsindoors_platform_interface/platform_library.dart';
export 'package:mapsindoors_platform_interface/platform_library.dart'
    show
        MPBuilding,
        MPEntity,
        MPFloor,
        MPLocation,
        MPVenue,
        LiveDataDomainTypes,
        MPFeatureType,
        MPCameraEvent,
        MPCameraViewFitMode,
        MPCollisionHandling,
        MPLocationPropertyNames,
        MPLocationType,
        MPSolutionDisplayRuleEnum,
        MPBounds,
        MPGeometry,
        MPMultiPolygon,
        MPPoint,
        MPPolygon,
        MPCameraEventListener,
        OnBuildingFoundAtCameraTargetListener,
        OnFloorSelectionChangedListener,
        OnFloorUpdateListener,
        OnLegSelectedListener,
        OnLiveLocationUpdateListener,
        OnLocationSelectedListener,
        OnMapClickListener,
        OnMapsIndoorsReadyListener,
        OnMarkerClickListener,
        OnMarkerInfoWindowClickListener,
        OnPositionUpdateListener,
        OnVenueFoundAtCameraTargetListener,
        MPRouteCoordinate,
        MPRouteLeg,
        MPRouteProperty,
        MPRouteStep,
        MPRoute,
        MPBuildingInfo,
        MPCategory,
        MPDataField,
        MPDisplayRule,
        MPLabelGraphic,
        MPError,
        MPFilter,
        MPFilterBuilder,
        MPFloorSelectorInterface,
        MPGeocodeResult,
        MPIconSize,
        MPFilterBehavior,
        MPFilterBehaviorBuilder,
        MPSelectionBehavior,
        MPSelectionBehaviorBuilder,
        MPSelectionMode,
        MPRouteResult,
        MPMapStyle,
        MPPositionProviderInterface,
        MPPositionResultInterface,
        MPQuery,
        MPQueryBuilder,
        MPSettings3D,
        MPSolutionConfig,
        MPSolution,
        MPUserRole,
        MPHighway,
        MPCameraPosition,
        MPCameraPositionBuilder,
        MPCameraUpdate,
        MPBuildingCollection,
        MPCategoryCollection,
        MPVenueCollection,
        MPUserRoleCollection,
        MPLabelType,
        MPHighlightBehavior,
        MPHighlightBehaviorBuilder,
        MPIconPlacement,
        MPBadgePosition,
        MPRouteStopIconConfig,
        MPRouteStopIconConfigInterface;

part 'core/mapsindoors_widget.dart';
part 'core/mp_directions_service.dart';
part 'core/mp_directions_renderer.dart';
part 'core/mp_default_floor_selector.dart';
part 'core/mp_floor_selector.dart';
part 'core/mp_map_label_font.dart';
part 'core/mapsindoors.dart';

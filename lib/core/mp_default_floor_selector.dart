part of '../mapsindoors.dart';

class MPDefaultFloorSelector extends StatefulWidget with MPFloorSelector {
  MPDefaultFloorSelector({super.key});
  final _Forwarder _callForwarder = _Forwarder();

  @override
  Widget? getWidget() => this;
  @override
  bool get isAutoFloorChangeEnabled => true;
  @override
  set floors(List<MPFloor>? floors) => _callForwarder.setFloors?.call(floors);
  @override
  set onFloorSelectionChangedListener(
      OnFloorSelectionChangedListener listener) {
    if (_callForwarder.setOnFloorSelectionChangedListener != null) {
      _callForwarder.setOnFloorSelectionChangedListener?.call(listener);
    } else {
      _callForwarder.listener = listener;
    }
  }

  @override
  void setSelectedFloor(MPFloor floor) =>
      _callForwarder.setSelectedFloor?.call(floor);
  @override
  void setSelectedFloorByFloorIndex(int floorIndex) =>
      _callForwarder.setSelectedFloorByFloorIndex?.call(floorIndex);
  @override
  set userPositionFloor(int floorIndex) =>
      _callForwarder.setUserPositionFloor?.call(floorIndex);
  @override
  void show(bool show) => _callForwarder.show?.call(show);
  @override
  void zoomLevelChanged(num newZoomLevel) =>
      _callForwarder.zoomLevelChanged?.call(newZoomLevel);

  @override
  FloorSelectorState createState() => FloorSelectorState();
}

class _Forwarder {
  OnFloorSelectionChangedListener? listener;
  Function(List<MPFloor>? floors)? setFloors;
  Function(OnFloorSelectionChangedListener listener)?
      setOnFloorSelectionChangedListener;
  Function(MPFloor floor)? setSelectedFloor;
  Function(int floorIndex)? setSelectedFloorByFloorIndex;
  Function(int floorIndex)? setUserPositionFloor;
  Function(bool show)? show;
  Function(num newZoomLevel)? zoomLevelChanged;
}

class FloorSelectorState extends State<MPDefaultFloorSelector>
    implements MPFloorSelectorInterface {
  final List<MPFloor> _floors = List.empty(growable: true);
  OnFloorSelectionChangedListener? _listener;
  bool _visible = true;
  int _userPositionFloor = -1;
  MPFloor? _selectedFloor;
  num showOnZoomLevel = 17.0;

  @override
  void initState() {
    super.initState();
    widget._callForwarder.setFloors = (floors) => this.floors = floors;
    widget._callForwarder.setOnFloorSelectionChangedListener =
        (listener) => onFloorSelectionChangedListener = listener;
    widget._callForwarder.setSelectedFloor = (floor) => setSelectedFloor(floor);
    widget._callForwarder.setSelectedFloorByFloorIndex =
        (floorIndex) => setSelectedFloorByFloorIndex(floorIndex);
    widget._callForwarder.setUserPositionFloor =
        (floorIndex) => userPositionFloor = floorIndex;
    widget._callForwarder.show = (show) => this.show(show);
    widget._callForwarder.zoomLevelChanged =
        (newZoomLevel) => zoomLevelChanged(newZoomLevel);
    if (widget._callForwarder.listener != null) {
      onFloorSelectionChangedListener = widget._callForwarder.listener!;
    }
  }

  @override
  Widget? getWidget() {
    return null;
  }

  @override
  bool get isAutoFloorChangeEnabled {
    return true;
  }

  @override
  set floors(List<MPFloor>? floors) {
    if (floors == null) {
      return;
    }
    List<MPFloor> list = List.from(floors);
    list.sort();
    setState(() {
      _floors.clear();
      _floors.addAll(list.reversed);
    });
  }

  @override
  set onFloorSelectionChangedListener(
      OnFloorSelectionChangedListener listener) {
    setState(() {
      _listener = listener;
    });
  }

  @override
  void setSelectedFloor(MPFloor floor) {
    _listener?.call(floor);
    setState(() {
      _selectedFloor = floor;
    });
  }

  @override
  void setSelectedFloorByFloorIndex(int floorIndex) {
    if (_floors.isEmpty) {
      return;
    }

    for (final floor in _floors) {
      if (floor.floorIndex == floorIndex) {
        setSelectedFloor(floor);
        return;
      }
    }
  }

  @override
  set userPositionFloor(int floorIndex) {
    setState(() {
      _userPositionFloor = floorIndex;
    });
  }

  @override
  void show(bool show) {
    if (_visible != show) {
      setState(() {
        _visible = show;
      });
    }
  }

  @override
  void zoomLevelChanged(num newZoomLevel) =>
      show(newZoomLevel >= showOnZoomLevel);

  @override
  Widget build(BuildContext context) {
    if (_visible && _floors.isNotEmpty) {
      return SizedBox(
        width: 50,
        height: 400,
        child: ListView.builder(
            itemCount: _floors.length,
            itemBuilder: (context, index) {
              return ElevatedButton(
                onPressed: () => setSelectedFloor(_floors[index]),
                style: (_floors[index] == _selectedFloor)
                    ? _buttonStyleWithColor(Colors.green)
                    : (_userPositionFloor == _floors[index].floorIndex)
                        ? _buttonStyleWithColor(Colors.amber)
                        : null,
                child: Text(_floors[index].displayName),
              );
            }),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

ButtonStyle _buttonStyleWithColor(Color color) {
  return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) => color));
}

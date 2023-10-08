import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:speed_guardian/utils/components.dart';
import 'package:speed_guardian/utils/utils.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

const fetchBackground = "fetchBackground";

class UserLiveLocation extends StatefulWidget {
  final String? pilotId;

  const UserLiveLocation({this.pilotId, super.key});

  @override
  UserLiveLocationState createState() => UserLiveLocationState();
}

class UserLiveLocationState extends State<UserLiveLocation> {
  Position? _currentPosition;
  late MapZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    _getCurrentPosition();
    _zoomPanBehavior = MapZoomPanBehavior(
        enableDoubleTapZooming: true,
        showToolbar: true,
        toolbarSettings: const MapToolbarSettings(
          position: MapToolbarPosition.topLeft,
          iconColor: Colors.red,
          itemBackgroundColor: Colors.green,
          itemHoverColor: Colors.blue,
        ));
    super.initState();
  }

  Future<bool> _handleLocationPermission() async {
    LocationPermission permission;

    await Geolocator.isLocationServiceEnabled();
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      } else {
        setState(() {});
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  Future<Position?> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return null;

    return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.medium)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
      });
      return position;
    }).catchError((e) {
      debugPrint("$e");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 25, 15, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Your Location",
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500)),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
              height: getHeight(context, 3),
              child: FutureBuilder(
                  future: _getCurrentPosition(),
                  builder: (BuildContext context,
                      AsyncSnapshot<Position?> snapshot) {
                    if (snapshot.hasData) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SfMaps(layers: [
                          MapTileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            initialMarkersCount: 1,
                            zoomPanBehavior: _zoomPanBehavior,
                            initialZoomLevel: 15,
                            initialFocalLatLng: MapLatLng(
                                _currentPosition!.latitude,
                                _currentPosition!.longitude),
                            markerBuilder: (BuildContext context, int index) {
                              return MapMarker(
                                  latitude: _currentPosition!.latitude,
                                  longitude: _currentPosition!.longitude,
                                  child: const Icon(Icons.location_on,
                                      color: themeBlue));
                            },
                          )
                        ]),
                      );
                    }
                    if (snapshot.hasError) {
                      return const Center(child: Text("Cannot load location."));
                    }
                    return const Center(
                        child: CircularProgressIndicator(
                      color: themeBlue,
                    ));
                  })),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:speed_guardian/utils/components.dart';
import 'package:speed_guardian/utils/utils.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:lit_relative_date_time/lit_relative_date_time.dart';

const fetchBackground = "fetchBackground";

class UserLocation extends StatefulWidget {
  final double? longitude;
  final double? latitude;
  final DateTime? timestamp;

  const UserLocation(this.longitude, this.latitude, this.timestamp,
      {super.key});

  @override
  UserLocationState createState() => UserLocationState();
}

class UserLocationState extends State<UserLocation> {
  double? longitude;
  double? latitude;
  DateTime? timestamp;
  late MapZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    super.initState();
    _zoomPanBehavior = MapZoomPanBehavior(
      enableDoubleTapZooming: true,
      toolbarSettings: const MapToolbarSettings(
        position: MapToolbarPosition.topLeft,
        iconColor: Colors.red,
        itemBackgroundColor: Colors.green,
        itemHoverColor: Colors.blue,
      ),
    );
    setState(() {
      latitude = widget.latitude;
      longitude = widget.longitude;
      timestamp = widget.timestamp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Location",
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w500)),
          const SizedBox(height: 5),
          if (timestamp != null)
            Row(
              children: [
                const Text("Last Updated: "),
                AnimatedRelativeDateTimeBuilder(
                  date: timestamp!,
                  builder: (relDateTime, formatted) {
                    return Text(
                      formatted,
                    );
                  },
                ),
              ],
            ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            height: getHeight(context, 3),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SfMaps(layers: [
                MapTileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  initialMarkersCount: 1,
                  zoomPanBehavior: _zoomPanBehavior,
                  initialZoomLevel: 15,
                  initialFocalLatLng: MapLatLng(latitude!, longitude!),
                  markerBuilder: (BuildContext context, int index) {
                    return MapMarker(
                        latitude: latitude!,
                        longitude: longitude!,
                        child: const Icon(
                          Icons.location_on,
                          color: themeBlue,
                          size: 24,
                        ));
                  },
                )
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

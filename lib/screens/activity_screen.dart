import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:iot_project/components/activity.dart';

class ActivityScreen extends StatelessWidget {

  Activity activity;
  MapController _mapController = MapController();

  ActivityScreen(Activity activity){
    this.activity = activity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 70, 122, 177),
          shadowColor: Colors.white54,
          title: Text(activity.getName())),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Flexible(
              child: Stack(
                fit: StackFit.loose,
                children: <Widget>[
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      interactiveFlags: InteractiveFlag.pinchZoom |
                      InteractiveFlag.drag |
                      InteractiveFlag.doubleTapZoom,
                      zoom: 15.0,
                    ),
                    layers: [
                      TileLayerOptions(
                          urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: ['a', 'b', 'c']),
                      PolylineLayerOptions(
                        polylines: [
                          Polyline(
                              points: activity.getPointsLatLng(),
                              strokeWidth: 4.0,
                              color: Colors.red),
                        ],
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: FloatingActionButton(
                        heroTag: null,
                        onPressed: () {
                          focusCurrentPosition();
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => new graphs_screen(activity: activity)));
                        },
                        child: Icon(Icons.center_focus_strong_outlined),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 2.0, bottom: 2.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void focusCurrentPosition() {
    _mapController.move(activity.getMiddlePoint().toLatLng(), 15);
  }
}

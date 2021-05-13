import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:iot_project/apps/components/activity.dart';
import 'package:latlong/latlong.dart';

class ActivityScreen extends StatelessWidget {
  static const String route = 'polyline';

  @override
  Widget build(BuildContext context) {

    var points = <LatLng>[
    LatLng(46.08615706484591, 13.242167779944976),
    LatLng(46.08568147422407, 13.242383775142438),
    LatLng(46.08547221447393, 13.24252091818285),
    LatLng(46.0846565612705, 13.242963196081739),
    LatLng(46.08414290991738, 13.242092351669527),
    ];

    Activity activity = new Activity("ActivityName", new DateTime(2020,10,10,12,00,00), points);


    return Scaffold(
      appBar: AppBar(title: Text('Activity Screen')),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text(activity.getName()),
            ),
            Flexible(
              child: FlutterMap(
                options: MapOptions(
                  center: activity.getMiddlePoint(),
                  zoom: 16.0,
                ),
                layers: [
                  TileLayerOptions(
                      urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c']),
                  PolylineLayerOptions(
                    polylines: [
                      Polyline(
                          points: points,
                          strokeWidth: 4.0,
                          color: Colors.red),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

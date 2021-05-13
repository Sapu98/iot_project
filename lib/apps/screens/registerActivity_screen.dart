import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:iot_project/apps/components/coordPoint.dart';
import 'package:iot_project/apps/components/user.dart';
import 'package:iot_project/apps/utilities/functions.dart';
import 'package:iot_project/apps/utilities/user_data.dart';


class RegisterActivityScreen extends StatefulWidget {
  @override
  _RegisterActivityScreenState createState() => _RegisterActivityScreenState();
}

class _RegisterActivityScreenState extends State<RegisterActivityScreen> {

  MapController _mapController = MapController();
  bool recording = false;
  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => addCurrentCoordPointToMap());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Register Activity"),
      ),
        body: Padding(
          padding: EdgeInsets.all(2.0),
          child: Column(
            children: [
              Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: FloatingActionButton(onPressed: () { focusCurrentPosition(); }, child: Icon(Icons.gps_fixed),),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: FloatingActionButton(onPressed: () {
                      setState(() {
                        recording = !recording;
                      });
                    }, child: Icon(Icons.cloud_upload_outlined)),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(onPressed: () {
                      setState(() {
                        recording = !recording;
                      });
                    }, child: recording ? Icon(Icons.pause) : Icon(Icons.play_arrow)),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 2.0, bottom: 2.0),
                child: Text(UserData.liveActivity.getLastPos().toString()),
              ),
              Flexible(
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag | InteractiveFlag.doubleTapZoom,
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
                            points: UserData.liveActivity.getPointsLatLng(),
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

  void addCurrentCoordPointToMap() async{
    CoordPoint point = await getCoordPoint(context);
    setState(() {
      if(recording) {
        UserData.liveActivity.addPoint(point);
      }
    });
  }

  void focusCurrentPosition(){
    if(UserData.liveActivity.getCoordPoints().length==0){
      showWindowDialog("Start the recording to be able to see your position", context);
    }
    _mapController.move(UserData.liveActivity.getMiddlePoint().toLatLng(), 15);
  }
}

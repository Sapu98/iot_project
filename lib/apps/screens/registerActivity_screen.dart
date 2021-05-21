import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:iot_project/apps/components/activity.dart';
import 'package:iot_project/apps/components/coordPoint.dart';
import 'package:iot_project/apps/utilities/functions.dart';
import 'package:iot_project/apps/utilities/user_data.dart';
import 'package:wakelock/wakelock.dart';

class RegisterActivityScreen extends StatefulWidget {
  RegisterActivityScreen({@required this.updateHomePage});
  final Function() updateHomePage;

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

  Future<bool> _onWillPop() async {
    return showDialog(
      context: context,
      builder: (context) =>
      new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Unsaved records will be lost'),
        actions: <Widget>[
          new TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new TextButton(
            onPressed: () async {
              UserData.activities = await getUserActivitiesSQL();
              setState(() {
                widget.updateHomePage();
              });
              Navigator.of(context).pop(true);
            },
            child: new Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _onUpload() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Save Activity now?'),
        content: new Text('This will stop your recording and upload your activity.'),
        actions: <Widget>[
          new TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new TextButton(
            onPressed: () {
              setState(() {
                recording = false;
                _registerActivity();
                _resetLiveActivity();
                Navigator.of(context).pop(true);
              });
            },
            child: new Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        //onWillPop = on back button pressed
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Register Activity"),
          ),
          body: Padding(
            padding: EdgeInsets.all(2.0),
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
                                  points:
                                      UserData.liveActivity.getPointsLatLng(),
                                  strokeWidth: 4.0,
                                  color: Colors.red),
                            ],
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: FloatingActionButton(
                            heroTag: null,
                            onPressed: () {
                              if(UserData.liveActivity.getCoordPoints().isEmpty){
                                showWindowDialog("There is no Activy to upload, start recording.", context);
                              }else {
                                _onUpload();
                              }
                            },
                            child: Icon(Icons.cloud_upload_outlined)),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 80.0),
                          child: FloatingActionButton(
                            heroTag: null,
                            onPressed: () {
                              focusCurrentPosition();
                            },
                            child: Icon(Icons.gps_fixed),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton(
                            heroTag: null,
                            onPressed: () {
                              setState(() {
                                recording = !recording;
                                recording ? Wakelock.enable() : Wakelock.disable();
                              });
                            },
                            child: recording
                                ? Icon(Icons.pause)
                                : Icon(Icons.play_arrow)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2.0, bottom: 2.0),
                        child: Text(
                            UserData.liveActivity.getLastPos().toLatLng().toString()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _registerActivity() async {
    final Map<String, String> body = {
      'activity_name': getEncryptedString(UserData.liveActivity.getName()),
      'date_time': getEncryptedString(UserData.liveActivity.getFirstPos().getDateTime()),
      'user_id': getEncryptedString(UserData.user.getId().toString()),
      'coordPoints': getEncryptedString(UserData.liveActivity.getCoordPoints().toString()),
    };
    //upload activity
    String response = await makePostRequest(url, registerActivityPath, header, body);
    showWindowDialog(response, context);
  }

  void addCurrentCoordPointToMap() async {
    if (recording) {
      CoordPoint point = await getCoordPoint(context);
      setState(() {
        UserData.liveActivity.addPoint(point);
      });
    }
  }
  void _resetLiveActivity(){
    recording = false;
    UserData.liveActivity = new Activity("Latest Activity", <CoordPoint>[]);
  }

  void focusCurrentPosition() {
    if (UserData.liveActivity.getCoordPoints().length == 0) {
      showWindowDialog(
          "Start the recording and wait for the first position to be able to focus on it", context);
    }
    _mapController.move(UserData.liveActivity.getMiddlePoint().toLatLng(), 15);
  }
}

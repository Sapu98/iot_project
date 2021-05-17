
import 'package:flutter/material.dart';
import 'package:iot_project/apps/components/activity.dart';
import 'package:iot_project/apps/components/activity_row.dart';
import 'package:iot_project/apps/components/coordPoint.dart';
import 'package:iot_project/apps/screens/registerActivity_screen.dart';
import 'package:iot_project/apps/utilities/user_data.dart';

import 'activity_screen.dart';

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  Activity getActivityTest() {
    var points = <CoordPoint>[
      CoordPoint(46.08615706484591, 13.242167779944976, 0,0,null),
      CoordPoint(46.08568147422407, 13.242383775142438, 0,0,null),
      CoordPoint(46.08547221447393, 13.24252091818285, 0,0,null),
      CoordPoint(46.0846565612705, 13.242963196081739, 0,0,null),
      CoordPoint(46.08414290991738, 13.242092351669527, 0,0,null),
    ];
    Activity activity = new Activity("ActivityName", points);
    return activity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Welcome, " + UserData.user.getUsername()),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          for(Activity activity in UserData.activities)
          ActivityRow(activity: activity, activityInstance: ActivityScreen(activity)),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterActivityScreen()),);
        },
      ),
    );
  }
}

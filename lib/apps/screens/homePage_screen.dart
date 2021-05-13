import 'package:flutter/material.dart';
import 'package:iot_project/apps/components/activity.dart';
import 'package:iot_project/apps/components/activity_row.dart';
import 'package:iot_project/apps/screens/registerActivity_screen.dart';
import 'package:iot_project/apps/utilities/user_data.dart';
import 'package:latlong/latlong.dart';

import 'activity_screen.dart';

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {

   Activity getActivityTest(){
    List<LatLng> list;
    list.add(new LatLng(46.08615706484591, 13.242167779944976));
    list.add(new LatLng(46.08568147422407, 13.242383775142438));
    list.add(new LatLng(46.08547221447393, 13.24252091818285));
    list.add(new LatLng(46.0846565612705, 13.242963196081739));
    list.add(new LatLng(46.08414290991738, 13.242092351669527));
    return new Activity("ActivityName", new DateTime(2020,10,10,12,00,00), list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Welcome, " + UserData.user.username),
      ),
      body: SingleChildScrollView(
          child:
          Column(
            children: [
              SizedBox(height: 2,),
              ActivityRow(activityInstance: ActivityScreen()),
            ],
          )
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterActivityScreen()),
          );
        },
      ),
    );
  }

  void _getActivities(){

  }
}

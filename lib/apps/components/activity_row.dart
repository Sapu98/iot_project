import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot_project/apps/components/activity.dart';
import 'package:iot_project/apps/utilities/functions.dart';

import 'coordPoint.dart';

class ActivityRow extends StatefulWidget {

  ActivityRow({this.activityInstance, this.activity});
  final Widget activityInstance;
  final Activity activity;

  @override
  State<ActivityRow> createState() => _ActivityRowState();
}

class _ActivityRowState extends State<ActivityRow> {

  final String url = "sapu.hopto.org:20080";
  final String unencodedPath = "/iotProject/getCoordinates.php";
  final Map<String, String> header = {
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.grey.shade300,
      child: Row(
        children: [
          Icon(Icons.account_tree_outlined, size: 14),
          SizedBox(width: 10),
          Text(widget.activity.getName(), style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Container()),
          TextButton(onPressed: () async {
            widget.activity.setCoordPoints(await getActivityCoordPointsSQL(widget.activity.getId().toString()));
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => widget.activityInstance),
            );
          } ,
              child: Icon(Icons.arrow_forward_ios_outlined, size: 14)),
        ],
      ),
    );
  }

  Future<List<CoordPoint>> getActivityCoordPointsSQL(String id) async{
    final Map<String, String> body = {
      'activity_id': getEncryptedString(id),
    };
    String result = await makePostRequest(url, unencodedPath, header, body);

    List<CoordPoint> coordPoints = [];
    List<String> allRows = result.split("#");
    allRows.removeAt(0);

    for(String row in allRows) {
      List<String> splittedRow = row.split("*");
      double latitude = double.parse(splittedRow[0]);
      double longitude = double.parse(splittedRow[1]);
      double altitude = double.parse(splittedRow[2]);
      double speed = double.parse(splittedRow[3]);
      String dateTime = splittedRow[4];

      CoordPoint coordPoint = new CoordPoint(latitude, longitude, altitude, speed, dateTime);
      coordPoints.add(coordPoint);
    }
    return coordPoints;
  }
}
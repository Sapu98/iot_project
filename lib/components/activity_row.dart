import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot_project/components/activity.dart';
import 'package:iot_project/screens/activity_screen.dart';
import 'package:iot_project/utilities/functions.dart';
import 'package:iot_project/utilities/user_data.dart';

import 'coordPoint.dart';

class ActivityRow extends StatefulWidget {
  ActivityRow({this.activity, @required this.updateHomePage});

  final Activity activity;
  final Function() updateHomePage;

  @override
  State<ActivityRow> createState() => _ActivityRowState();
}

class _ActivityRowState extends State<ActivityRow> {
  final textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.grey.shade300,
      child: Row(
        children: [
          Icon(Icons.account_tree_outlined, size: 14),
          SizedBox(width: 10),
          TextButton(
              onPressed: () async {
                widget.activity.setCoordPoints(await getActivityCoordPointsSQL(
                    widget.activity.getId().toString()));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new ActivityScreen(widget.activity)),
                );
              },
              child: Text(widget.activity.getName(),
                  style: TextStyle(color: Colors.black))),
          Expanded(child: Container()),
          SizedBox(
            width: 40,
            child: TextButton(
                onPressed: () {
                  _onDelete();
                },
                child: Icon(Icons.delete, size: 18)),
          ),
          SizedBox(
            width: 35,
            child: TextButton(
                onPressed: () {
                  _onEdit();
                },
                child: Icon(Icons.edit, size: 18)),
          ),
          SizedBox(
            width: 32,
            child: TextButton(
                onPressed: () async {
                  widget.activity.setCoordPoints(
                      await getActivityCoordPointsSQL(
                          widget.activity.getId().toString()));
                  Navigator.push(context, MaterialPageRoute(builder: (context) => new ActivityScreen(widget.activity)),
                  );
                },
                child: Icon(Icons.arrow_forward_ios_outlined, size: 14)),
          )
        ],
      ),
    );
  }

  Future<List<CoordPoint>> getActivityCoordPointsSQL(String id) async {
    final Map<String, String> body = {
      'activity_id': getEncryptedString(id),
    };
    String result =
        await makePostRequest(url, getCoordinatesPath, header, body);

    List<CoordPoint> coordPoints = [];
    List<String> allRows = result.split("#");
    allRows.removeAt(0);

    for (String row in allRows) {
      List<String> splittedRow = row.split("*");
      double latitude = double.parse(splittedRow[0]);
      double longitude = double.parse(splittedRow[1]);
      double altitude = double.parse(splittedRow[2]);
      double speed = double.parse(splittedRow[3]);
      String dateTime = splittedRow[4];

      CoordPoint coordPoint =
          new CoordPoint(latitude, longitude, altitude, speed, dateTime);
      coordPoints.add(coordPoint);
    }
    return coordPoints;
  }

  void _onDelete() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Delete Activity?'),
        content: new Text('This Activity will be deleted forever'),
        actions: <Widget>[
          new TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new TextButton(
            onPressed: () async {
              setState(() {
                for (int i = 0; i < UserData.activities.length; i++) {
                  if (UserData.activities[i].getId() ==
                      widget.activity.getId()) {
                    UserData.activities.remove(UserData.activities[i]);
                  }
                }
                //aggiorna lo stato del parent (senno la row rimarrebbe)
                widget.updateHomePage();
              });
              final Map<String, String> body = {
                'activity_id':
                    getEncryptedString(widget.activity.getId().toString()),
              };
              String result =
                  await makePostRequest(url, deleteActivityPath, header, body);
              print(result);
              Navigator.of(context).pop(true);
            },
            child: new Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _onEdit() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Edit Activity name.'),
        content: TextField(
          controller: textFieldController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: widget.activity.getName(),
          ),
        ),
        actions: <Widget>[
          new TextButton(
            onPressed: () async {
              if (textFieldController.text.length > 3) {
                setState(() {
                  for (int i = 0; i < UserData.activities.length; i++) {
                    if (UserData.activities[i].getId() ==
                        widget.activity.getId()) {
                      UserData.activities[i].setName(textFieldController.text);
                    }
                  }
                  //aggiorna lo stato del parent (senno la row rimarrebbe)
                  widget.updateHomePage();
                });
                final Map<String, String> body = {
                  'activity_id':
                      getEncryptedString(widget.activity.getId().toString()),
                  'new_name': getEncryptedString(textFieldController.text),
                };
                String result = await makePostRequest(
                    url, renameActivityPath, header, body);
                print(result);
              }
              Navigator.of(context).pop(true);
            },
            child: new Text('ok'),
          ),
        ],
      ),
    );
  }
}

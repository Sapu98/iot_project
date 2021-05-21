
import 'package:flutter/material.dart';
import 'package:iot_project/apps/components/activity.dart';
import 'package:iot_project/apps/components/activity_row.dart';
import 'package:iot_project/apps/screens/registerActivity_screen.dart';
import 'package:iot_project/apps/utilities/user_data.dart';

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {

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
            Column(children:[
              SizedBox(height: 2,),
              ActivityRow(activity: activity, updateHomePage: refresh),
            ]
            )
        ],
      )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterActivityScreen(updateHomePage: refresh)),);
        },
      ),
    );
  }
  refresh() {
    setState(() {});
  }
}

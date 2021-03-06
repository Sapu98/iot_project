
import 'package:flutter/material.dart';
import 'package:iot_project/components/activity.dart';
import 'package:iot_project/components/activity_row.dart';
import 'package:iot_project/screens/registerActivity_screen.dart';
import 'package:iot_project/utilities/functions.dart';
import 'package:iot_project/utilities/user_data.dart';

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 30, 52, 76),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 70, 122, 177),
        shadowColor: Colors.white54,
        centerTitle: true,
        title: Text("Welcome, " + UserData.user.getUsername()),
      ),
      body: SingleChildScrollView(
          child: Column(
            children: [
              for(Activity activity in UserData.activities)
                Column(children: [
                  SizedBox(height: 2,),
                  ActivityRow(activity: activity, updateHomePage: refresh),
                ]
                )
            ],
          )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          if (UserData.user.isActivated()) {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                RegisterActivityScreen(updateHomePage: refresh)),);
          }else{
            showWindowDialog("Error: User not activated, check email spam", context);
          }
        },
      ),
    );
  }
  refresh() {
    setState(() {});
  }
}

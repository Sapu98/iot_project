import 'package:flutter/material.dart';
import 'package:iot_project/apps/utilities/functions.dart';


class RegisterActivityScreen extends StatefulWidget {
  @override
  _RegisterActivityScreenState createState() => _RegisterActivityScreenState();
}

class _RegisterActivityScreenState extends State<RegisterActivityScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Register Activity"),
      ),
      body: SingleChildScrollView(
          child:
          Column(
            children: [
              SizedBox(height: 2,),
              //ActivityRow(activityInstance: HelloWorld()),
              TextButton(onPressed: () async {
                print(await determinePosition());
              }, child: Text("getCoords"))
            ],
          )
      ),
    );
  }
}

import 'package:iot_project/apps/components/activity.dart';
import 'package:iot_project/apps/components/coordPoint.dart';
import 'package:iot_project/apps/components/user.dart';

class UserData{
  static User user;
  static List<Activity> activities;
  static Activity liveActivity = new Activity("Latest Activity", <CoordPoint>[]);
}
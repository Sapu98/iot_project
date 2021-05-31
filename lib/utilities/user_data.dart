import 'package:iot_project/components/activity.dart';
import 'package:iot_project/components/coordPoint.dart';
import 'package:iot_project/components/user.dart';

final String url = "sapu.hopto.org:20080";
final Map<String, String> header = {
  'Content-Type': 'application/x-www-form-urlencoded'
};

final String loginPath = "/iotProject/login.php";
final String getCoordinatesPath = "/iotProject/getCoordinates.php";
final String registerPath = "/iotProject/register.php";
final String registerActivityPath = "/iotProject/registerActivity.php";
final String deleteActivityPath = "/iotProject/deleteActivity.php";
final String renameActivityPath = "/iotProject/renameActivity.php";
final String getActivityPath = "/iotProject/getActivity.php";

class UserData{
  static User user;
  static List<Activity> activities;
  static Activity liveActivity = new Activity("Latest Activity", <CoordPoint>[]);
  static Activity graphedActivity;

}
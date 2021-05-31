import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:iot_project/components/activity.dart';
import 'package:iot_project/components/coordPoint.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iot_project/utilities/user_data.dart';

final key = encrypt.Key.fromUtf8('MySecretKeyForEncryptionAndDecry'); //32 chars
final iv = encrypt.IV.fromUtf8('helloworldhellow'); //16 chars
final encrypter = encrypt.Encrypter(encrypt.AES(key));

Future<String> makePostRequest(String url, String unencodedPath, Map<String, String> header, Map<String, String> requestBody) async {
  final response = await http.post(
    Uri.http(url, unencodedPath),
    headers: header,
    body: requestBody,
  );
  if(response.statusCode==200 && response.body.isNotEmpty) {
    return getDecryptedString(response.body);
  }else{
    return response.body;
  }
}

void showWindowDialog(String message, BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //Oltre al messaggio di risposta per l'utente, vengono inviati dati come id e activation code dopo "***"
          title: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('ok!'),
              onPressed: () {
                Navigator.of(context).pop();
                if (message.contains("check your email")) {
                  Navigator.of(context).pop();
                }
              },
            )
          ],
        );
      });
}

Future<Position> _determinePosition(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    showWindowDialog('Location services are disabled.', context);
    return Future.error('Location services are disabled.');
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      showWindowDialog('Location permissions are denied', context);
      return Future.error('Location permissions are denied');
    }
  }
  if (permission == LocationPermission.deniedForever) {
    showWindowDialog('Location permissions are permanently denied, we cannot request permissions.', context);
    return Future.error('Location permissions are permanently denied, we cannot request permissions.');
  }
  return await Geolocator.getCurrentPosition();
}

Future<List<Activity>> getUserActivitiesSQL() async{
  final Map<String, String> body = {
    'user_id': getEncryptedString(UserData.user.getId().toString()),
  };
  //TODO LA STRINGA
  String result = await makePostRequest(url, getActivityPath, header, body);

  List<Activity> activities = [];

  List<String> allRows = result.split("#");
  allRows.removeAt(0);

  for(String row in allRows) {
    List<String> splittedRow = row.split("*");
    String activityName = splittedRow[1];
    int activityId = int.parse(splittedRow[0]);
    Activity activity = new Activity(activityName, <CoordPoint>[]);
    activity.setId(activityId);
    activities.add(activity);
  }
  return activities;
}

Future<CoordPoint> getCoordPoint(BuildContext context) async {
  Position position = (await _determinePosition(context));
  double longitude = position.longitude;
  double latitude = position.latitude;
  double altitude = position.altitude;
  double speed = position.speed;

  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd H:m:s');
  String dateTime = formatter.format(now);

  CoordPoint coordPoint = new CoordPoint(latitude, longitude, altitude, speed, dateTime);
  return coordPoint;
}

String getEncryptedString(String input) {
  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  final encrypted = encrypter.encrypt(input, iv: iv);
  return encrypted.base64;
}

String getDecryptedString(String input) {
  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  final decrypted = encrypter.decrypt(Encrypted.fromBase64(input), iv: iv);
  return decrypted;
}

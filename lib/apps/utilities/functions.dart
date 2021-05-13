import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iot_project/apps/components/activity.dart';
import 'package:iot_project/apps/components/user.dart';
import 'package:iot_project/apps/screens/homepage_screen.dart';
import 'package:geolocator/geolocator.dart';


final key = encrypt.Key.fromUtf8('MySecretKeyForEncryptionAndDecry'); //32 chars
final iv = encrypt.IV.fromUtf8('helloworldhellow'); //16 chars
final encrypter = encrypt.Encrypter(encrypt.AES(key));

Future<String> makePostRequest(String url, String unencodedPath, Map<String, String> header, Map<String, String> requestBody) async {
  final response = await http.post(
    Uri.http(url, unencodedPath),
    headers: header,
    body: requestBody,
  );
  return getDecryptedString(response.body);
}

void showWindowDialog(String message, BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //Oltre al messaggio di risposta per l'utente, vengono inviati dati come id e activation code dopo "***"
          title: Text(message.contains("***") ? message.substring(0,message.lastIndexOf("***")) : message),
          actions: <Widget>[
            TextButton(
              child: Text('ok!'),
              onPressed: () {
                Navigator.of(context).pop();
                if (message.contains("check your email")) {
                  Navigator.of(context).pop();
                } else if (message.contains("Successful login")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePageScreen()),
                  );
                }
              },
            )
          ],
        );
      });
}

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  return await Geolocator.getCurrentPosition();
}

List<Activity> getActivities(User user){
  //TODO: da fare

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

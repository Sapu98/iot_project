import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iot_project/apps/screens/HomePage.dart';

final key = encrypt.Key.fromUtf8('MySecretKeyForEncryptionAndDecry'); //32 chars
final iv = encrypt.IV.fromUtf8('helloworldhellow'); //16 chars
final encrypter = encrypt.Encrypter(encrypt.AES(key));

Future<http.Response> makePostRequest(BuildContext context, String url, String unencodedPath , Map<String, String> header, Map<String,String> requestBody) async {
  final response = await http.post(
    Uri.http(url,unencodedPath),
    headers: header,
    body: requestBody,
  );
  print(response.statusCode);
  print(response.body);
  _showWinDialog(getDecryptedString(response.body), context);
}

void _showWinDialog(String message, BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('ok!'),
              onPressed: () {
                Navigator.of(context).pop();
                if(message.contains("check your email")) {
                  Navigator.of(context).pop();
                }else if(message.contains("successful login")){
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

String getEncryptedString(String input){
  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  final encrypted = encrypter.encrypt(input, iv: iv);
  return encrypted.base64;
}
String getDecryptedString(String input){
  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  final decrypted = encrypter.decrypt(Encrypted.fromBase64(input), iv: iv);
  return decrypted;
}
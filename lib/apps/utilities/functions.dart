import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<http.Response> makePostRequestDialog(BuildContext context, String url, String unencodedPath , Map<String, String> header, Map<String,String> requestBody) async {
  final response = await http.post(
    Uri.http(url,unencodedPath),
    headers: header,
    body: requestBody,
  );
  print(response.statusCode);
  print(response.body);
  showWinDialog(response.body, context);
}

Future<http.Response> makePostRequest(String url, String unencodedPath , Map<String, String> header, Map<String,String> requestBody) async {
  final response = await http.post(
    Uri.http(url,unencodedPath),
    headers: header,
    body: requestBody,
  );
  print(response.statusCode);
  print(response.body);
}

void showWinDialog(String message, BuildContext context) {
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
                }
              },
            )
          ],
        );
      });
}
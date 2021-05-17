import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iot_project/apps/components/activity.dart';
import 'package:iot_project/apps/components/coordPoint.dart';
import 'package:iot_project/apps/components/user.dart';
import 'package:iot_project/apps/screens/register_screen.dart';
import 'package:iot_project/apps/utilities/constants.dart';
import 'package:iot_project/apps/utilities/functions.dart';
import 'package:iot_project/apps/utilities/user_data.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  final String url = "sapu.hopto.org:20080";
  final String unencodedPath = "/iotProject/login.php";
  final Map<String, String> header = {
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: mailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your Email',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: passwordController,
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          //TODO: onPress
          print('Login Button Pressed');
          String password = getEncryptedString(passwordController.text);
          String mail = getEncryptedString(mailController.text);

          final Map<String, String> requestBody = {
            'mail': mail,
            'password': password
          };
          String response = await makePostRequest(url, unencodedPath, header, requestBody);
          showWindowDialog(response, context);
          //TODO: metodo per prendere i dati da cambiare...
          String username = response.substring(response.lastIndexOf("***username:")+12,response.lastIndexOf(" id:"));
          int id = int.parse(response.substring(response.lastIndexOf(" id:")+4,response.lastIndexOf(" activated:")));
          bool activated = response.substring(response.lastIndexOf(" activated:")+11) == "true"; //in dart non esiste un modo per passare da stringa a boolean

          UserData.user = new User(id, activated, username, mail);
          //si potrebbe fare in un'unica richiesta, passando in un formato json
          UserData.activities = await getUserActivitiesSQL();
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'LOGIN',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () {
        print('Sign Up Button Pressed');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegisterScreen()),
        );
      },
      child: RichText(
        text: TextSpan(
          text: 'Sign Up',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF73AEF5),
                      Color(0xFF61A4F1),
                      Color(0xFF478DE0),
                      Color(0xFF398AE5),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      _buildEmailTF(),
                      SizedBox(
                        height: 30.0,
                      ),
                      _buildPasswordTF(),
                      _buildLoginBtn(),
                      _buildSignupBtn(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Future<List<Activity>> getUserActivitiesSQL() async{
    final Map<String, String> body = {
      'user_id': getEncryptedString(UserData.user.getId().toString()),
    };
    String result = await makePostRequest(url, "/iotProject/getActivity.php", header, body);

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
}

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/image_render.dart';
import 'package:http/http.dart';

class IotProject extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: new MyHomePage(title: 'Iot project'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

_makePostRequest() async {
// set up POST request arguments
  final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = '{"title": "Hello", "body": "body text", "userId": 1}';
  // make POST request
  Response response = await post(url, headers: headers, body: json);
  // check the status code for the result
  int statusCode = response.statusCode;
  // this API passes back the id of the new item added to the body
  String body = response.body;
  // {
  //   "title": "Hello",
  //   "body": "body text",
  //   "userId": 1,
  //   "id": 101
  // }
}

const htmlData = """
<h1>Title</h1>
<iframe src='http://7d96a14659ee.ngrok.io/d-solo/e5HtikkRz/czclog?orgId=1&refresh=5m&from=1614350624345&to=1616939024345&panelId=2' width='450' height='200' frameborder='0'></iframe>
""";

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('flutter_html Example'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Html(
          data: htmlData,
          //Optional parameters:
          customImageRenders: {
            networkSourceMatcher(domains: ["flutter.dev"]):
                (context, attributes, element) {
              return FlutterLogo(size: 36);
            },
            networkSourceMatcher(domains: ["mydomain.com"]): networkImageRender(
              headers: {"Custom-Header": "some-value"},
              altWidget: (alt) => Text(alt),
              loadingWidget: () => Text("Loading..."),
            ),
            // On relative paths starting with /wiki, prefix with a base url
            (attr, _) => attr["src"] != null && attr["src"].startsWith("/wiki"):
                networkImageRender(
                    mapUrl: (url) => "https://upload.wikimedia.org" + url),
            // Custom placeholder image for broken links
            networkSourceMatcher():
                networkImageRender(altWidget: (_) => FlutterLogo()),
          },
          onLinkTap: (url) {
            print("Opening $url...");
          },
          onImageTap: (src) {
            print(src);
          },
          onImageError: (exception, stackTrace) {
            print(exception);
          },
        ),
      ),
    );
  }
}

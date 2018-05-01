import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Firebase Messaging',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Firebase Messaging'),
    );
  }
}

final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _code = "Not aviable";
  String _debug = " ";

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print("onMessage: $message");
        _incrementCounter(message);
      },
      onLaunch: (Map<String, dynamic> message) {
        print("onLaunch: $message");
        _incrementCounter(message);
      },
      onResume: (Map<String, dynamic> message) {
        print("onResume: $message");
        _incrementCounter(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        _code = "$token";
      });
    });
    _firebaseMessaging.subscribeToTopic("memes");
  }

  void _incrementCounter(Map<String, dynamic> message) {
    setState(() {
      _counter++;
      _debug = message.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'There have been this many messages: ',
            ),
            new Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
            new Text(
              'Id: $_code'
            ),
            new Text(
              'Debug: $_debug'
            )
          ],
        ),
      ),
    );
  }
}

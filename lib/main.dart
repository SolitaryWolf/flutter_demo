import 'package:flutter/material.dart';
import 'package:appcenter/appcenter.dart';
import 'package:appcenter_analytics/appcenter_analytics.dart';
import 'package:appcenter_crashes/appcenter_crashes.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/foundation.dart' show TargetPlatform;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Config app center
  final ios = defaultTargetPlatform == TargetPlatform.iOS;
  String appSecret = ios
      ? "f1bcf00c-6599-455d-aede-dc4d654cac71"
      : "6b3e2120-cd12-45b9-893e-b93d19dd031f";
  await AppCenter.start(
      appSecret, [AppCenterAnalytics.id, AppCenterCrashes.id]);

  runApp(MyApp());
  print('update1');
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CrashHome(),
    );
  }
}

class CrashHome extends StatefulWidget {
  @override
  _CrashHomeState createState() => _CrashHomeState();
}

class _CrashHomeState extends State<CrashHome> {
  String _installId = 'Unknown';
  bool _areAnalyticsEnabled = false, _areCrashesEnabled = false;

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  initPlatformState() async {
    if (!mounted) return;

    var installId = await AppCenter.installId;
    var areAnalyticsEnabled = await AppCenterAnalytics.isEnabled;
    var areCrashesEnabled = await AppCenterCrashes.isEnabled;

    setState(() {
      _installId = installId;
      _areAnalyticsEnabled = areAnalyticsEnabled;
      _areCrashesEnabled = areCrashesEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appcenter plugin example app'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Install identifier:\n $_installId'),
          Text('Analytics: $_areAnalyticsEnabled'),
          Text('Crashes: $_areCrashesEnabled'),
          RaisedButton(
            child: Text('Generate test crash'),
            onPressed: AppCenterCrashes.generateTestCrash,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Send events'),
              IconButton(
                icon: Icon(Icons.map),
                tooltip: 'map',
                onPressed: () {
                  AppCenterAnalytics.trackEvent("map");
                },
              ),
              IconButton(
                icon: Icon(Icons.casino),
                tooltip: 'casino',
                onPressed: () {
                  AppCenterAnalytics.trackEvent("casino", {"dollars": "10"});
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'pages/login_page.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('qrList');
  dataEntry();
  runApp(const MyApp());
}

void dataEntry() async {
  final _qrList = Hive.box('qrList');
  await _qrList.clear();
  const value1 = {"eventName": "MoodI", 'uID': "saca", 'eventID': 'cacs4'};
  const value2 = {
    "eventName": "TechFest",
    'uID': "1asca",
    'eventID': '1acca34'
  };
  const value3 = {"eventName": "E-Summit", 'uID': "acvs", 'eventID': 'accc'};
  await _qrList.add(value1);
  await _qrList.add(value2);
  await _qrList.add(value3);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

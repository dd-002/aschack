import 'package:aschack/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/login_page.dart';

// void main() async {
//   await Hive.initFlutter();
//   await Hive.openBox('qrList');
//   isUserLoggedIn();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: !isUserLogged ? LoginPage() : HomeScreen(),
//     );
//   }
// }

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox('qrList');
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var isUserLoggedIn = prefs.getBool("loggedIn");
  // ignore: unnecessary_null_comparison
  isUserLoggedIn = isUserLoggedIn == null ? false : true;
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: !isUserLoggedIn ? LoginPage() : const HomeScreen(),
  ));
}

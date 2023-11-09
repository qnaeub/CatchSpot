import 'package:flutter/material.dart';
import 'package:flutter_app/screens/intro_screen.dart';
import 'package:flutter_app/screens/management_screen.dart';
import 'package:flutter_app/screens/navigate_screen.dart';
import 'package:flutter_app/screens/parkingSpace_screen.dart';
import 'package:flutter_app/screens/search_screen.dart';
import 'package:flutter_app/screens/setReserveInfo.dart';
import 'package:flutter_app/screens/finishReserve.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      routes: {
        '/navigate': (context) => NavigateScreen(),
        '/search': (context) => SearchScreen(),
        '/manage': (context) => ManageScreen(),
        '/setinfo': (context) =>
            SetReserveInfo(realTime: ValueNotifier<bool>(true)),
        '/parking-space': (context) =>
            ParkingSpaceScreen(data: ValueNotifier<bool>(false)),
        '/pre-reservation': (context) => PreReservation(),
        '/finish-reserve': (context) => FinishReserve(),
      },
      debugShowCheckedModeBanner: false,
      home: IntroScreen(),
      //initialRoute: '/'
    );
  }
}

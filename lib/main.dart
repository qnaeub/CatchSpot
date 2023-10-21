import 'package:flutter/material.dart';
import 'package:flutter_app/screens/intro_screen.dart';
import 'package:flutter_app/screens/management_screen.dart';
import 'package:flutter_app/screens/navigate_screen.dart';
import 'package:flutter_app/screens/search_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        //theme: ThemeData(primarySwatch: Colors.purple),
        routes: {
          '/navigate': (context) => NavigateScreen(),
          '/search': (context) => SearchScreen(),
          '/manage': (context) => ManageScreen()
        },
        home: SearchScreen()
        //initialRoute: '/'
        );
  }
}

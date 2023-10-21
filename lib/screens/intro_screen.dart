import 'package:flutter/material.dart';
import 'package:flutter_app/shared/menu_bottom.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Catch Spot')),
      bottomNavigationBar: MenuBottom(100),
    );
  }
}

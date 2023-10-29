import 'package:flutter/material.dart';
import 'package:flutter_app/shared/menu_bottom.dart';

class NavigateScreen extends StatelessWidget {
  const NavigateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          title: Text(
            '내비게이션',
            style: TextStyle(color: Color(0xff6528F7)),
          ),
          centerTitle: true,
          backgroundColor: Color(0xffFFFFFF),
          elevation: 1,
          automaticallyImplyLeading: false,
        ),
      ),
      body: Center(child: Text("Navigate")),
      bottomNavigationBar: MenuBottom(0),
    );
  }
}

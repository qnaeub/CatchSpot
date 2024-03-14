import 'package:flutter/material.dart';
import 'package:flutter_app/shared/menu_bottom.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class NavigateScreen extends StatefulWidget {
  const NavigateScreen({Key? key}) : super(key: key);

  @override
  State<NavigateScreen> createState() => _NavigateScreenState();
}

class _NavigateScreenState extends State<NavigateScreen> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  UnityWidgetController? _unityWidgetController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
      body: SafeArea(
        // new
        bottom: false,
        child: WillPopScope(
          onWillPop: () async {
            // Pop the category page if Android back button is pressed.
            return true;
          },
          child: Container(
            color: Colors.yellow,
            child: UnityWidget(
              onUnityCreated: onUnityCreated,
              //fullscreen: true,
            ),
          ),
        ),
      ),
      //Center(child: Text("Navigate")),
      bottomNavigationBar: MenuBottom(0),
    );
  }

  void onUnityCreated(controller) {
    _unityWidgetController = controller;
  }
}

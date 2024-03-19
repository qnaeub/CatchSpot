import 'package:flutter/material.dart';
import 'package:flutter_app/shared/menu_bottom.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigateScreen extends StatefulWidget {
  const NavigateScreen({Key? key}) : super(key: key);

  @override
  State<NavigateScreen> createState() => _NavigateScreenState();
}

class _NavigateScreenState extends State<NavigateScreen> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  UnityWidgetController? _unityWidgetController;

  late SharedPreferences _pref;
  String _processState = "";

  @override
  void initState() {
    super.initState();
    _getProcessState();
  }

  // 예약 현황 불러오기
  _getProcessState() async {
    _pref = await SharedPreferences.getInstance();
    setState(() {
      _processState = _pref.getString("processState") ?? "";
    });
  }

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
      body:
          _processState == "예약완료" || _processState == "주차완료" // 수정하기: 예약완료->입차완료
              ? SafeArea(
                  // new
                  bottom: false,
                  child: WillPopScope(
                    onWillPop: () async {
                      // Pop the category page if Android back button is pressed.
                      return true;
                    },
                    child: Container(
                      color: Colors.black,
                      child: UnityWidget(
                        onUnityCreated: onUnityCreated,
                        //fullscreen: true,
                      ),
                    ),
                  ),
                )
              : Center(child: Text("주차장 내에서 이용 가능한 기능입니다")),
      bottomNavigationBar: MenuBottom(0),
    );
  }

  void onUnityCreated(controller) {
    _unityWidgetController = controller;
  }
}

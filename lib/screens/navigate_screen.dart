import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/shared/menu_bottom.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_app/screens/search_screen.dart';
import 'package:sensors_plus/sensors_plus.dart';

class NavigateScreen extends StatefulWidget {
  const NavigateScreen({Key? key}) : super(key: key);

  @override
  State<NavigateScreen> createState() => _NavigateScreenState();
}

class _NavigateScreenState extends State<NavigateScreen> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  UnityWidgetController? _unityWidgetController;
  UserAccelerometerEvent? _userAccelerometerEvent;

  late SharedPreferences _pref;
  String _processState = "";
  String _zoneName = "";
  String selectedValue = '0';

  // TTS Setting
  FlutterTts flutterTts = FlutterTts();
  String language = "ko-KR";
  Map<String, String> voice = {"name": "ko-kr-x-ism-local", "locale": "ko-KR"};
  String engine = "com.google.android.tts";
  double volume = 0.8;
  double pitch = 1.0;
  double rate = 0.5;

  // Sensors Plus
  //List<AccelerometerEvent> _accelerometerValues = [];
  //late StreamSubscription<AccelerometerEvent> _accelerometerSubscription;

  @override
  void initState() {
    super.initState();
    initTtsState();
    _getProcessState();
    _setSelectedValue();
    //_accelerometerSubscription = accelerometerEvents.listen((event) {
    //  setState(() {
    //    _accelerometerValues = [event];
    //  });
    //});
    //Timer.periodic(Duration(seconds: 1), (timer) {
    //  PrintAccelerometer();
    //});
  }

  @override
  void dispose() {
    _unityWidgetController?.dispose();
    //_accelerometerSubscription.cancel();
    super.dispose();
  }

  // 예약 현황 불러오기
  _getProcessState() async {
    _pref = await SharedPreferences.getInstance();
    setState(() {
      _processState = _pref.getString("processState") ?? "";
    });
  }

  // 안내할 주차장 선택하기
  _setSelectedValue() async {
    _pref = await SharedPreferences.getInstance();
    setState(() {
      _zoneName = _pref.getString("parkingZone") ?? "";
      print("주차구역: ${_zoneName}");

      if (_zoneName == "Z001")
        selectedValue = '0';
      else if (_zoneName == "Z002")
        selectedValue = '1';
      else if (_zoneName == "Z003")
        selectedValue = '2';
      else if (_zoneName == "Z004")
        selectedValue = '3';
      else if (_zoneName == "Z005")
        selectedValue = '4';
      else if (_zoneName == "Z006")
        selectedValue = '5';
      else if (_zoneName == "Z007")
        selectedValue = '6';
      else if (_zoneName == "Z008")
        selectedValue = '7';
      else
        selectedValue = '0';
      print("선택 값: ${selectedValue}");
    });

    Timer(
      Duration(seconds: 3),
      () => SetCurrentNavigationTarget(selectedValue),
    );
    Timer(
      Duration(seconds: 3),
      () => SetDestinationParkingZone(_zoneName),
    );
  }

  // TTS Setting
  initTtsState() async {
    flutterTts.setLanguage(language);
    flutterTts.setVoice(voice);
    flutterTts.setEngine(engine);
    flutterTts.setVolume(volume);
    flutterTts.setPitch(pitch);
    flutterTts.setSpeechRate(rate);
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
                        onUnityMessage: onUnityMessage,
                        fullscreen: true,
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

  void onUnityMessage(message) {
    message = message.toString();
    print('[Flutter-Unity] Received message from unity: ${message}');

    if (message == "Start")
      Timer(
        Duration(seconds: 1),
        () => _speak("주차구역 안내를 시작합니다."),
      );
    else if (message == "Arrive") {
      SetArrivalMessage(_zoneName);
      _speak("주차구역에 도착했습니다.");
    } else if (message == "Finish") finishNavScene();
  }

  finishNavScene() {
    _speak("안내를 종료합니다.");
    DestroyTargetObject();
    Timer(
      Duration(seconds: 1),
      () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchScreen()),
      ),
    );
  }

  void SetCurrentNavigationTarget(String selectedValue) {
    _unityWidgetController?.postMessage(
        'Indicator', 'SetCurrentNavigationTargetFlutter', selectedValue);
  }

  void SetDestinationParkingZone(String zone) {
    _unityWidgetController?.postMessage(
        'ParkingZoneText', 'SetDestinationParkingZone', zone);
  }

  void SetArrivalMessage(String zone) {
    _unityWidgetController?.postMessage(
        'ArrivalMessageText', 'SetArrivalMessage', zone);
  }

  void DestroyTargetObject() {
    _unityWidgetController?.postMessage('Indicator', 'DestroyTargetObject', '');
  }

  // TTS Setting
  Future _speak(voiceText) async {
    flutterTts.speak(voiceText);
  }

  // Sensors Plus
  //void PrintAccelerometer() {
  //  if (_accelerometerValues.isNotEmpty)
  //    print('X: ${_accelerometerValues[0].x.toStringAsFixed(2)}, '
  //        'Y: ${_accelerometerValues[0].y.toStringAsFixed(2)}, '
  //        'Z: ${_accelerometerValues[0].z.toStringAsFixed(2)}');
  //  else
  //    print('No data available');
  //}
}

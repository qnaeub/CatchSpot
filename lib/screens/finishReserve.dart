import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/screens/management_screen.dart';
import 'package:flutter_app/shared/menu_bottom.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FinishReserve extends StatefulWidget {
  const FinishReserve({Key? key}) : super(key: key);

  @override
  State<FinishReserve> createState() => _FinishReserveState();
}

class _FinishReserveState extends State<FinishReserve> {
  late SharedPreferences _pref;
  bool _isVoiceReserve = false;

  // TTS Setting
  FlutterTts flutterTts = FlutterTts();
  String language = "ko-KR";
  Map<String, String> voice = {"name": "ko-kr-x-ism-local", "locale": "ko-KR"};
  String engine = "com.google.android.tts";
  double volume = 0.8;
  double pitch = 1.0;
  double rate = 0.5;

  @override
  void initState() {
    print("finishReserve 페이지");
    super.initState();
    initTtsState();
    _getSearchItem();
    _getVoiceReserveMode();
  }

  // 실시간 예약 방식 설정 (텍스트/음성)
  _setVoiceReserveMode(bool tf) async {
    setState(() {
      _isVoiceReserve = tf;
      _pref.setBool("isVoiceReserve", _isVoiceReserve);
    });
  }

  // 음성 인식 모드 확인
  _getVoiceReserveMode() async {
    _pref = await SharedPreferences.getInstance();
    setState(() {
      _isVoiceReserve = _pref.getBool("isVoiceReserve") ?? false;
    });
    print("음성 인식 모드 확인: ${_isVoiceReserve}");

    if (_isVoiceReserve == true)
      Timer(
        Duration(seconds: 1),
        () => _voiceReserveMode(),
      );
    else
      Timer(
        Duration(seconds: 3),
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ManageScreen()),
        ),
      );
  }

  _getSearchItem() async {
    _pref = await SharedPreferences.getInstance();
    setState(() {
      _isVoiceReserve = _pref.getBool("isVoiceReserve") ?? false;
    });
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

  _voiceReserveMode() {
    print("_voiceReserveMode");
    _speak("예약이 완료되었습니다. 10분 내로 입차해 주시길 바랍니다.");
    sleep(Duration(seconds: 6));
    _setVoiceReserveMode(false);
    Timer(
      Duration(seconds: 6),
      () => Navigator.pushNamed(context, '/manage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          title: Text(
            '예약 완료',
            style: TextStyle(color: Color(0xff6528F7)),
          ),
          centerTitle: true,
          backgroundColor: Color(0xffFFFFFF),
          elevation: 1,
          automaticallyImplyLeading: false,
        ),
      ),
      body: Center(child: Text("예약이 완료되었습니다")),
      bottomNavigationBar: MenuBottom(1),
    );
  }

  // TTS Setting
  Future _speak(voiceText) async {
    flutterTts.speak(voiceText);
  }
}

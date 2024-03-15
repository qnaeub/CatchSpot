import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/shared/menu_bottom.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/http_setup.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:math';
import 'dart:async';

class parkingLotName {
  final String lot_name;

  parkingLotName({required this.lot_name});
  factory parkingLotName.fromJson(Map<String, dynamic> json) {
    return parkingLotName(lot_name: json['lot_name']);
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static List<String> lotNames = [];
  static List<String> lotKeys = [];
  late SharedPreferences _pref;
  String _searchItem = "";
  String _parkingLot = "";
  String _lotKey = "";
  TextEditingController textController = TextEditingController();
  bool showSearchResult = false;
  List<String> _preLot = [];
  List<String> _realLot = [];

  // STT Setting
  bool _hasSpeech = false;
  bool _logEvents = false;
  bool _onDevice = false;
  final TextEditingController _pauseForController =
      TextEditingController(text: '3');
  final TextEditingController _listenForController =
      TextEditingController(text: '30');
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = '';
  String lastError = '';
  String lastStatus = '';
  String _currentLocaleId = '';
  List<LocaleName> _localeNames = [];
  final SpeechToText speech = SpeechToText();
  String _speakItem = "";
  int voiceNum = 0;
  bool _isVoiceReserve = false;

  // TTS Setting
  FlutterTts flutterTts = FlutterTts();
  String language = "ko-KR";
  Map<String, String> voice = {"name": "ko-kr-x-ism-local", "locale": "ko-KR"};
  String engine = "com.google.android.tts";
  double volume = 0.8;
  double pitch = 1.0;
  double rate = 0.5;

  // 주차 정보 사전 등록
  String _carnum = "";
  String _phonenum = "";
  late TextEditingController _carnumController =
      TextEditingController(text: "$_carnum");
  late TextEditingController _phonenumController =
      TextEditingController(text: "$_phonenum");
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  // 예약 현황
  String _processState = "";

  @override
  void initState() {
    super.initState();
    _getSearchItem();
    _getParkingLot();
    _getProcessState();
    initSpeechState();
    initTtsState();
    _getCarAndPhonenum();
  }

  _setSearchItem() async {
    setState(() {
      _searchItem = textController.text;
      _pref.setString("searchItem", _searchItem);
    });
  }

  _setVoiceSpeakItem() async {
    setState(() {
      _speakItem = lastWords;
    });
    print("음성 인식 단어: ${_speakItem}");
  }

  // 실시간 예약 방식 설정 (텍스트/음성)
  _setVoiceReserveMode(bool tf) async {
    setState(() {
      _isVoiceReserve = tf;
      _pref.setBool("isVoiceReserve", _isVoiceReserve);
    });
  }

  _setLotSpace() async {
    setState(() {
      _pref.setStringList("preLot", _preLot);
      _pref.setStringList("realLot", _realLot);
    });
  }

  _getSearchItem() async {
    _pref = await SharedPreferences.getInstance();
    setState(() {
      _searchItem = _pref.getString("searchItem") ?? "";
    });
  }

  _setParkingLot() async {
    setState(() {
      _pref.setString("parkingLot", _parkingLot);
      _pref.setString("lotKey", _lotKey);
    });

    print("Set parking lot: ${_parkingLot}");
    print("Set lot key: ${_lotKey}");
  }

  _getParkingLot() async {
    _pref = await SharedPreferences.getInstance();
    setState(() {
      _parkingLot = _pref.getString("parkingLot") ?? "";
      _lotKey = _pref.getString("lotKey") ?? "";
    });
  }

  // 예약 현황 불러오기
  _getProcessState() async {
    _pref = await SharedPreferences.getInstance();
    setState(() {
      _processState = _pref.getString("processState") ?? "";
    });
  }

  Future<void> _getParkingLotInfo(lotKey) async {
    try {
      var response = await get('/status/${lotKey}', {});
      Map<String, dynamic> jsonResponse = response.data;

      print("#################### 결과: $jsonResponse");

      print("총 주차 자리 수: ${jsonResponse['총 주차 자리 수']}");
      print("남은 사전 예약 구역 번호: ${jsonResponse['남은 사전 예약 구역 번호']}");
      print("실시간 예약 가능 구역 번호: ${jsonResponse['실시간 예약 가능 구역 번호']}");
      _preLot = List<String>.from(jsonResponse['남은 사전 예약 구역 번호'] as List);
      _realLot = List<String>.from(jsonResponse['실시간 예약 가능 구역 번호'] as List);
      _setLotSpace();
      print("#################### _preLot: ${_preLot}");
      print("#################### _realLot: ${_realLot}");
    } catch (e) {
      print("#################### 에러: ${e}");
    }

    // 주차 구역 페이지로 이동
    if (_isVoiceReserve == true)
      Navigator.pushNamed(context, '/setinfo');
    else
      Navigator.pushNamed(context, '/parking-space');
  }

  Future<void> _getParkingLotList() async {
    try {
      var response = await get('/search', {'q': '$_searchItem'});
      List<dynamic> jsonResponse = response.data;
      lotNames = [];
      lotKeys = [];

      if (response.statusCode == 200) {
        setState(() {
          lotNames = [];
          lotKeys = [];
          for (int i = 0; i < jsonResponse.length; i++) {
            lotNames.add(jsonResponse[i]['주차장 이름']);
            lotKeys.add(jsonResponse[i]['주차장 key']);
          }
        });
      } else {
        print("서버 응답 오류: ${response.statusCode}");
      }
    } catch (e) {
      lotNames = [];
      lotKeys = [];
    }
  }

  // STT Setting
  Future<void> initSpeechState() async {
    _logEvent('Initialize');
    try {
      var hasSpeech = await speech.initialize(
        onError: errorListener,
        onStatus: statusListener,
        debugLogging: _logEvents,
      );
      if (hasSpeech) {
        // Get the list of languages installed on the supporting platform so they
        // can be displayed in the UI for selection by the user.
        _localeNames = await speech.locales();

        var systemLocale = await speech.systemLocale();
        _currentLocaleId = systemLocale?.localeId ?? '';
      }
      if (!mounted) return;

      setState(() {
        _hasSpeech = hasSpeech;
      });
    } catch (e) {
      setState(() {
        lastError = 'Speech recognition failed: ${e.toString()}';
        _hasSpeech = false;
      });
    }
    print("initSpeechState Finish");
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

  // 주차 정보 사전 등록
  _setCarAndPhonenum() {
    setState(() {
      _carnum = _carnumController.text;
      _phonenum = _phonenumController.text;
      _pref.setString("carnum", _carnum);
      _pref.setString("phonenum", _phonenum);
    });
  }

  _getCarAndPhonenum() async {
    _pref = await SharedPreferences.getInstance();
    setState(() {
      _carnum = _pref.getString("carnum") ?? "";
      _phonenum = _pref.getString("phonenum") ?? "";
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
            '주차장 검색',
            style: TextStyle(color: Color(0xff6528F7)),
          ),
          centerTitle: true,
          backgroundColor: Color(0xffFFFFFF),
          elevation: 1,
          //automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                icon: Icon(Icons.menu, color: Color(0xff6528F7)))
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(),
            ListTile(
              leading: Icon(Icons.assignment_add),
              iconColor: Color(0xff6528F7),
              focusColor: Color(0xff6528F7),
              title: Text("주차 정보 사전 등록"),
              onTap: () {
                _carnumController.text = "";
                _phonenumController.text = "";
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          "주차 정보 사전 등록",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xff6528F7)),
                        ),
                        content: SingleChildScrollView(
                          child: Column(
                            children: [
                              TextField(
                                controller: _carnumController,
                                decoration: InputDecoration(
                                    hintText: _carnum == ""
                                        ? "차량번호 입력: (ex. 123가1234)"
                                        : "등록된 차량번호: ${_carnum}"),
                                inputFormatters: [
                                  // 한글 및 숫자로 제한
                                  LengthLimitingTextInputFormatter(
                                      8), // 8자리로 제한
                                ],
                              ),
                              TextField(
                                controller: _phonenumController,
                                decoration: InputDecoration(
                                    hintText: _phonenum == ""
                                        ? "전화번호 입력: (ex. 01012345678)"
                                        : "등록된 전화번호: ${_phonenum}"),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .digitsOnly, // 숫자만 입력
                                  LengthLimitingTextInputFormatter(
                                      11), // 11자리로 제한
                                ],
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _carnumController.text = "";
                                _phonenumController.text = "";
                              },
                              child: Text(
                                "취소",
                                style: TextStyle(color: Color(0xff6528F7)),
                              )),
                          ElevatedButton(
                            onPressed: () {
                              if (_carnumController.text == "" ||
                                  _phonenumController.text == "") {
                                // 차량번호 또는 전화번호 미입력 시 안내 팝업창 띄움
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content:
                                          Text("차량번호와 전화번호를 반드시 입력해야 합니다."),
                                    );
                                  },
                                );
                              } else if (_carnumController.text.length < 7) {
                                // 차량번호 7자리 미만 시 안내 팝업창 띄움
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content:
                                          Text("차량번호는 7자리 또는 8자리로 입력해야 합니다."),
                                    );
                                  },
                                );
                              } else if (_phonenumController.text.length < 11) {
                                // 전화번호 11자리 미만 시 안내 팝업창 띄움
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Text("전화번호는 11자리로 입력해야 합니다."),
                                    );
                                  },
                                );
                              } else {
                                _setCarAndPhonenum();
                                _carnumController.text = "";
                                _phonenumController.text = "";
                                Navigator.pop(context);
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Text("차량번호와 전화번호를 등록했습니다."),
                                    );
                                  },
                                );
                                print("차량번호: ${_carnum}");
                                print("전화번호: ${_phonenum}");
                              }
                            },
                            child: Text("등록"),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff6528F7)),
                          ),
                        ],
                      );
                    });
              },
              trailing: Icon(Icons.navigate_next),
            )
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              // width: 330,
              height: 50,
              margin: EdgeInsets.fromLTRB(15, 25, 15, 0),
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              decoration: BoxDecoration(
                  color: Color(0xffFFFFFF),
                  border: Border.all(color: Color(0xffA076F9), width: 1),
                  borderRadius: BorderRadius.circular(30)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.mic),
                    onPressed: () async {
                      // 음성 검색 시 실행할 로직
                      _setVoiceReserveMode(true);

                      _speak("주차장을 검색하세요.");
                      sleep(Duration(seconds: 2));

                      // 음성 인식
                      !_hasSpeech || speech.isListening
                          ? print("${!_hasSpeech} || ${speech.isListening}")
                          : startListening(voiceParkingLotSearch);
                      sleep(Duration(seconds: 3));
                    },
                    iconSize: 25.0,
                  ),
                  SizedBox(
                    width: 200.0,
                    child: TextField(
                      cursorColor: Color(0xffA076F9),
                      controller: textController,
                      style: TextStyle(),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () async {
                      _setVoiceReserveMode(false);

                      // 검색한 단어 로컬에 저장
                      await _setSearchItem();
                      print("검색한 단어: $_searchItem");
                      print("lotNames : $lotNames");
                      print("lotNames 길이: ${lotNames.length}");

                      if (_searchItem.length < 2) {
                        // 2글자 미만 검색 시 팝업창 띄움
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text("2글자 이상의 단어를 검색해주세요."),
                            );
                          },
                        );
                      } else {
                        // 주차장 불러오기
                        await _getParkingLotList();

                        if (lotNames.isEmpty) {
                          // 검색된 결과 없음
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content:
                                    Text("'${_searchItem}'로 검색한 결과가 없습니다."),
                              );
                            },
                          );
                        } else {
                          // 주차장 이름 및 고유번호 출력
                          print("주차장 이름: $lotNames");
                          print("주차장 key: $lotKeys");

                          // 주차장 목록 띄우기
                          showSearchResult = true;
                        }
                      }
                    },
                    iconSize: 25.0,
                  ),
                ],
              ),
            ),
            if (showSearchResult)
              Expanded(
                child: ListView.builder(
                    // 주차장 목록 보여줌
                    itemCount: lotNames.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          // 선택한 주차장 로컬에 저장
                          _parkingLot = lotNames[index];
                          _lotKey = lotKeys[index];
                          _setParkingLot();
                          print("선택한 주차장: ${_parkingLot}\n주차장 키: ${_lotKey}");

                          // 주차장의 정보 출력 및 주차 구역 페이지로 이동
                          _getParkingLotInfo(_lotKey);
                        },
                        child: ListTile(
                          title: Text(lotNames[index]),
                        ),
                      );
                    }),
              )
            else
              Container(
                  margin: EdgeInsets.fromLTRB(0, 200, 0, 0),
                  child: Column(
                    children: [
                      SizedBox(
                        child: Icon(
                          Icons.search,
                          size: 100,
                        ),
                      ),
                      Text(''),
                      Text('주차장을 검색하세요.'),
                    ],
                  )),
          ],
        ),
      ),
      bottomNavigationBar: MenuBottom(1),
    );
  }

  // STT Setting
  void startListening(result) {
    print("startListening");
    _logEvent('start listening');
    lastWords = '';
    lastError = '';
    final pauseFor = int.tryParse(_pauseForController.text);
    final listenFor = int.tryParse(_listenForController.text);
    final options = SpeechListenOptions(
        onDevice: _onDevice,
        listenMode: ListenMode.confirmation,
        cancelOnError: true,
        partialResults: true,
        autoPunctuation: true,
        enableHapticFeedback: true);
    speech.listen(
      onResult: result,
      listenFor: Duration(seconds: listenFor ?? 30),
      pauseFor: Duration(seconds: pauseFor ?? 3),
      localeId: _currentLocaleId,
      onSoundLevelChange: soundLevelListener,
      listenOptions: options,
    );
    setState(() {});
  }

  Future<void> resultListener(SpeechRecognitionResult result) async {
    _logEvent(
        'Result listener final: ${result.finalResult}, words: ${result.recognizedWords}');
    if (result.finalResult == true) {
      setState(() {
        lastWords = '${result.recognizedWords}';
      });
      _setVoiceSpeakItem();
    }
  }

  Future<void> voiceParkingLotSearch(SpeechRecognitionResult result) async {
    _logEvent(
        'Result listener final: ${result.finalResult}, words: ${result.recognizedWords}');
    if (result.finalResult == true) {
      setState(() {
        lastWords = '${result.recognizedWords}';
      });
      _setVoiceSpeakItem();

      if (_speakItem.length < 2) {
        // 2글자 미만 검색 시 팝업창 띄움
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("2글자 이상의 단어를 검색해주세요."),
            );
          },
        );
        _speak("두 글자 이상의 단어를 검색해 주세요.");
      } else {
        // 주차장 불러오기
        _searchItem = _speakItem;
        await _getParkingLotList();

        if (lotNames.isEmpty) {
          // 검색된 결과 없음
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Text("'${_speakItem}'(으)로 검색한 결과가 없습니다."),
              );
            },
          );
          _speak("${_speakItem}으로 검색한 결과가 없습니다.");
        } else {
          showSearchResult = true;
          await voiceSelectParkingLot();
        }
      }
    }
  }

  voiceSelectParkingLot() {
    // 주차장 이름 및 고유번호 출력
    print("주차장 이름: $lotNames");
    print("주차장 key: $lotKeys");

    // 주차장 목록 띄우기
    //showSearchResult = true;

    // 주차장 목록 안내하기
    _speak("검색된 주차장 목록입니다. 예약할 주차장 번호를 선택해 주세요.");
    sleep(Duration(seconds: 5));
    int i = 0;
    while (i < lotNames.length) {
      _speak("${i + 1}번, ${lotNames[i]}.");
      sleep(Duration(seconds: 3));
      i++;
    }
    _speak("예약할 주차장 번호를 선택해 주세요.");
    sleep(Duration(seconds: 3));

    // 음성 인식
    !_hasSpeech || speech.isListening
        ? print("${!_hasSpeech} || ${speech.isListening}")
        : startListening(voiceSelectNumber);
    sleep(Duration(seconds: 3));
  }

  Future<void> voiceSelectNumber(SpeechRecognitionResult result) async {
    print("This Progress: voiceSelectNumber");
    _logEvent(
        'Result listener final: ${result.finalResult}, words: ${result.recognizedWords}');
    if (result.finalResult == true) {
      setState(() {
        lastWords = '${result.recognizedWords}';
      });
      _setVoiceSpeakItem();

      _speakItem = _speakItem.replaceAll(RegExp(r'[^0-9]'), '');
      print("선택한 번호(정제): ${_speakItem}");
      if (_speakItem != "") {
        voiceNum = int.parse(_speakItem);
        print("voiceNum: ${voiceNum}");
        if (voiceNum < 1 || voiceNum > lotNames.length) {
          _speak("선택한 주차장 번호가 없습니다.");
          sleep(Duration(seconds: 2));

          voiceSelectParkingLot();
        } else {
          // 선택한 주차장 로컬에 저장
          _parkingLot = lotNames[voiceNum - 1];
          _lotKey = lotKeys[voiceNum - 1];
          _setParkingLot();
          print("선택한 주차장: ${_parkingLot}\n주차장 키: ${_lotKey}");

          // 주차장의 정보 출력 및 예약 정보 입력 페이지로 이동
          _getParkingLotInfo(_lotKey);
        }
      } else {
        _speak("선택한 주차장 번호가 없습니다.");
        sleep(Duration(seconds: 3));

        voiceSelectParkingLot();
      }
    }
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    _logEvent('sound level $level: $minSoundLevel - $maxSoundLevel ');
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    _logEvent(
        'Received error status: $error, listening: ${speech.isListening}');
    setState(() {
      lastError = '${error.errorMsg} - ${error.permanent}';
    });
  }

  void statusListener(String status) {
    _logEvent(
        'Received listener status: $status, listening: ${speech.isListening}');
    setState(() {
      lastStatus = status;
    });
  }

  void _logEvent(String eventDescription) {
    if (_logEvents) {
      var eventTime = DateTime.now().toIso8601String();
      debugPrint('$eventTime $eventDescription');
    }
  }

  // TTS Setting
  Future _speak(voiceText) async {
    flutterTts.speak(voiceText);
  }
}

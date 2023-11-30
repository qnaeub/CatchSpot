import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/http_setup.dart';
import 'package:flutter_app/shared/menu_bottom.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'management_screen.dart';

class SetReserveInfo extends StatefulWidget {
  // const SetReserveInfo({Key? key}) : super(key: key);
  ValueNotifier<bool> realTime; // 실시간 예약인지 여부
  SetReserveInfo({required this.realTime});

  @override
  State<SetReserveInfo> createState() => _SetReserveInfoState();
}

class _SetReserveInfoState extends State<SetReserveInfo> {
  final String now = new DateTime.now().toString();
  String formattedDate = DateFormat("yyyy.MM.dd HH:mm").format(DateTime.now());
  ValueNotifier<bool> isRealTime = ValueNotifier<bool>(true);
  //DateTime endDateTime = DateTime.utc(2023, 11, 23, 17);

  late SharedPreferences _pref;
  bool _preEdit = false;
  String _carnum = "";
  String _phonenum = "";
  String _parkingLot = "";
  String _zoneName = "";
  String _processState = "";
  DateTime _datetime = DateTime.now();
  String _lotKey = "";
  String _reserveKey = "";
  TextEditingController _carnumController = TextEditingController();
  TextEditingController _phonenumController = TextEditingController();
  final _hours = ['00', '01', '02', '03', '04', '05', '06', '07', '08'];
  final _minutes = ['00', '10', '20', '30', '40', '50'];
  String _selectedHour = '';
  String _selectedMinute = '';
  String startDateTime = DateFormat("yyyy.MM.dd HH:mm").format(DateTime.now());
  DateTime endDateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _getCarAndPhonenum();
    _getParkingLot();
    _getParkingZone();
    _getReserveDate();
    _getPreEdit();
    isRealTime = widget.realTime;
    _selectedHour = _hours[0];
    _selectedMinute = _minutes[1];
  }

  _setEndDateTime(_sHour, _sMin) {
    setState(() {
      endDateTime = DateTime.utc(_datetime.year, _datetime.month, _datetime.day,
          _datetime.hour, _datetime.minute);
      endDateTime = endDateTime.add(Duration(hours: _sHour, minutes: _sMin));
      _pref.setString("endDateTime", endDateTime.toString());
    });
  }

  _setProcessState() async {
    setState(() {
      _pref.setString("processState", _processState);
    });
  }

  _setReserveDate() async {
    setState(() {
      _pref.setString("reserveDate", DateTime.now().toString());
    });
  }

  _setCarAndPhonenum() {
    setState(() {
      _carnum = _carnumController.text;
      _phonenum = _phonenumController.text;
      _pref.setString("carnum", _carnum);
      _pref.setString("phonenum", _phonenum);
    });
  }

  _setSelectHM(_sHour, _sMin) {
    setState(() {
      _pref.setInt("selectedHour", _sHour);
      _pref.setInt("selectedMinute", _sMin);
    });
  }

  _setPreEdit() {
    setState(() {
      _preEdit = false;
      _pref.setBool("preEdit", _preEdit);
    });
  }

  _getPreEdit() async {
    _pref = await SharedPreferences.getInstance();
    setState(() {
      _preEdit = _pref.getBool("preEdit") ?? false;
    });
  }

  _getReserveDate() async {
    _pref = await SharedPreferences.getInstance();
    setState(() {
      _datetime = DateTime.parse(_pref.getString("reserveDate") ?? "");
    });
  }

  _getCarAndPhonenum() async {
    _pref = await SharedPreferences.getInstance();
    setState(() {
      _carnum = _pref.getString("carnum") ?? "";
      _phonenum = _pref.getString("phonenum") ?? "";
    });
  }

  _getParkingLot() async {
    _pref = await SharedPreferences.getInstance();
    setState(() {
      _parkingLot = _pref.getString("parkingLot") ?? "";
      _lotKey = _pref.getString("lotKey") ?? "";
    });
  }

  _getParkingZone() async {
    _pref = await SharedPreferences.getInstance();
    setState(() {
      _zoneName = _pref.getString("parkingZone") ?? "";
    });
  }

  Future<void> _setReserve() async {
    String start_time = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.utc(
        _datetime.year,
        _datetime.month,
        _datetime.day,
        _datetime.hour,
        _datetime.minute));
    String end_time = DateFormat("yyyy-MM-dd HH:mm:ss").format(endDateTime);

    Map<String, dynamic>? data;

    if (isRealTime.value) {
      data = {
        'vehicle_num': _carnum,
        'phone_number': _phonenum,
        'start_time': start_time,
        'end_time': end_time,
        'lot_key': _lotKey,
      };
    } else {
      data = {
        'vehicle_num': _carnum,
        'phone_number': _phonenum,
        'start_time': start_time,
        'end_time': end_time,
        'lot_key': _lotKey,
        'zone_key': _zoneName,
      };
      print("사전을 탐\n시작: $start_time\n종료: $end_time\n구역: $_zoneName");
    }

    try {
      var response;
      if (isRealTime.value) {
        response = await post('/reservation/realtime', data);
      } else {
        response = await post('/reservation/pre', data);
      }

      Map<String, dynamic> jsonResponse = response.data;

      if (response.statusCode == 200) {
        print(
            '#################### _setReserve() 데이터 전송 성공 ####################');
        setState(() {
          _reserveKey = jsonResponse['예약 번호'];
          _pref.setString("reservation_key", _reserveKey);
        });
        //print("데이터 전송 성공: 예약 번호 ${_reserveKey}");
      } else {
        print('데이터 전송 실패');
      }
    } catch (e) {
      print("#################### _setReserve() 에러: ${e} ####################");
    }
  }

  Future<void> _editReserve() async {
    String start_time = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.utc(
        _datetime.year,
        _datetime.month,
        _datetime.day,
        _datetime.hour,
        _datetime.minute));
    String end_time = DateFormat("yyyy-MM-dd HH:mm:ss").format(endDateTime);

    Map<String, dynamic>? data;
    if (_preEdit) {
      data = {
        'reservation_key': _reserveKey,
        'start_time': start_time,
        'end_time': end_time,
        'lot_key': _lotKey,
        'zone_key': _zoneName,
      };
    }

    try {
      var response;
      if (_preEdit) {
        response = await put('/reservation/preupdate', data);
      } else {
        response = await put('/reservation/realtimeupdate', data);
      }
      Map<String, dynamic> jsonResponse = response.data;

      if (response.statusCode == 200) {
        print(
            '#################### _editReserve() 데이터 전송 성공 ####################');
        print("결과: ${jsonResponse['결과']}");
      } else {
        print('데이터 전송 실패');
      }
    } catch (e) {
      print(
          "#################### _editReserve() 데이터 전송 실패: ${e} ####################");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '예약 정보 입력',
          style: TextStyle(color: Color(0xff6528F7)),
        ),
        centerTitle: true,
        backgroundColor: Color(0xffFFFFFF),
        elevation: 1,
        automaticallyImplyLeading: false,
      ),
      body: ValueListenableBuilder(
          valueListenable: isRealTime,
          builder: (context, value, child) {
            return Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          // 주차장 이름
                          height: 30,
                          margin: EdgeInsets.fromLTRB(25, 25, 25, 0),
                          child: Row(
                            children: [
                              Icon(Icons.location_pin),
                              Spacer(flex: 1),
                              Text("$_parkingLot"), // 검색 시 선택한 주차장 이름 받아옴
                              Spacer(flex: 20),
                            ],
                          ),
                        ),
                        Container(
                          // 날짜 및 시각 선택
                          height: 30,
                          margin: EdgeInsets.fromLTRB(25, 25, 25, 0),
                          child: Row(children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints:
                                  BoxConstraints(), // padding, constraints >> IconButton의 자체 여백 없애는 요소
                              icon: Icon(Icons.calendar_month),
                              onPressed: () {
                                // 버튼 입력 안 됨
                              },
                            ),
                            Spacer(flex: 1),
                            if (isRealTime.value == true) ...[
                              Text(
                                  "${_datetime.year}.${_datetime.month}.${_datetime.day} (10분 내 입차)") // 현재시각
                            ] else ...[
                              Text(
                                  "${DateFormat("yyyy.MM.dd HH:mm").format(DateTime.utc(_datetime.year, _datetime.month, _datetime.day, _datetime.hour, _datetime.minute))}"),
                              //Text("${_datetime.year}.${_datetime.month}.${_datetime.day} ${_datetime.hour}:${_datetime.minute}")
                            ],
                            Spacer(flex: 10),
                          ]),
                        ),
                        if (isRealTime.value == false) ...[
                          Container(
                            // 사전 예약 시 예약 시간 설정
                            height: 35,
                            margin: EdgeInsets.fromLTRB(25, 25, 25, 0),
                            child: Row(children: [
                              Icon(Icons.timer),
                              Spacer(flex: 1),
                              Container(
                                width: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(0xffA076F9), width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: DropdownButton(
                                  padding: EdgeInsets.fromLTRB(35, 0, 0, 0),
                                  underline: SizedBox.shrink(),
                                  value: _selectedHour,
                                  items: _hours.map((String item) {
                                    return DropdownMenuItem<String>(
                                      child: Text(item),
                                      value: item,
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    // items 의 DropdownMenuItem 의 value 반환
                                    setState(() {
                                      _selectedHour = newValue!;
                                    });
                                  },
                                  isExpanded: true,
                                ),
                              ),
                              Spacer(flex: 1),
                              Text("시간"),
                              Spacer(flex: 1),
                              Container(
                                width: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(0xffA076F9), width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: DropdownButton(
                                  padding: EdgeInsets.fromLTRB(35, 0, 0, 0),
                                  underline: SizedBox.shrink(),
                                  value: _selectedMinute,
                                  items: _minutes.map((String item) {
                                    return DropdownMenuItem<String>(
                                      child: Text(item),
                                      value: item,
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    // items 의 DropdownMenuItem 의 value 반환
                                    setState(() {
                                      _selectedMinute = newValue!;
                                    });
                                  },
                                  isExpanded: true,
                                ),
                              ),
                              Spacer(flex: 1),
                              Text("분"),
                              Spacer(flex: 3),
                            ]),
                          ),
                          Container(
                            // 사전 예약 시 주차구역 이름 표시
                            height: 30,
                            margin: EdgeInsets.fromLTRB(25, 25, 25, 0),
                            child: Row(
                              children: [
                                Icon(Icons.local_parking),
                                Spacer(flex: 1),
                                Text("$_zoneName"),
                                Spacer(flex: 20),
                              ],
                            ),
                          ),
                        ],
                        if (_preEdit == false) ...[
                          Container(
                            // 차량번호
                            height: 30,
                            margin: EdgeInsets.fromLTRB(25, 25, 25, 0),
                            child: Row(
                              children: [
                                Icon(Icons.directions_car),
                                Spacer(flex: 1),
                                Text("차량번호"),
                                Spacer(flex: 20),
                              ],
                            ),
                          ),
                          Container(
                            // 차량번호 입력칸
                            width: 270,
                            height: 35,
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                            decoration: BoxDecoration(
                                color: Color(0xffFFFFFF),
                                border: Border.all(
                                    color: Color(0xffA076F9), width: 1),
                                borderRadius: BorderRadius.circular(10)),
                            child: SizedBox(
                              width: 200.0,
                              child: TextField(
                                cursorColor: Color(0xffA076F9),
                                controller: _carnumController,
                                style: TextStyle(),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "000가0000",
                                ),
                                inputFormatters: [
                                  // 한글 및 숫자로 제한
                                  LengthLimitingTextInputFormatter(
                                      8), // 8자리로 제한
                                ],
                              ),
                            ),
                          ),
                          Container(
                            // 전화번호
                            height: 30,
                            margin: EdgeInsets.fromLTRB(25, 25, 25, 0),
                            child: Row(
                              children: [
                                Icon(Icons.call),
                                Spacer(flex: 1),
                                Text("전화번호"),
                                Spacer(flex: 20),
                              ],
                            ),
                          ),
                          Container(
                            // 전화번호 입력칸
                            width: 270,
                            height: 35,
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                            decoration: BoxDecoration(
                                color: Color(0xffFFFFFF),
                                border: Border.all(
                                    color: Color(0xffA076F9), width: 1),
                                borderRadius: BorderRadius.circular(10)),
                            child: SizedBox(
                              width: 200.0,
                              child: TextField(
                                cursorColor: Color(0xffA076F9),
                                controller: _phonenumController,
                                style: TextStyle(),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "01000000000",
                                ),
                                keyboardType: TextInputType.number, // 숫자 키보드 사용
                                inputFormatters: [
                                  FilteringTextInputFormatter
                                      .digitsOnly, // 숫자만 입력
                                  LengthLimitingTextInputFormatter(
                                      11), // 11자리로 제한
                                ],
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
                if (_preEdit == false)
                  Container(
                      height: 50,
                      margin: EdgeInsets.fromLTRB(25, 25, 25, 25),
                      child: InkWell(
                          onTap: () {
                            // 차량번호, 전화번호 데이터 저장
                            _setCarAndPhonenum();

                            if (_carnum == "" || _phonenum == "") {
                              // 차량번호 또는 전화번호 미입력 시 안내 팝업창 띄움
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Text("차량번호와 전화번호를 반드시 입력해야 합니다."),
                                  );
                                },
                              );
                            } else if (_carnum.length < 7) {
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
                            } else if (_phonenum.length < 11) {
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
                              if (isRealTime.value) {
                                _setReserveDate();
                              }

                              // 예약현황 - 진행상태 설정
                              _processState = "예약완료";
                              _setProcessState();

                              // 시간 및 분 출력
                              print("$_selectedHour시간 $_selectedMinute분 선택");

                              // 테스트
                              var _sHour = int.parse(_selectedHour);
                              var _sMin = int.parse(_selectedMinute);
                              _setEndDateTime(_sHour, _sMin);
                              _setSelectHM(_sHour, _sMin);
                              print(
                                  "종료 시간 (formatted): ${DateFormat("yyyy.MM.dd HH:mm").format(endDateTime)}");

                              // 예약 서버 전송
                              _setReserve();

                              // 예약 완료 페이지로 이동
                              Navigator.pushNamed(context, '/finish-reserve');
                            }
                          },
                          child: Container(
                            // 실시간 예약하기 버튼
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xffFFFFFF),
                              border: Border.all(color: Color(0xffA076F9)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                                child: Text(
                                    isRealTime.value ? "실시간 예약하기" : "사전 예약하기")),
                          )))
                else
                  Container(
                      height: 50,
                      margin: EdgeInsets.fromLTRB(25, 25, 25, 25),
                      child: InkWell(
                          onTap: () {
                            // 예약현황 - 진행상태 설정
                            _processState = "예약완료";
                            _setProcessState();

                            // 시간 및 분 출력
                            print("$_selectedHour시간 $_selectedMinute분 선택");

                            // 테스트
                            var _sHour = int.parse(_selectedHour);
                            var _sMin = int.parse(_selectedMinute);
                            _setEndDateTime(_sHour, _sMin);
                            _setSelectHM(_sHour, _sMin);
                            print(
                                "종료 시간 (formatted): ${DateFormat("yyyy.MM.dd HH:mm").format(endDateTime)}");

                            // 예약 변경 서버 전송
                            _editReserve();

                            // 예약 편집 아님 상태로 변경
                            _setPreEdit();

                            // 예약 완료 페이지로 이동
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ManageScreen()));
                          },
                          child: Container(
                            // 예약 수정하기 버튼
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xffFFFFFF),
                              border: Border.all(color: Color(0xffA076F9)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(child: Text("예약 수정하기")),
                          ))),
              ],
            );
          }),
      bottomNavigationBar: MenuBottom(1),
    );
  }
}

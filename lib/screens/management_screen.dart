import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/screens/parkingSpace_screen.dart';
import 'package:flutter_app/shared/menu_bottom.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../http_setup.dart';

class ManageScreen extends StatefulWidget {
  const ManageScreen({Key? key}) : super(key: key);

  @override
  State<ManageScreen> createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  late SharedPreferences _pref;
  bool _preEdit = false;
  String _carnum = "";
  String _phonenum = "";
  String _parkingLot = "";
  String _zoneName = "";
  String _reserveDate = "";
  String _processState = "";
  String _reserveKey = "";
  DateTime _endDateTime = DateTime.now();
  DateTime _datetime = DateTime.now();
  bool isEdit = false;

  late TextEditingController _carnumController =
      TextEditingController(text: "$_carnum");
  late TextEditingController _phonenumController =
      TextEditingController(text: "$_phonenum");

  // 주차 정보 사전 등록
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _getCarAndPhonenum();
    _getParkingLot();
    _getParkingZone();
    _getReserveKey();
    _getReserveDate();
    _getProcessState();
    _getEndDateTime();
  }

  _cancelReserve() {
    _cancelReserveDB(_reserveKey);
    setState(() {
      _preEdit = false;
      _carnum = "";
      _phonenum = "";
      _parkingLot = "";
      _zoneName = "";
      _reserveDate = "";
      _processState = "";
      _pref.setString("carnum", _carnum);
      _pref.setString("phonenum", _phonenum);
      _pref.setString("parkingLot", _parkingLot);
      _pref.setString("parkingZone", _zoneName);
      _pref.setString("reserveDate", _reserveDate);
      _pref.setBool("preEdit", _preEdit);
      _pref.setString("processState", _processState);
    });
  }

  Future<void> _cancelReserveDB(reserveKey) async {
    print("예약키: '${reserveKey}'");
    Map<String, dynamic>? data = {
      'reservation_key': _reserveKey,
    };

    try {
      var response = await post('/reservation/cancel', data);
      Map<String, dynamic> jsonResponse = response.data;
      print("응답 결과1: $response");
      print("응답 결과2: $jsonResponse");

      if (response.statusCode == 200) {
        String result = jsonResponse['결과'];
        print("데이터 전송 성공: 예약 번호 ${result}");
      } else {
        print('데이터 전송 실패');
      }
    } catch (e) {
      print("_cancelReserveDB() 데이터 전송 실패: ${e}");
    }
  }

  Future<void> _editNumbers() async {
    Map<String, dynamic>? data = {
      'reservation_key': _reserveKey,
      'new_vehicle_num': _carnum,
      'new_phone_number': _phonenum,
    };
    print("_editNumbers() data: ${data}");

    try {
      var response = await put('/reservation/update1', data);
      Map<String, dynamic> jsonResponse = response.data;

      if (response.statusCode == 200) {
        print('_editNumbers() 데이터 전송 성공');
        print("결과: ${jsonResponse['결과']}");
      } else {
        print('데이터 전송 실패');
      }
    } catch (e) {
      print("_editNumbers() 데이터 전송 실패: ${e}");
    }
  }

  _setPreEdit() {
    setState(() {
      _preEdit = true;
      _pref.setBool("preEdit", _preEdit);
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

  _getReserveDate() async {
    _pref = await SharedPreferences.getInstance();
    setState(() {
      _datetime = DateTime.parse(_pref.getString("reserveDate") ?? "");
    });
  }

  _getEndDateTime() async {
    _pref = await SharedPreferences.getInstance();
    setState(() {
      _endDateTime = DateTime.parse(_pref.getString("endDateTime") ?? "");
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
    });
  }

  _getParkingZone() async {
    _pref = await SharedPreferences.getInstance();
    setState(() {
      _zoneName = _pref.getString("parkingZone") ?? "";
    });
  }

  _getProcessState() async {
    _pref = await SharedPreferences.getInstance();
    setState(() {
      _processState = _pref.getString("processState") ?? "";
    });
  }

  _getReserveKey() async {
    _pref = await SharedPreferences.getInstance();
    setState(() {
      _reserveKey = _pref.getString("reservation_key") ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget childWidget;

    if (_processState == "출차완료") {
      childWidget = Center(
        child: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.fromLTRB(0, 100, 0, 25),
                child: Text(
                  "주차 요금 정산",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
            Container(
                child: DataTable(
              columns: [
                DataColumn(label: Container()),
                DataColumn(label: Container())
              ],
              rows: [
                DataRow(cells: [
                  DataCell(Text("차량번호",
                      style: TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text("${_carnum}"))
                ]),
                DataRow(cells: [
                  DataCell(Text("입차시각",
                      style: TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text("2000-00-00 00:00:00"))
                ]),
                DataRow(cells: [
                  DataCell(Text("정산시각",
                      style: TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text("2000-00-00 00:00:00"))
                ]),
                DataRow(cells: [
                  DataCell(Text("결제금액",
                      style: TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text("0원"))
                ]),
                DataRow(cells: [DataCell(Container()), DataCell(Container())]),
              ],
            )),
            InkWell(
                onTap: () {
                  // 로컬 예약 내역 삭제
                  _cancelReserve();
                },
                child: Container(
                  //width: 250,
                  margin: EdgeInsets.fromLTRB(50, 50, 50, 0),
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  decoration: BoxDecoration(
                    color: Color(0xffFFFFFF),
                    border: Border.all(color: Color(0xffA076F9), width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                      child: Text(
                    "확인",
                    textAlign: TextAlign.center,
                  )),
                )),
          ],
        ),
      );
    } else if (_processState == "예약완료" ||
        _processState == "입차완료" ||
        _processState == "주차완료") {
      childWidget = Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(25, 25, 25, 0),
                        decoration: BoxDecoration(
                          color: Color(0xffFFFFFF),
                          border:
                              Border.all(color: Color(0xffD9D9D9), width: 1),
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              // 차량번호
                              height: 30,
                              margin: EdgeInsets.fromLTRB(25, 25, 25, 0),
                              child: Row(
                                children: [
                                  Icon(Icons.directions_car),
                                  if (isEdit == false) ...[
                                    Spacer(flex: 1),
                                    Text("$_carnum"),
                                    Spacer(flex: 20),
                                  ] else ...[
                                    Spacer(flex: 1),
                                    Container(
                                      // 차량번호 입력칸
                                      width: 200,
                                      height: 30,
                                      padding:
                                          EdgeInsets.fromLTRB(10, 12, 0, 0),
                                      decoration: BoxDecoration(
                                          color: Color(0xffFFFFFF),
                                          border: Border.all(
                                              color: Color(0xffA076F9),
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: SizedBox(
                                        width: 200.0,
                                        child: TextField(
                                          cursorColor: Color(0xffA076F9),
                                          controller: _carnumController,
                                          style: TextStyle(),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "$_carnum",
                                          ),
                                          inputFormatters: [
                                            // 한글 및 숫자로 제한
                                            LengthLimitingTextInputFormatter(
                                                8), // 8자리로 제한
                                          ],
                                        ),
                                      ),
                                    ),
                                    Spacer(flex: 10),
                                  ],
                                ],
                              ),
                            ),
                            Container(
                              // 전화번호
                              height: 30,
                              margin: EdgeInsets.fromLTRB(25, 25, 25, 25),
                              child: Row(
                                children: [
                                  Icon(Icons.call),
                                  if (isEdit == false) ...[
                                    Spacer(flex: 1),
                                    Text("$_phonenum"),
                                    Spacer(flex: 20),
                                  ] else ...[
                                    Spacer(flex: 1),
                                    Container(
                                      // 전화번호 입력칸
                                      width: 200,
                                      height: 30,
                                      padding:
                                          EdgeInsets.fromLTRB(10, 12, 0, 0),
                                      decoration: BoxDecoration(
                                          color: Color(0xffFFFFFF),
                                          border: Border.all(
                                              color: Color(0xffA076F9),
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: SizedBox(
                                        width: 200.0,
                                        child: TextField(
                                          cursorColor: Color(0xffA076F9),
                                          controller: _phonenumController,
                                          style: TextStyle(),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "01012345678",
                                          ),
                                          keyboardType:
                                              TextInputType.number, // 숫자 키보드 사용
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly, // 숫자만 입력
                                            LengthLimitingTextInputFormatter(
                                                11), // 11자리로 제한
                                          ],
                                        ),
                                      ),
                                    ),
                                    Spacer(flex: 10),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 50,
                        child: Container(
                          width: 45,
                          decoration: BoxDecoration(
                            color: Color(0xffFFFFFF),
                          ),
                          child: Text(
                            " MY",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff6528F7)),
                          ),
                        ),
                      )
                    ],
                  ),
                  Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(25, 25, 25, 0),
                        decoration: BoxDecoration(
                          color: Color(0xffFFFFFF),
                          border:
                              Border.all(color: Color(0xffD9D9D9), width: 1),
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              // 예약 시간
                              height: 40,
                              margin: EdgeInsets.fromLTRB(25, 25, 25, 0),
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_month),
                                  Spacer(flex: 1),
                                  //if ((_datetime.year == DateTime.now().year) &&
                                  //(_datetime.month == DateTime.now().month) &&
                                  //(_datetime.day == DateTime.now().day))
                                  if (_datetime.day == DateTime.now().day) ...[
                                    Text(
                                        "${DateFormat("yyyy.MM.dd HH:mm").format(DateTime.utc(_datetime.year, _datetime.month, _datetime.day, _datetime.hour, _datetime.minute))} ~"),
                                    Spacer(flex: 13)
                                  ] else ...[
                                    Text(
                                        "${DateFormat("yyyy.MM.dd HH:mm").format(DateTime.utc(_datetime.year, _datetime.month, _datetime.day, _datetime.hour, _datetime.minute))} ~\n${DateFormat("yyyy.MM.dd HH:mm").format(_endDateTime)}"),
                                    Spacer(flex: 13),
                                    if (isEdit == true) ...[
                                      IconButton(
                                        icon: Icon(Icons.edit,
                                            color: Color(0xffA076F9)),
                                        onPressed: () {
                                          _setPreEdit();
                                          // 날짜 수정
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ParkingSpaceScreen(
                                                          dateData:
                                                              ValueNotifier<
                                                                      bool>(
                                                                  true))));
                                        },
                                        iconSize: 25,
                                      ),
                                    ]
                                  ]
                                ],
                              ),
                            ),
                            Container(
                              // 주차장 이름
                              height: 30,
                              margin: EdgeInsets.fromLTRB(25, 25, 25, 0),
                              child: Row(
                                children: [
                                  Icon(Icons.location_pin),
                                  Spacer(flex: 1),
                                  Text("$_parkingLot"),
                                  Spacer(flex: 20),
                                ],
                              ),
                            ),
                            if (_zoneName != "")
                              Container(
                                // 주차 구역 이름
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
                            Container(
                              // 현재 상태
                              height: 30,
                              margin: EdgeInsets.fromLTRB(25, 25, 25, 25),
                              child: Row(
                                children: [
                                  Icon(Icons.check_circle),
                                  Spacer(flex: 1),
                                  Text("${_processState}"),
                                  Spacer(flex: 20),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 11,
                        left: 50,
                        child: Container(
                          width: 140,
                          decoration: BoxDecoration(
                            color: Color(0xffFFFFFF),
                          ),
                          child: Text(
                            " Parking Area",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff6528F7)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_processState == "예약완료") // 수정하기 : 예약완료 -> 입차완료
                    Stack(
                      children: [
                        Container(
                          height: 150,
                          margin: EdgeInsets.fromLTRB(25, 25, 25, 0),
                          decoration: BoxDecoration(
                            color: Color(0xffFFFFFF),
                            border:
                                Border.all(color: Color(0xffD9D9D9), width: 1),
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 95,
                                margin: EdgeInsets.fromLTRB(25, 25, 25, 25),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        // 차단기 올림
                                        print("차단기 올림 버튼");
                                      },
                                      child: Container(
                                        width: 130,
                                        decoration: BoxDecoration(
                                          color: Color(0xffFFFFFF),
                                          border: Border.all(
                                              color: Color(0xffA076F9),
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                            child: Text(
                                          "차단기\n올림",
                                          textAlign: TextAlign.center,
                                        )),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        // 차단기 내림
                                        print("차단기 내림 버튼");
                                      },
                                      child: Container(
                                        width: 130,
                                        decoration: BoxDecoration(
                                          color: Color(0xffFFFFFF),
                                          border: Border.all(
                                              color: Color(0xffA076F9),
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                            child: Text(
                                          "차단기\n내림",
                                          textAlign: TextAlign.center,
                                        )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 50,
                          child: Container(
                            width: 110,
                            decoration: BoxDecoration(
                              color: Color(0xffFFFFFF),
                            ),
                            child: Text(
                              " Controller",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff6528F7)),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          if (isEdit == true)
            Container(
                height: 50,
                margin: EdgeInsets.fromLTRB(25, 25, 25, 0),
                child: InkWell(
                  onTap: () {
                    _cancelReserve();
                    Navigator.pushNamed(context, '/manage');
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xffFFFFFF),
                      border: Border.all(color: Color(0xff7F7F7F)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(child: Text("예약 취소하기")),
                  ),
                )),
          //  && _processState == "예약완료" 조건 넣기
          if (isEdit == false && _processState == "예약완료") ...[
            Container(
                height: 50,
                margin: EdgeInsets.fromLTRB(25, 25, 25, 25),
                child: InkWell(
                  onTap: () {
                    // 예약을 수정 가능하도록 함
                    setState(() {
                      isEdit = true;
                    });
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xffFFFFFF),
                      border: Border.all(color: Color(0xffA076F9)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(child: Text("예약 변경하기")),
                  ),
                ))
          ] else if (isEdit == true) ...[
            Container(
                height: 50,
                margin: EdgeInsets.fromLTRB(25, 25, 25, 25),
                child: InkWell(
                  onTap: () {
                    // 예약 수정
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
                            content: Text("차량번호는 7자리 또는 8자리로 입력해야 합니다."),
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
                      // 예약 수정 서버 전달
                      _editNumbers();

                      // isEdit false로 변경
                      setState(() {
                        isEdit = false;
                      });
                    }
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xffFFFFFF),
                      border: Border.all(color: Color(0xffA076F9)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(child: Text("예약 수정하기")),
                  ),
                ))
          ],
        ],
      );
    } else {
      childWidget = Center(
          child: Container(
              margin: EdgeInsets.fromLTRB(0, 250, 0, 0),
              child: Column(
                children: [
                  SizedBox(
                    child: Icon(
                      Icons.cancel_presentation,
                      size: 100,
                    ),
                  ),
                  Text(''),
                  Text("예약된 주차장이 없습니다."),
                ],
              )));
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          title: Text(
            '이용자 예약 관리',
            style: TextStyle(color: Color(0xff6528F7)),
          ),
          centerTitle: true,
          backgroundColor: Color(0xffFFFFFF),
          elevation: 1,
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  _scaffoldKey.currentState?.openEndDrawer();
                },
                icon: Icon(Icons.menu, color: Color(0xff6528F7)))
          ],
        ),
      ),
      endDrawer: Drawer(
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
                              if (_carnum == "" && _phonenum == "") ...{
                                TextField(
                                  controller: _carnumController,
                                  decoration: InputDecoration(
                                      hintText: "차량번호 입력: (ex. 123가1234)"),
                                  inputFormatters: [
                                    // 한글 및 숫자로 제한
                                    LengthLimitingTextInputFormatter(
                                        8), // 8자리로 제한
                                  ],
                                ),
                                TextField(
                                  controller: _phonenumController,
                                  decoration: InputDecoration(
                                      hintText: "전화번호 입력: (ex. 01012345678)"),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .digitsOnly, // 숫자만 입력
                                    LengthLimitingTextInputFormatter(
                                        11), // 11자리로 제한
                                  ],
                                ),
                              } else ...{
                                TextField(
                                  controller: _carnumController,
                                  decoration: InputDecoration(
                                      hintText: "등록된 차량번호: ${_carnum}"),
                                  inputFormatters: [
                                    // 한글 및 숫자로 제한
                                    LengthLimitingTextInputFormatter(
                                        8), // 8자리로 제한
                                  ],
                                ),
                                TextField(
                                  controller: _phonenumController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      hintText: "등록된 전화번호: ${_phonenum}"),
                                )
                              }
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
                            child: Text(
                              "등록",
                              style: TextStyle(color: Color(0xffffffff)),
                            ),
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
      body: childWidget,
      bottomNavigationBar: MenuBottom(2),
    );
  }
}

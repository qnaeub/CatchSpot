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
  String _reserveKey = "rxvsu1djt4beptv";
  DateTime _endDateTime = DateTime.now();
  //String _endDateTime = "";
  DateTime _datetime = DateTime.now();
  bool isEdit = false;

  late TextEditingController _carnumController =
      TextEditingController(text: "$_carnum");
  late TextEditingController _phonenumController =
      TextEditingController(text: "$_phonenum");

  @override
  void initState() {
    super.initState();
    _getCarAndPhonenum();
    _getParkingLot();
    _getParkingZone();
    _getReserveDate();
    _getProcessState();
    _getEndDateTime();
  }

  _cancelReserve() {
    //_cancelReserveDB(_reserveKey);
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
    print("예약키: '${_reserveKey}'");
    try {
      var response = await post('/reservation/cancel/$reserveKey', {});
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
      print("###### _cancelReserveDB() 데이터 전송 실패: ${e} ######");
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
    } else if (_carnum != "" && _phonenum != "") {
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
                        top: 15,
                        left: 50,
                        child: Container(
                          width: 35,
                          decoration: BoxDecoration(
                            color: Color(0xffFFFFFF),
                          ),
                          child: Text(
                            "MY",
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
                              height: 35,
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
                          width: 130,
                          decoration: BoxDecoration(
                            color: Color(0xffFFFFFF),
                          ),
                          child: Text(
                            "Parking Area",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff6528F7)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_processState == "입차완료")
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
                          top: 15,
                          left: 50,
                          child: Container(
                            width: 130,
                            decoration: BoxDecoration(
                              color: Color(0xffFFFFFF),
                            ),
                            child: Text(
                              "Controller",
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
                    // 수정해야됨...
                    //_cancelReserve();
                    _cancelReserveDB(_reserveKey);
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
          if (isEdit == false) ...[
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
        ),
      ),
      body: childWidget,
      bottomNavigationBar: MenuBottom(2),
    );
  }
}

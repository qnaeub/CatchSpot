import 'package:flutter/material.dart';
import 'package:flutter_app/shared/menu_bottom.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageScreen extends StatefulWidget {
  const ManageScreen({Key? key}) : super(key: key);

  @override
  State<ManageScreen> createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  late SharedPreferences _pref;
  String _carnum = "";
  String _phonenum = "";
  String _parkingLot = "";
  String _zoneName = "";

  @override
  void initState() {
    super.initState();
    _getCarAndPhonenum();
    _getParkingLot();
    _getParkingZone();
  }

  _cancelReserve() {
    setState(() {
      _carnum = "";
      _phonenum = "";
      _parkingLot = "";
      _zoneName = "";
      _pref.setString("carnum", _carnum);
      _pref.setString("phonenum", _phonenum);
      _pref.setString("parkingLot", _parkingLot);
      _pref.setString("parkingZone", _zoneName);
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

  @override
  Widget build(BuildContext context) {
    Widget childWidget;

    if (_carnum != "" && _phonenum != "") {
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
                                  Spacer(flex: 1),
                                  Text("$_carnum"),
                                  Spacer(flex: 20),
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
                                  Spacer(flex: 1),
                                  Text("$_phonenum"),
                                  Spacer(flex: 20),
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
                          width: 30,
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
                              height: 30,
                              margin: EdgeInsets.fromLTRB(25, 25, 25, 0),
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_month),
                                  Spacer(flex: 1),
                                  Text("예약 시간"),
                                  Spacer(flex: 20),
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
                                  Text("예약 완료"),
                                  Spacer(flex: 20),
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
                          width: 120,
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
                ],
              ),
            ),
          ),
          Container(
              height: 50,
              margin: EdgeInsets.fromLTRB(25, 25, 25, 25),
              child: InkWell(
                onTap: () {
                  _cancelReserve();
                  Navigator.pushNamed(context, '/manage');
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xffFFFFFF),
                    border: Border.all(color: Color(0xffA076F9)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(child: Text("예약 취소하기")),
                ),
              ))
        ],
      );
    } else {
      childWidget = Center(child: Text("예약된 주차장이 없습니다."));
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

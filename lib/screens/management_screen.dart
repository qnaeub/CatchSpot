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

  @override
  void initState() {
    super.initState();
    _getCarAndPhonenum();
  }

  _getCarAndPhonenum() async {
    _pref = await SharedPreferences.getInstance();
    setState(() {
      _carnum = _pref.getString("currentCarnum") ?? "";
      _phonenum = _pref.getString("currentPhonenum") ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: Container(
          child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  if (_carnum != "" && _phonenum != "") ...[
                    Container(
                      margin: EdgeInsets.fromLTRB(25, 25, 25, 0),
                      decoration: BoxDecoration(
                        color: Color(0xffFFFFFF),
                        border: Border.all(color: Color(0xffD9D9D9), width: 1),
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
                  ] else ...[
                    Center(child: Text("예약된 주차장이 없습니다.")),
                  ]
                ],
              ),
            ),
          ),
        ],
      )),
      bottomNavigationBar: MenuBottom(2),
    );
  }
}

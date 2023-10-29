import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/shared/menu_bottom.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/http_setup.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late SharedPreferences _pref;
  String _parkinglot = "";
  TextEditingController textController = TextEditingController();
  bool showContainer = false;

  @override
  void initState() {
    super.initState();
    _getParkingLot();
  }

  _setParkingLot() {
    setState(() {
      _parkinglot = textController.text;
      _pref.setString("currentParkinglot", _parkinglot);
    });
  }

  _getParkingLot() async {
    _pref = await SharedPreferences.getInstance();
    setState(() {
      _parkinglot = _pref.getString("currentParkinglot") ?? "";
    });
  }

  Future<void> getParkingLotNames() async {
    print("getParkingLotNames");
    try {
      var response =
          await dio.post('http://10.0.2.2:8080/getParkingLotList/', data: {});
      print("response");
      if (response.statusCode == 200) {
        print('서버 응답');
      } else {
        print('서버 응답 오류');
      }
      print("if문 끝");
    } catch (e) {
      // Connection timed out (OS Error: Connection timed out, errno = 110)
      print("에러: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          automaticallyImplyLeading: false,
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
                    onPressed: () {
                      // 음성 검색 시 실행할 로직
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
                    onPressed: () {
                      // 검색 실행할 시 실행할 로직
                      _setParkingLot();
                      print("검색한 단어: $_parkinglot");

                      getParkingLotNames();
                      showContainer = true;
                      // 주차 구역 페이지로 이동
                      //Navigator.pushNamed(context, '/parking-space');
                    },
                    iconSize: 25.0,
                  ),
                ],
              ),
            ),
            if (showContainer)
              Container(
                  margin: EdgeInsets.fromLTRB(25, 10, 25, 0),
                  child: Column(
                    children: <Widget>[
                      Text("show Container"),
                    ],
                  )),
            Container(
                margin: EdgeInsets.fromLTRB(0, 260, 0, 0),
                child: Column(
                  children: [
                    Text('주차장을 검색하세요.'),
                  ],
                )),
          ],
        ),
      ),
      bottomNavigationBar: MenuBottom(1),
    );
  }
}

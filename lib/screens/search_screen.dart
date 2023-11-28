import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/shared/menu_bottom.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/http_setup.dart';

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

  @override
  void initState() {
    super.initState();
    _getSearchItem();
    _getParkingLot();
  }

  _setSearchItem() async {
    setState(() {
      _searchItem = textController.text;
      _pref.setString("searchItem", _searchItem);
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
  }

  _getParkingLot() async {
    _pref = await SharedPreferences.getInstance();
    setState(() {
      _parkingLot = _pref.getString("parkingLot") ?? "";
      _lotKey = _pref.getString("lotKey") ?? "";
    });
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
                    onPressed: () async {
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

                          // 주차 구역 페이지로 이동
                          Navigator.pushNamed(context, '/parking-space');
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
}

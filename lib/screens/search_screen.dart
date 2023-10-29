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
  static List<dynamic> parkingLotList = [];
  static List<String> lotNames = [];
  static List<int> lotKeys = [];
  late SharedPreferences _pref;
  String _searchItem = "";
  String _parkingLot = "";
  int _lotKey = -999;
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
      _pref.setInt("lotKey", _lotKey);
    });
  }

  _getParkingLot() async {
    _pref = await SharedPreferences.getInstance();
    setState(() {
      _parkingLot = _pref.getString("parkingLot") ?? "";
      _lotKey = _pref.getInt("lotKey") ?? -999;
    });
  }

  Future<void> getParkingLotNames() async {
    var response = await post('/getParkingLotList/', '');

    if (response.statusCode == 200) {
      setState(() {
        parkingLotList = response.data['resultData'];
        lotNames = [];
        lotKeys = [];
        for (var item in parkingLotList) {
          String lotName = item['lot_name'];
          int lotKey = item['lot_key'];
          lotNames.add(lotName);
          lotKeys.add(lotKey);
        }
      });
    } else {
      print("서버 응답 오류: ${response.statusCode}");
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
                      // 검색 시 실행할 로직

                      // 검색한 단어 로컬에 저장
                      await _setSearchItem();
                      print("검색한 단어: $_searchItem");

                      // 주차장 이름 불러오기
                      await getParkingLotNames();
                      print("${parkingLotList}");
                      print("lot names: ${lotNames}");

                      // 주차장 목록 띄우기
                      showSearchResult = true;
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

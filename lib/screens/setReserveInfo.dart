import 'package:flutter/material.dart';
import 'package:flutter_app/shared/menu_bottom.dart';
import 'package:intl/intl.dart';

class SetReserveInfo extends StatefulWidget {
  const SetReserveInfo({Key? key}) : super(key: key);

  @override
  State<SetReserveInfo> createState() => _SetReserveInfoState();
}

class _SetReserveInfoState extends State<SetReserveInfo> {
  final String now = new DateTime.now().toString();
  String formattedDate = DateFormat("yyyy.MM.dd HH:mm").format(DateTime.now());
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          title: Text(
            '예약 정보 입력',
            style: TextStyle(color: Color(0xff6528F7)),
          ),
          centerTitle: true,
          backgroundColor: Color(0xffFFFFFF),
          elevation: 1,
          automaticallyImplyLeading: false,
        ),
      ),
      body: Column(
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
                        Text("주차장 이름"), // 검색 시 선택한 주차장 이름 받아옴
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
                      Text("$formattedDate"), // 현재시각
                      Spacer(flex: 20),
                    ]),
                  ),
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
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    decoration: BoxDecoration(
                        color: Color(0xffFFFFFF),
                        border: Border.all(color: Color(0xffA076F9), width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: SizedBox(
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
                    // 차량번호 입력칸
                    width: 270,
                    height: 35,
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    decoration: BoxDecoration(
                        color: Color(0xffFFFFFF),
                        border: Border.all(color: Color(0xffA076F9), width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: SizedBox(
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
                    // 예약 완료 페이지로 이동
                    Navigator.pushNamed(context, '/finish-reserve');
                  },
                  child: Container(
                    // 실시간 예약하기 버튼
                    // 차량번호, 전화번호 데이터 넘겨주기
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xffFFFFFF),
                      border: Border.all(color: Color(0xffA076F9)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(child: Text("실시간 예약하기")),
                  ))),
        ],
      ),
      bottomNavigationBar: MenuBottom(1),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_app/shared/menu_bottom.dart';
import 'package:intl/intl.dart';

class ParkingSpaceScreen extends StatefulWidget {
  const ParkingSpaceScreen({Key? key}) : super(key: key);

  @override
  State<ParkingSpaceScreen> createState() => _ParkingSpaceScreenState();
}

class _ParkingSpaceScreenState extends State<ParkingSpaceScreen> {
  @override
  Widget build(BuildContext context) {
    final String now = new DateTime.now().toString();
    String formattedDate =
        DateFormat("yyyy.MM.dd HH:mm").format(DateTime.now());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          title: Text(
            '주차 구역',
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
          Container(
            // 주차장 이름 & 변경 버튼
            height: 30,
            margin: EdgeInsets.fromLTRB(25, 25, 25, 0),
            child: Row(
              children: [
                Icon(Icons.location_pin),
                Spacer(flex: 1),
                Text("주차장 이름"), // 검색 시 선택한 주차장 이름 받아옴
                Spacer(flex: 20),
                InkWell(
                  onTap: () {
                    // 주차장 선택 페이지로 이동
                    Navigator.pushNamed(context, '/search');
                  },
                  child: Container(
                    // 변경 버튼
                    width: 55,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Color(0xffFFFFFF),
                        border: Border.all(color: Color(0xffA076F9)),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(child: Text("변경")),
                  ),
                )
              ],
            ),
          ),
          Container(
            // 날짜 및 시각 선택
            height: 30,
            margin: EdgeInsets.fromLTRB(25, 25, 25, 0),
            child: Row(children: [
              Icon(Icons.calendar_month),
              Spacer(flex: 1),
              InkWell(
                  onTap: () {
                    // 날짜 변경
                  },
                  child: Text("$formattedDate") // 현재시각
                  ),
              Spacer(flex: 20),
            ]),
          ),
          Container(
            // 주차장 도면
            width: double.infinity,
            height: 390,
            margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
            decoration: BoxDecoration(color: Color(0xffF5F5F5)),
            clipBehavior: Clip.hardEdge,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: 90,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Color(0xff98F976),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 90,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Color(0xffD9D9D9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 90,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Color(0xff98F976),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 90,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Color(0xff98F976),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 50,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 90,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Color(0xffD9D9D9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 90,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Color(0xffD9D9D9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 90,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Color(0xffD9D9D9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 90,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Color(0xffD9D9D9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
              height: 50,
              margin: EdgeInsets.fromLTRB(25, 25, 25, 0),
              child: InkWell(
                  onTap: () {
                    // 주차 예약하기 페이지로 이동
                    Navigator.pushNamed(context, '/setinfo');
                  },
                  child: Container(
                    // 주차 예약하기 버튼
                    //width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xffFFFFFF),
                      border: Border.all(color: Color(0xffA076F9)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(child: Text("주차 예약하기")),
                  ))),
        ],
      ),
      bottomNavigationBar: MenuBottom(1),
    );
  }
}

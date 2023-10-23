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
    ValueNotifier<bool> selectedDate =
        ValueNotifier<bool>(false); // 날짜 선택할 건가요? > 캘린더 버튼 누르면 true, 아니면 false
    ValueNotifier<bool> selectedToday =
        ValueNotifier<bool>(false); // 오늘 날짜를 선택했나요?
    ValueNotifier<bool> preReservationState = ValueNotifier<bool>(
        false); // 사전 예약인지 아닌지 > selectedToday로 한꺼번에 해결해 보려 했는데 날짜 선택 페이지에서 다음으로 넘어가는 단계가 애매해서 그냥 변수 하나 더 뒀습니다
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
      body: ValueListenableBuilder(
          valueListenable: selectedDate,
          builder: (context, value, child) {
            return ValueListenableBuilder(
                valueListenable: selectedToday,
                builder: (context, value, child) {
                  return ValueListenableBuilder(
                    valueListenable: preReservationState,
                    builder: (context, value, child) {
                      return Column(
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
                                        border: Border.all(
                                            color: Color(0xffA076F9)),
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints:
                                    BoxConstraints(), // padding, constraints >> IconButton의 자체 여백 없애는 요소
                                icon: Icon(Icons.calendar_month),
                                onPressed: () {
                                  selectedDate.value = true;
                                },
                              ),
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
                          if (!selectedDate.value &&
                              !selectedToday.value &&
                              !preReservationState.value)
                            Container(
                              // 주차장 도면
                              width: double.infinity,
                              height: 390,
                              margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
                              decoration:
                                  BoxDecoration(color: Color(0xffF5F5F5)),
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        width: 90,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          color: Color(0xffD9D9D9),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        width: 90,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          color: Color(0xff98F976),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        width: 90,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          color: Color(0xff98F976),
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        width: 90,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          color: Color(0xffD9D9D9),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        width: 90,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          color: Color(0xffD9D9D9),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        width: 90,
                                        height: 150,
                                        decoration: BoxDecoration(
                                          color: Color(0xffD9D9D9),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          else if (selectedDate.value &&
                              !selectedToday.value &&
                              !preReservationState.value)
                            Container(
                              margin: EdgeInsets.only(top: 25.0),
                              child: SizedBox(
                                  width: double.infinity,
                                  height: 465.0,
                                  child: DecoratedBox(
                                    child: Column(
                                      children: [
                                        Text(
                                            "여기에 SizedBox 대신 달력 라이브러리 넣으시면 됩니당"),
                                        // 임시로 텍스트 버튼으로 만들었어여...
                                        TextButton(
                                            onPressed: (() {
                                              selectedToday.value = true;
                                            }),
                                            child: Text("오늘 날짜 선택한다면")),
                                        TextButton(
                                            onPressed: (() {
                                              selectedToday.value = false;
                                              preReservationState.value = true;
                                            }),
                                            child: Text("다른 날짜 선택한다면"))
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                    ),
                                  )),
                            )
                          else if (selectedDate.value &&
                              !selectedToday.value &&
                              preReservationState.value)
                            Container(
                              margin: EdgeInsets.only(top: 25.0),
                              child: SizedBox(
                                  width: double.infinity,
                                  height: 465.0,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 74.0,
                                        decoration: BoxDecoration(
                                            border: Border(
                                          top: BorderSide(
                                              width: 1.0,
                                              color: Color(0xffD9D9D9)),
                                          bottom: BorderSide(
                                              width: 1.0,
                                              color: Color(0xffD9D9D9)),
                                        )),
                                        child: Center(
                                          child: Text("선택한 날짜 들어갈 자리",
                                              style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                              )),
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 391.0,
                                        decoration: BoxDecoration(
                                            border: Border(
                                          bottom: BorderSide(
                                              width: 1.0,
                                              color: Color(0xffD9D9D9)),
                                        )),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                                "여기 날짜 선택 라이브러리.. 간격은 라이브러리 넣고 조정해야 할 듯함 (무책임)"),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  width: 100.0,
                                                  height: 50.0,
                                                  child: OutlinedButton(
                                                      onPressed: () {
                                                        selectedToday.value =
                                                            false;
                                                        preReservationState
                                                            .value = false;
                                                      },
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        side: BorderSide(
                                                          color:
                                                              Color(0xffA076F9),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        "이전",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20.0),
                                                      )),
                                                ),
                                                Container(
                                                  width: 100.0,
                                                  height: 50.0,
                                                  child: OutlinedButton(
                                                      onPressed: () {},
                                                      style: OutlinedButton
                                                          .styleFrom(
                                                        side: BorderSide(
                                                          color:
                                                              Color(0xffA076F9),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        "다음",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 20.0),
                                                      )),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  )),
                            )
                          else if (selectedDate.value &&
                              selectedToday.value &&
                              !preReservationState.value)
                            Container(child: Text("여기 이제 (1)실시간 예약")),
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
                                      border:
                                          Border.all(color: Color(0xffA076F9)),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(child: Text("주차 예약하기")),
                                  ))),
                        ],
                      );
                    },
                  );
                });
          }),
      bottomNavigationBar: MenuBottom(1),
    );
  }
}

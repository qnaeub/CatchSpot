import 'package:flutter/material.dart';
import 'package:flutter_app/screens/setReserveInfo.dart';
import 'package:flutter_app/shared/menu_bottom.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoom_widget/zoom_widget.dart';

class ParkingSpaceScreen extends StatefulWidget {
  // const ParkingSpaceScreen({Key? key}) : super(key: key);
  ValueNotifier<bool>
      data; // selectedDate의 값 받아옴. <사전 예약> 단계에서 [이전] 버튼 눌렀을 때 이 위젯으로 돌아오게 되면 날짜 선택이 아니라 도면 페이지로 시작하는데,
  // 이걸 막고 날짜 선택 화면을 띄워주기 위함. 필요에 따라서 주차장 이름 등도 같이 필요하다면 같이 전달해주면 될 듯?
  ParkingSpaceScreen({required this.data});

  @override
  State<ParkingSpaceScreen> createState() => _ParkingSpaceScreenState();
}

class _ParkingSpaceScreenState extends State<ParkingSpaceScreen> {
  ValueNotifier<bool> selectedDate =
      ValueNotifier<bool>(false); // 날짜 선택할 건가요? > 캘린더 버튼 누르면 true, 아니면 false
  late SharedPreferences _pref;
  String _carnum = "";
  String _phonenum = "";
  String _parkingLot = "";

  @override
  void initState() {
    super.initState();
    _getCarAndPhonenum();
    _getParkingLot();
    selectedDate = widget.data; // initState() 단에서 전달받은 데이터를 변수에 할당해주기
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
      body: ValueListenableBuilder(
        valueListenable: selectedDate,
        builder: (context, value, child) {
          return Column(
            children: <Widget>[
              Expanded(
                  child: SingleChildScrollView(
                      child: Column(
                children: <Widget>[
                  Container(
                    // 주차장 이름 & 변경 버튼
                    height: 30,
                    margin: EdgeInsets.fromLTRB(25, 25, 25, 0),
                    child: Row(
                      children: [
                        Icon(Icons.location_pin),
                        Spacer(flex: 1),
                        Text("$_parkingLot"), // 검색 시 선택한 주차장 이름 받아옴
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
                  if (!selectedDate.value)
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
                    )
                  else
                    Container(
                      margin: EdgeInsets.only(top: 25.0),
                      child: SizedBox(
                          width: double.infinity,
                          height: 465.0,
                          child: DecoratedBox(
                            child: Column(
                              children: [
                                Text("달력 라이브러리"),
                                // 임시로 텍스트 버튼으로 만들었어여...
                                TextButton(
                                    onPressed: (() {
                                      Navigator.pushNamed(
                                          context, '/parking-space');
                                    }),
                                    child: Text("오늘 날짜 선택한다면")),
                                TextButton(
                                    onPressed: (() {
                                      Navigator.pushNamed(
                                          context, '/pre-reservation');
                                    }),
                                    child: Text("다른 날짜 선택한다면"))
                              ],
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                            ),
                          )),
                    ),
                ],
              ))),
              if (_carnum != "" && _phonenum != "")
                Container(
                    height: 50,
                    margin: EdgeInsets.fromLTRB(25, 25, 25, 25),
                    child: Container(
                      // 주차 예약하기 버튼
                      //width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xffFFFFFF),
                        border: Border.all(color: Color(0xffD9D9D9)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(child: Text("주차 예약하기")),
                    ))
              else
                Container(
                    height: 50,
                    margin: EdgeInsets.fromLTRB(25, 25, 25, 25),
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
          );
        },
      ),
      bottomNavigationBar: MenuBottom(1),
    );
  }
}

class PreReservation extends StatefulWidget {
  const PreReservation({super.key});

  @override
  State<PreReservation> createState() => _PreReservationState();
}

class _PreReservationState extends State<PreReservation> {
  ValueNotifier<int> currentPage =
      ValueNotifier<int>(1); // <사전 예약> 위젯에서는 현재 페이지를 변수로 저장하여 왔다 갔다 할 수 있도록 했어요
  late SharedPreferences _pref;
  String _carnum = "";
  String _phonenum = "";
  String _parkingLot = "";
  bool click = false;

  @override
  void initState() {
    super.initState();
    _getParkingLot();
    _getCarAndPhonenum();
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

  @override
  Widget build(BuildContext context) {
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
          valueListenable: currentPage,
          builder: (context, value, child) {
            return Column(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        // 주차장 이름 & 변경 버튼
                        height: 30,
                        margin: EdgeInsets.fromLTRB(25, 25, 25, 0),
                        child: Row(
                          children: [
                            Icon(Icons.location_pin),
                            Spacer(flex: 1),
                            Text("$_parkingLot"), // 검색 시 선택한 주차장 이름 받아옴
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
                                    border:
                                        Border.all(color: Color(0xffA076F9)),
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
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints:
                                BoxConstraints(), // padding, constraints >> IconButton의 자체 여백 없애는 요소
                            icon: Icon(Icons.calendar_month),
                            onPressed: () {},
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
                      if (currentPage.value == 1)
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
                                          width: 1.0, color: Color(0xffD9D9D9)),
                                      bottom: BorderSide(
                                          width: 1.0, color: Color(0xffD9D9D9)),
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
                                          width: 1.0, color: Color(0xffD9D9D9)),
                                    )),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text("시간 선택 라이브러리"),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                              width: 100.0,
                                              height: 50.0,
                                              child: OutlinedButton(
                                                  onPressed: () {
                                                    // Navigator.pushNamed(
                                                    //     context, '/parking-space');
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ParkingSpaceScreen(
                                                                  data: ValueNotifier<
                                                                          bool>(
                                                                      true))),
                                                    );
                                                  },
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    side: BorderSide(
                                                      color: Color(0xffA076F9),
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
                                                  onPressed: () {
                                                    currentPage.value = 2;
                                                  },
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    side: BorderSide(
                                                      color: Color(0xffA076F9),
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
                      else if (currentPage.value == 2)
                        Container(
                            // 주차장 도면
                            width: double.infinity,
                            height: 390,
                            margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
                            decoration: BoxDecoration(color: Color(0xffF5F5F5)),
                            clipBehavior: Clip.hardEdge,
                            child: Zoom(
                              initTotalZoomOut: true,
                              maxZoomWidth: 500,
                              maxZoomHeight: 500,
                              canvasColor: Color(0xffF5F5F5),
                              child: Column(
                                children: [
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
                                      Container(
                                        width: 90,
                                        height: 150,
                                        margin:
                                            EdgeInsets.fromLTRB(20, 0, 0, 0),
                                        decoration: BoxDecoration(
                                          color: Color(0xffD9D9D9),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      Container(
                                        width: 90,
                                        height: 150,
                                        margin:
                                            EdgeInsets.fromLTRB(20, 0, 0, 0),
                                        decoration: BoxDecoration(
                                          color: Color(0xffD9D9D9),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      Container(
                                        width: 90,
                                        height: 150,
                                        margin:
                                            EdgeInsets.fromLTRB(20, 0, 0, 0),
                                        decoration: BoxDecoration(
                                          color: Color(0xffD9D9D9),
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
                                          color: Color(0xffA076F9),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      Container(
                                        width: 90,
                                        height: 150,
                                        margin:
                                            EdgeInsets.fromLTRB(20, 0, 0, 0),
                                        decoration: BoxDecoration(
                                          color: Color(0xffA076F9),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      Container(
                                        width: 90,
                                        height: 150,
                                        margin:
                                            EdgeInsets.fromLTRB(20, 0, 0, 0),
                                        decoration: BoxDecoration(
                                          color: Color(0xffA076F9),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          print("Click");
                                          setState(() {
                                            click = true;
                                          });
                                        },
                                        child: Container(
                                            width: 90,
                                            height: 150,
                                            margin: EdgeInsets.fromLTRB(
                                                20, 0, 0, 0),
                                            decoration: BoxDecoration(
                                              color: Color(0xffA076F9),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              children: [
                                                Spacer(),
                                                if (click == true)
                                                  Center(
                                                      child: Text(
                                                    "Catch Spot!",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xffFFFFFF)),
                                                  )),
                                                Spacer(),
                                              ],
                                            )),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ))
                      else if (currentPage.value == 3)
                        Container(),
                    ],
                  ),
                )),
                if (_carnum != "" && _phonenum != "")
                  Container(
                      height: 50,
                      margin: EdgeInsets.fromLTRB(25, 25, 25, 25),
                      child: Container(
                        // 주차 예약하기 버튼
                        //width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xffFFFFFF),
                          border: Border.all(color: Color(0xffD9D9D9)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(child: Text("주차 예약하기")),
                      ))
                else
                  Container(
                      height: 50,
                      margin: EdgeInsets.fromLTRB(25, 25, 25, 25),
                      child: InkWell(
                          onTap: () {
                            // 단순 경로 이동이 아닌 인자를 같이 전달해야 할 경우 이렇게 전달하면 된다고 합니다
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SetReserveInfo(
                                      realTime: ValueNotifier<bool>(false))),
                            );
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
            );
          }),
      bottomNavigationBar: MenuBottom(1),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color(0xffD9D9D9)
      ..style = PaintingStyle.fill;

    canvas.drawRect(Offset(0, 0) & const Size(500, 500), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class BoxPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint2 = Paint()
      ..color = Color(0xffA076F9)
      ..style = PaintingStyle.fill;

    canvas.drawRect(Offset(0, 0) & const Size(50, 100), paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_app/screens/setReserveInfo.dart';
import 'package:flutter_app/shared/menu_bottom.dart';
import 'package:flutter_app/parkingLot_Space.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

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
  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime focusedDay = DateTime.now();

  late SharedPreferences _pref;
  String _carnum = "";
  String _phonenum = "";
  String _parkingLot = "";
  String _reserveDate = "";
  String _reserveYear = "";
  String _reserveMonth = "";
  String _reserveDay = "";
  String _reserveHour = "";
  String _reserveMinute = "";

  @override
  void initState() {
    super.initState();
    _getReserveDate();
    _getCarAndPhonenum();
    _getParkingLot();
    selectedDate = widget.data; // initState() 단에서 전달받은 데이터를 변수에 할당해주기
  }

  _setReserveDate() async {
    setState(() {
      _pref.setString("reserveDate", _reserveDate);
    });
  }

  _getReserveDate() async {
    _pref = await SharedPreferences.getInstance();
    setState(() {
      _reserveDate = _pref.getString("reserveDate") ?? "";
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
                            selectedDate.value = true;
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
                      child: ParkingLotAReal(),
                    )
                  else
                    Container(
                      margin: EdgeInsets.only(top: 25.0),
                      child: SizedBox(
                          width: double.infinity,
                          height: 465.0,
                          child: TableCalendar(
                            firstDay: DateTime.now(),
                            lastDay: DateTime(DateTime.now().year,
                                DateTime.now().month, DateTime.now().day + 7),
                            focusedDay: DateTime.now(),
                            //locale: 'ko-KR',
                            headerStyle: HeaderStyle(
                              formatButtonVisible: false,
                              titleCentered: true,
                            ),
                            calendarStyle: CalendarStyle(
                              weekendTextStyle: const TextStyle(
                                  color: const Color(0xFFFF0000)),
                            ),
                            onDaySelected:
                                (DateTime selectedDay, DateTime focusedDay) {
                              // 선택된 날짜의 상태 갱신
                              setState(() {
                                this.selectedDay = selectedDay;
                                this.focusedDay = focusedDay;
                              });

                              if ((selectedDay.month == DateTime.now().month) &&
                                  (selectedDay.day == DateTime.now().day)) {
                                print("오늘 날짜 선택");
                                Navigator.pushNamed(context, '/parking-space');
                              } else {
                                _reserveDate = selectedDay.toString();
                                _setReserveDate();
                                print("다른 날짜 선택: $_reserveDate");
                                Navigator.pushNamed(
                                    context, '/pre-reservation');
                              }
                            },
                            selectedDayPredicate: (DateTime day) {
                              // selectedDay 와 동일한 날짜의 모양 바꾸기
                              return isSameDay(selectedDay, day);
                            },
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
  String _reserveDate = "";
  DateTime _datetime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _setReserveDate();
    _getReserveDate();
    _getParkingLot();
    _getCarAndPhonenum();
  }

  _setReserveDate() async {
    setState(() {
      _reserveDate = _datetime.toString();
      _pref.setString("reserveDate", _reserveDate);
    });
  }

  _getReserveDate() async {
    _pref = await SharedPreferences.getInstance();
    setState(() {
      _datetime = DateTime.parse(_pref.getString("reserveDate") ?? "");
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
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ParkingSpaceScreen(
                                          data: ValueNotifier<bool>(true))));
                            },
                          ),
                          Spacer(flex: 1),
                          InkWell(
                              onTap: () {
                                // 날짜 변경
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ParkingSpaceScreen(
                                                data: ValueNotifier<bool>(
                                                    true))));
                              },
                              child: Text("$formattedDate") // 현재시각
                              ),
                          Spacer(flex: 20),
                        ]),
                      ),
                      if (currentPage.value == 1)
                        Container(
                          margin: EdgeInsets.only(top: 25.0),
                          child: Center(
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
                                  child: Text(
                                      "${_datetime.year}년 ${_datetime.month}월 ${_datetime.day}일",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                                  child: TimePickerSpinner(
                                    time: _datetime,
                                    minutesInterval: 10,
                                    is24HourMode: false,
                                    itemHeight: 60,
                                    normalTextStyle: const TextStyle(
                                        fontSize: 30, color: Color(0xffD9D9D9)),
                                    highlightedTextStyle: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff000000)),
                                    isForce2Digits: true,
                                    spacing: 50,
                                    onTimeChange: (time) {
                                      _datetime = DateTime(
                                          _datetime.year,
                                          _datetime.month,
                                          _datetime.day,
                                          time.hour,
                                          time.minute);
                                      _setReserveDate();
                                      print("예약날짜: ${_reserveDate}");
                                    },
                                  )),
                              Container(
                                  margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                                  child: Row(
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
                                                                bool>(true))),
                                              );
                                            },
                                            style: OutlinedButton.styleFrom(
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
                                            style: OutlinedButton.styleFrom(
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
                                  )),
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
                            child: ParkingLotAPre())
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

class TimePicker extends StatefulWidget {
  const TimePicker({super.key});

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  TimeOfDay initialTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          '${initialTime.hour}:${initialTime.minute}',
          style: TextStyle(fontSize: 40),
        ),
        ElevatedButton(
            onPressed: () async {
              final TimeOfDay? timeOfDay = await showTimePicker(
                context: context,
                initialTime: initialTime,
              );
              if (timeOfDay != null) {
                setState(() {
                  initialTime = timeOfDay;
                });
              }
            },
            child: Text('TimePicker'))
      ]),
    );
  }
}

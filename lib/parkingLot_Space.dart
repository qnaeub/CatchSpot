import 'package:flutter/material.dart';
import 'package:zoom_widget/zoom_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParkingLotAReal extends StatefulWidget {
  const ParkingLotAReal({Key? key}) : super(key: key);

  @override
  ParkingLotARealState createState() => ParkingLotARealState();
}

class ParkingLotARealState extends State<ParkingLotAReal> {
  @override
  Widget build(BuildContext context) {
    return Zoom(
      initTotalZoomOut: true,
      maxZoomWidth: 500,
      maxZoomHeight: 500,
      canvasColor: Color(0xffF5F5F5),
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
              Container(
                width: 90,
                height: 150,
                margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                decoration: BoxDecoration(
                  color: Color(0xffD9D9D9),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Container(
                width: 90,
                height: 150,
                margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                decoration: BoxDecoration(
                  color: Color(0xff98F976),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Container(
                width: 90,
                height: 150,
                margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
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
              Container(
                width: 90,
                height: 150,
                margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                decoration: BoxDecoration(
                  color: Color(0xffD9D9D9),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Container(
                width: 90,
                height: 150,
                margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                decoration: BoxDecoration(
                  color: Color(0xffD9D9D9),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Container(
                width: 90,
                height: 150,
                margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                decoration: BoxDecoration(
                  color: Color(0xffD9D9D9),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ParkingLotAPre extends StatefulWidget {
  const ParkingLotAPre({Key? key}) : super(key: key);

  @override
  ParkingLotAPreState createState() => ParkingLotAPreState();
}

class ParkingLotAPreState extends State<ParkingLotAPre> {
  late SharedPreferences _pref;
  bool click = false;
  String _zoneName = "";

  @override
  void initState() {
    super.initState();
    _getParkingZone();
  }

  _setParkingZone() async {
    setState(() {
      _pref.setString("parkingZone", _zoneName);
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
    return Zoom(
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
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Container(
                width: 90,
                height: 150,
                margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                decoration: BoxDecoration(
                  color: Color(0xffD9D9D9),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Container(
                width: 90,
                height: 150,
                margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                decoration: BoxDecoration(
                  color: Color(0xffD9D9D9),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Container(
                width: 90,
                height: 150,
                margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                decoration: BoxDecoration(
                  color: Color(0xffD9D9D9),
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
              InkWell(
                onTap: () {
                  print("Click");
                  setState(() {
                    click = true;
                    _zoneName = "A005";
                    _setParkingZone();
                  });
                },
                child: Container(
                    width: 90,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Color(0xffA076F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Spacer(),
                        if (click == true && _zoneName == "A005") ...[
                          Center(
                              child: Text(
                            "Catch Spot!",
                            style: TextStyle(color: Color(0xffFFFFFF)),
                          )),
                        ],
                        Spacer(),
                      ],
                    )),
              ),
              InkWell(
                onTap: () {
                  print("Click");
                  setState(() {
                    click = true;
                    _zoneName = "A006";
                    _setParkingZone();
                  });
                },
                child: Container(
                    width: 90,
                    height: 150,
                    margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    decoration: BoxDecoration(
                      color: Color(0xffA076F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Spacer(),
                        if (click == true && _zoneName == "A006") ...[
                          Center(
                              child: Text(
                            "Catch Spot!",
                            style: TextStyle(color: Color(0xffFFFFFF)),
                          )),
                        ],
                        Spacer(),
                      ],
                    )),
              ),
              InkWell(
                onTap: () {
                  print("Click");
                  setState(() {
                    click = true;
                    _zoneName = "A007";
                    _setParkingZone();
                  });
                },
                child: Container(
                    width: 90,
                    height: 150,
                    margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    decoration: BoxDecoration(
                      color: Color(0xffA076F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Spacer(),
                        if (click == true && _zoneName == "A007") ...[
                          Center(
                              child: Text(
                            "Catch Spot!",
                            style: TextStyle(color: Color(0xffFFFFFF)),
                          )),
                        ],
                        Spacer(),
                      ],
                    )),
              ),
              InkWell(
                onTap: () {
                  print("Click");
                  setState(() {
                    click = true;
                    _zoneName = "A008";
                    _setParkingZone();
                  });
                },
                child: Container(
                    width: 90,
                    height: 150,
                    margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    decoration: BoxDecoration(
                      color: Color(0xffA076F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Spacer(),
                        if (click == true && _zoneName == "A008") ...[
                          Center(
                              child: Text(
                            "Catch Spot!",
                            style: TextStyle(color: Color(0xffFFFFFF)),
                          )),
                        ],
                        Spacer(),
                      ],
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

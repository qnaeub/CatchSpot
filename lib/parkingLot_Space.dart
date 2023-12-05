import 'package:flutter/material.dart';
import 'package:zoom_widget/zoom_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParkingLotAReal extends StatefulWidget {
  const ParkingLotAReal({Key? key}) : super(key: key);

  @override
  ParkingLotARealState createState() => ParkingLotARealState();
}

class ParkingLotARealState extends State<ParkingLotAReal> {
  late SharedPreferences _pref;
  List<String> _realLot = [];

  @override
  void initState() {
    super.initState();
    _getLotSpace();
  }

  _getLotSpace() async {
    _pref = await SharedPreferences.getInstance();
    setState(() {
      _realLot = _pref.getStringList("realLot") ?? [];
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
        children: <Widget>[
          Row(
            children: <Widget>[
              if (_realLot.contains('Z001'))
                Container(
                  width: 90,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Color(0xff98F976),
                    borderRadius: BorderRadius.circular(10),
                  ),
                )
              else
                Container(
                  width: 90,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Color(0xffD9D9D9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              if (_realLot.contains('Z003'))
                Container(
                  width: 90,
                  height: 150,
                  margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  decoration: BoxDecoration(
                    color: Color(0xff98F976),
                    borderRadius: BorderRadius.circular(10),
                  ),
                )
              else
                Container(
                  width: 90,
                  height: 150,
                  margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  decoration: BoxDecoration(
                    color: Color(0xffD9D9D9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              if (_realLot.contains('Z005'))
                Container(
                  width: 90,
                  height: 150,
                  margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  decoration: BoxDecoration(
                    color: Color(0xff98F976),
                    borderRadius: BorderRadius.circular(10),
                  ),
                )
              else
                Container(
                  width: 90,
                  height: 150,
                  margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  decoration: BoxDecoration(
                    color: Color(0xffD9D9D9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              if (_realLot.contains('Z007'))
                Container(
                  width: 90,
                  height: 150,
                  margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  decoration: BoxDecoration(
                    color: Color(0xff98F976),
                    borderRadius: BorderRadius.circular(10),
                  ),
                )
              else
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
              if (_realLot.contains('Z002'))
                Container(
                  width: 90,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Color(0xff98F976),
                    borderRadius: BorderRadius.circular(10),
                  ),
                )
              else
                Container(
                  width: 90,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Color(0xffD9D9D9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              if (_realLot.contains('Z004'))
                Container(
                  width: 90,
                  height: 150,
                  margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  decoration: BoxDecoration(
                    color: Color(0xff98F976),
                    borderRadius: BorderRadius.circular(10),
                  ),
                )
              else
                Container(
                  width: 90,
                  height: 150,
                  margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  decoration: BoxDecoration(
                    color: Color(0xffD9D9D9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              if (_realLot.contains('Z006'))
                Container(
                  width: 90,
                  height: 150,
                  margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  decoration: BoxDecoration(
                    color: Color(0xff98F976),
                    borderRadius: BorderRadius.circular(10),
                  ),
                )
              else
                Container(
                  width: 90,
                  height: 150,
                  margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  decoration: BoxDecoration(
                    color: Color(0xffD9D9D9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              if (_realLot.contains('Z008'))
                Container(
                  width: 90,
                  height: 150,
                  margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  decoration: BoxDecoration(
                    color: Color(0xff98F976),
                    borderRadius: BorderRadius.circular(10),
                  ),
                )
              else
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
  List<String> _preLot = [];

  @override
  void initState() {
    super.initState();
    _getParkingZone();
    _getLotSpace();
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

  _getLotSpace() async {
    _pref = await SharedPreferences.getInstance();
    setState(() {
      _preLot = _pref.getStringList("preLot") ?? [];
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
              if (_preLot.contains('Z001'))
                InkWell(
                  onTap: () {
                    print("Click");
                    setState(() {
                      click = true;
                      _zoneName = "Z001";
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
                          if (click == true && _zoneName == "Z001") ...[
                            Center(
                                child: Text(
                              "Catch\nSpot!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xffFFFFFF),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23),
                            )),
                          ],
                          Spacer(),
                        ],
                      )),
                )
              else
                Container(
                  width: 90,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Color(0xffD9D9D9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              if (_preLot.contains('Z003'))
                InkWell(
                  onTap: () {
                    print("Click");
                    setState(() {
                      click = true;
                      _zoneName = "Z003";
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
                          if (click == true && _zoneName == "Z003") ...[
                            Center(
                                child: Text(
                              "Catch\nSpot!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xffFFFFFF),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23),
                            )),
                          ],
                          Spacer(),
                        ],
                      )),
                )
              else
                Container(
                  width: 90,
                  height: 150,
                  margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  decoration: BoxDecoration(
                    color: Color(0xffD9D9D9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              if (_preLot.contains('Z005'))
                InkWell(
                  onTap: () {
                    print("Click");
                    setState(() {
                      click = true;
                      _zoneName = "Z005";
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
                          if (click == true && _zoneName == "Z005") ...[
                            Center(
                                child: Text(
                              "Catch\nSpot!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xffFFFFFF),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23),
                            )),
                          ],
                          Spacer(),
                        ],
                      )),
                )
              else
                Container(
                  width: 90,
                  height: 150,
                  margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  decoration: BoxDecoration(
                    color: Color(0xffD9D9D9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              if (_preLot.contains('Z007'))
                InkWell(
                  onTap: () {
                    print("Click");
                    setState(() {
                      click = true;
                      _zoneName = "Z007";
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
                          if (click == true && _zoneName == "Z007") ...[
                            Center(
                                child: Text(
                              "Catch\nSpot!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xffFFFFFF),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23),
                            )),
                          ],
                          Spacer(),
                        ],
                      )),
                )
              else
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
              if (_preLot.contains('Z002'))
                InkWell(
                  onTap: () {
                    print("Click");
                    setState(() {
                      click = true;
                      _zoneName = "Z002";
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
                          if (click == true && _zoneName == "Z002") ...[
                            Center(
                                child: Text(
                              "Catch\nSpot!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xffFFFFFF),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23),
                            )),
                          ],
                          Spacer(),
                        ],
                      )),
                )
              else
                Container(
                  width: 90,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Color(0xffD9D9D9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              if (_preLot.contains('Z004'))
                InkWell(
                  onTap: () {
                    print("Click");
                    setState(() {
                      click = true;
                      _zoneName = "Z004";
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
                          if (click == true && _zoneName == "Z004") ...[
                            Center(
                                child: Text(
                              "Catch\nSpot!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xffFFFFFF),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23),
                            )),
                          ],
                          Spacer(),
                        ],
                      )),
                )
              else
                Container(
                  width: 90,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Color(0xffD9D9D9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              if (_preLot.contains('Z006'))
                InkWell(
                  onTap: () {
                    print("Click");
                    setState(() {
                      click = true;
                      _zoneName = "Z006";
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
                          if (click == true && _zoneName == "Z006") ...[
                            Center(
                                child: Text(
                              "Catch\nSpot!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xffFFFFFF),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23),
                            )),
                          ],
                          Spacer(),
                        ],
                      )),
                )
              else
                Container(
                  width: 90,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Color(0xffD9D9D9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              if (_preLot.contains('Z008'))
                InkWell(
                  onTap: () {
                    print("Click");
                    setState(() {
                      click = true;
                      _zoneName = "Z008";
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
                          if (click == true && _zoneName == "Z008") ...[
                            Center(
                                child: Text(
                              "Catch\nSpot!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color(0xffFFFFFF),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23),
                            )),
                          ],
                          Spacer(),
                        ],
                      )),
                )
              else
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
    );
  }
}

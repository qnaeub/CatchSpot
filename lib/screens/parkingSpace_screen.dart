import 'package:flutter/material.dart';
import 'package:flutter_app/shared/menu_bottom.dart';

class ParkingSpaceScreen extends StatefulWidget {
  const ParkingSpaceScreen({Key? key}) : super(key: key);

  @override
  State<ParkingSpaceScreen> createState() => _ParkingSpaceScreenState();
}

class _ParkingSpaceScreenState extends State<ParkingSpaceScreen> {
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
      body: Container(
        width: double.infinity,
        height: 465,
        margin: EdgeInsets.fromLTRB(0, 185, 0, 150),
        decoration: BoxDecoration(color: Color(0xffF5F5F5)),
        child: Row(
          children: <Widget>[
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
      ),
      bottomNavigationBar: MenuBottom(1),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/screens/management_screen.dart';
import 'package:flutter_app/shared/menu_bottom.dart';

class FinishReserve extends StatefulWidget {
  const FinishReserve({Key? key}) : super(key: key);

  @override
  State<FinishReserve> createState() => _FinishReserveState();
}

class _FinishReserveState extends State<FinishReserve> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ManageScreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          title: Text(
            '예약 완료',
            style: TextStyle(color: Color(0xff6528F7)),
          ),
          centerTitle: true,
          backgroundColor: Color(0xffFFFFFF),
          elevation: 1,
          automaticallyImplyLeading: false,
        ),
      ),
      body: Center(child: Text("예약이 완료되었습니다")),
      bottomNavigationBar: MenuBottom(1),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_app/shared/menu_bottom.dart';

class SetReserveInfo extends StatefulWidget {
  const SetReserveInfo({Key? key}) : super(key: key);

  @override
  State<SetReserveInfo> createState() => _SetReserveInfoState();
}

class _SetReserveInfoState extends State<SetReserveInfo> {
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
      body: Column(),
      bottomNavigationBar: MenuBottom(1),
    );
  }
}

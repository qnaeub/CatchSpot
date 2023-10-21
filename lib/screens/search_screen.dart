import 'package:flutter/material.dart';
import 'package:flutter_app/shared/menu_bottom.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
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
      body: Column(
        children: <Widget>[
          Container(
            width: 330,
            height: 50,
            margin: EdgeInsets.all(25),
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            decoration: BoxDecoration(
                color: Color(0xffFFFFFF),
                border: Border.all(color: Color(0xffA076F9), width: 1),
                borderRadius: BorderRadius.circular(30)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.mic),
                Icon(Icons.search),
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.fromLTRB(0, 260, 0, 0),
              child: Text('주차장을 검색하세요.')),
        ],
      ),
      bottomNavigationBar: MenuBottom(),
    );
  }
}

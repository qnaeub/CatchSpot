import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/shared/menu_bottom.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController textController = TextEditingController();

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
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              // width: 330,
              height: 50,
              margin: EdgeInsets.fromLTRB(15, 25, 15, 0),
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              decoration: BoxDecoration(
                  color: Color(0xffFFFFFF),
                  border: Border.all(color: Color(0xffA076F9), width: 1),
                  borderRadius: BorderRadius.circular(30)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.mic),
                    onPressed: () {
                      // 음성 검색 시 실행할 로직
                    },
                    iconSize: 25.0,
                  ),
                  SizedBox(
                    width: 200.0,
                    child: TextField(
                      cursorColor: Color(0xffA076F9),
                      controller: textController,
                      style: TextStyle(),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      // 검색 실행할 시 실행할 로직
                      // 저장된 텍스트는 textController.text 로 접근 가능
                    },
                    iconSize: 25.0,
                  ),
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.fromLTRB(0, 260, 0, 0),
                child: Column(
                  children: [
                    Text('주차장을 검색하세요.'),
                  ],
                )),
          ],
        ),
      ),
      bottomNavigationBar: MenuBottom(1),
    );
  }
}

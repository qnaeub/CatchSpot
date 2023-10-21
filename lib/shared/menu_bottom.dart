import 'package:flutter/material.dart';

class MenuBottom extends StatefulWidget {
  const MenuBottom(this.desiredIndex, {Key? key}) : super(key: key);
  final int desiredIndex;

  @override
  MenuBottomState createState() => MenuBottomState();
}

class MenuBottomState extends State<MenuBottom> {
  int _currentIndex = 0;
  late PageController pagecontroller;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.desiredIndex;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      selectedItemColor: Color(0xff6528F7),
      unselectedItemColor: Color(0xff000000),
      onTap: (index) {
        setState(() {
          _currentIndex = index;
          // pagecontroller.jumpToPage(index);
          print(index);
        });
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/navigate');
            break;
          case 1:
            Navigator.pushNamed(context, '/search');
            break;
          case 2:
            Navigator.pushNamed(context, '/manage');
            break;
          default:
        }
      },
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.navigation), label: 'Navigate'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Manage'),
      ],
      showSelectedLabels: false,
      showUnselectedLabels: false,
    );
  }
}

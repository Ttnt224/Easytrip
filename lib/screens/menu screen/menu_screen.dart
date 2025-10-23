import 'package:flutter/material.dart';
import 'package:myapplication/screens/chatscreen/chat_screen.dart';
import 'package:myapplication/screens/homescreen/home_screen_view.dart';
import 'package:myapplication/screens/profile%20screen/profile_screen_view.dart';
import 'package:myapplication/screens/trip_screen/trip_screen_view.dart';


class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  var _selectedIndex = 0;

  final List<Widget> _page = [
    Homeview(), //Index0
    TripScreenView(), //Index1
    ChatScreen(),//Index3
    ProfileScreenView(), //Index3
  ];

  //เปลี่ยน UI
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _page[_selectedIndex], //เข้าถึง list ผ่าน Index
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 21, 20, 95),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black38,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          //ปุ่มHome
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          //ปุ่มMap
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Trip'),
          //ปุ่มProfile
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          //ปุ่มProfile
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

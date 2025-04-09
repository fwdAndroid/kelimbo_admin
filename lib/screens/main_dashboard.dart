import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kelimbo_admin/screens/pages/category_page.dart';
import 'package:kelimbo_admin/screens/pages/profile_page.dart';
import 'package:kelimbo_admin/screens/pages/users_page.dart';
import 'package:kelimbo_admin/utils/color.dart';

class MainDashboard extends StatefulWidget {
  @override
  _MainDashboardState createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    UsersPage(),
    CategoryPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          final shouldPop = await _showExitDialog(context);
          return shouldPop ?? false;
        },
        child: Scaffold(
          body: _screens[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: TextStyle(color: mainColor),
            unselectedLabelStyle: TextStyle(color: iconColor),
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  height: 27,
                  width: 27,
                  _currentIndex == 0
                      ? "assets/person_blue.png"
                      : "assets/person_grey.png",
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  height: 27,
                  width: 27,
                  _currentIndex == 1
                      ? "assets/add_blue.png"
                      : "assets/add_grey.png",
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(_currentIndex == 2
                    ? Icons.settings
                    : Icons.settings_accessibility_outlined),
                label: '',
              ),
            ],
          ),
        ));
  }

  _showExitDialog(BuildContext context) {
    Future<bool?> _showExitDialog(BuildContext context) {
      return showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Exit App'),
          content: Text('Do you want to exit the app?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Yes'),
            ),
          ],
        ),
      );
    }
  }
}

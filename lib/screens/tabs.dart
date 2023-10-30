import 'package:flutter/material.dart';
import 'package:splitbill/screens/home_screen.dart';
import 'package:splitbill/screens/social_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    const List<Widget> widgetOptions = <Widget>[
    HomeScreen(),
    SocialScreen(),
    SocialScreen(),
    SocialScreen(),
    ];

    // if (_selectedIndex == 0) {
    //   activeScreen = const HomeScreen();
    // } else if (_selectedIndex == 1) {
    //   activeScreen = const SocialScreen();
    // } else if (_selectedIndex == 2) {
    //   activeScreen = const HomeScreen();
    // } else if (_selectedIndex == 3) {
    //   activeScreen = const HomeScreen();
    // }

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: widgetOptions,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            border:
                Border(top: BorderSide(color: Color(0xFF333333), width: 1.0))),
        child: BottomNavigationBar(
          // The color of the [BottomNavigationBar] itself.
          backgroundColor: const Color(0xFF121212),
          // The navigation bar's current index. When a bottom navigation icon is tapped, the widget calls onItemSelected with the new index and the widget is rebuilt.
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.groups),
              label: 'Social',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Activity',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: const Color(0xFFFFFFFF),
          selectedFontSize: 12,

          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

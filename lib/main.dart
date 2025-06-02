import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/add_car_screen.dart';
import 'themes/app_theme.dart';

void main() async {
  runApp(CarMarketplaceApp());
}

class CarMarketplaceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Marketplace',
      theme: appTheme,
      home: MainNavigation(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    HomeScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: 'Ogłoszenia'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Obserwowane'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Konto'),
        ],
        onTap: (index) => setState(() => _currentIndex = index),
      ),
      floatingActionButton: _currentIndex == 0
          ? Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddCarScreen()),
            ).then((_) => setState(() {}));
          },
          child: Icon(Icons.add),
        ),
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

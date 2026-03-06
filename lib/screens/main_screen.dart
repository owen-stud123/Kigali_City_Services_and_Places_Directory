import 'package:flutter/material.dart';
import 'directory/directory_screen.dart';
import 'map/map_screen.dart';
import 'profile/settings_screen.dart';
import 'my_listings/my_listings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List of screens for the bottom navigation
  final List<Widget> _screens = [
    const DirectoryScreen(),
    const MyListingsScreen(),
    const MapScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFFACC15), // Yellow indicator
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: 'Directory'),
          NavigationDestination(
            icon: Icon(Icons.person_pin),
            label: 'My Listings',
          ),
          NavigationDestination(icon: Icon(Icons.map), label: 'Map'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

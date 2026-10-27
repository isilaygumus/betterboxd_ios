import 'package:flutter/material.dart';
import "add_review_screen.dart";
import 'home_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentPageIndex = 0;
  final List<Widget> _screens = const [
    HomeScreen(),
    SearchScreen(),
    AddReviewScreen(),
    ProfileScreen(),
  ];


@override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _screens[currentPageIndex],

      // Alt gezinme çubuğu
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.movie_filter_sharp),
            selectedIcon: Icon(Icons.movie),
            label: 'Ana Sayfa',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            selectedIcon: Icon(Icons.search),
            label: 'Arama',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_sharp),
            selectedIcon: Icon(Icons.add_circle),
            label: 'Ekle',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
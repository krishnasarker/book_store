import 'package:flutter/material.dart';
import 'package:book_store/ui/utility/app_color.dart';
import 'package:book_store/ui/screens/app_screen/add_screen.dart';
import 'package:book_store/ui/screens/app_screen/delete_file.dart';
import 'package:book_store/ui/screens/app_screen/home_screen.dart';
import 'package:book_store/ui/screens/app_screen/update_profile_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class MainBottomNavScreen extends StatefulWidget {
  final user;
  const MainBottomNavScreen({super.key,this.user});


  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = const [
    HomeScreen(),
    AddScreen(),
    DeleteFile(),
    ProfileScreen(userId: '',),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        color: AppColors.themeColor,
        backgroundColor: Colors.white,
        items: const [
          Icon(
            Icons.home,
            size: 30,
            color: Colors.white,
          ),
          Icon(Icons.add_circle_outlined, size: 30, color: Colors.white),
          Icon(Icons.folder_delete, size: 30, color: Colors.white),
          Icon(Icons.account_circle, size: 30, color: Colors.white),
        ],
      ),
    );
  }
}

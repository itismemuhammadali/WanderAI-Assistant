// ============================================================================
// SCREEN: Main Shell (Navigation Container)
// FILE: lib/screens/main_shell.dart
// PURPOSE: Root bottom navigation holding Home, Map, AI Chat, and Profile tabs.
//
// 🎓 TEACHER DEFENSE / VIVA QUICK TRICKS:
// 1. TEACHER: "Bottom bar se AI Chat tab hatao!"
//    - OPTION 1: In lib/core/app_config.dart, set:
//        AppConfig.enableAiChat = false;
//    - OPTION 2: In this file, comment out Line 32 and Line 62 below!
//
// 2. TEACHER: "Bottom bar se Map tab hatao!"
//    - Comment out Line 31 and Line 56 below!
//
// 3. TEACHER: "Default tab Map ya Profile open hona chahiye!"
//    - Change Line 24: int _currentIndex = 0;  (0=Home, 1=Map, 2=Chat, 3=Profile)
// ============================================================================

import 'package:flutter/material.dart';
import '../core/app_config.dart';
import 'home_screen.dart';
import 'map_screen.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatefulWidget {
  final int initialTab;
  const MainShell({super.key, this.initialTab = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    // Dynamic screens list based on AppConfig toggles
    final List<Widget> screens = [
      const HomeScreen(),
      const MapScreen(),
      if (AppConfig.enableAiChat) const ChatScreen(),
      const ProfileScreen(),
    ];

    final List<BottomNavigationBarItem> navItems = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        activeIcon: Icon(Icons.home),
        label: 'Home',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.map_outlined),
        activeIcon: Icon(Icons.map),
        label: 'Map',
      ),
      if (AppConfig.enableAiChat)
        const BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          activeIcon: Icon(Icons.chat_bubble),
          label: 'AI Chat',
        ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        activeIcon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];

    // Ensure valid index if items list shrunk
    final safeIndex = _currentIndex >= screens.length ? 0 : _currentIndex;

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: screens[safeIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: safeIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: navItems,
      ),
    );
  }
}

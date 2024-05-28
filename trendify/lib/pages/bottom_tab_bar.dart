import 'package:flutter/material.dart';

class BottomTabBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomTabBar({
    Key? key,
    required this.currentIndex,
    required this.onTap, required Color backgroundColor, required MaterialColor selectedItemColor, required List<BottomNavigationBarItem> items, required MaterialColor unselectedItemColor, required bool showUnselectedLabels, required bool showSelectedLabels,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category),
          label: 'Categories',
        ),
        // Add more tabs as needed
      ],
    );
  }
}

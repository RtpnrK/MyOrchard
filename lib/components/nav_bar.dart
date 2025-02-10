import 'package:flutter/material.dart';
import 'package:myorchard/custom_icons/customIcons.dart';
import 'package:myorchard/pages/activities.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: 
      NavigationBar(destinations: [
        NavigationDestination(
          icon: Icon(CustomIcons.map_marked_alt),
          label: 'Map',
          selectedIcon: Icon(CustomIcons.map_marked_alt),
        ),
        NavigationDestination(
          icon: Icon(CustomIcons.garden),
          label: 'Activities',
          selectedIcon: Icon(CustomIcons.garden),
        ),
      ]),
      body: Activities(),
    );
  }
}
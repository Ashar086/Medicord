import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:brainmri/store/app_store.dart';
import 'package:brainmri/screens/observation/add_observation_screen.dart';
import 'package:brainmri/screens/observation/all_observations_screen.dart';
import 'package:brainmri/screens/profile/organization_screen.dart';


class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _tabs = const [
    AddObservationScreen(),
    AllObservationsScreen(),
    OrganizationScreen(),
  ];

  final List<String> _tabTitles = const [
    'Add Observation',
    'All Observations',
    'Organization',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tabTitles[_selectedIndex]),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('BrAIn MRI'),
            ),
            ListTile(
              title: const Text('Add Observation'),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('All Observations'),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Organization'),
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _tabs[_selectedIndex],
    );
  }
}

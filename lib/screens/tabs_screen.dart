import 'package:flutter/material.dart';
import './graph_screen.dart';
import './training_screen.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;
  List<String> _settings = ["Body weight", "Setting"];

  @override
  void initState() {
    _pages = [
      {
        'page': TrainingScreen(),
        'title': 'Training Volume Tracker',
      },
      {
        'page': GraphScreen(),
        'title': 'Training Volume Tracker',
      },
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pages[_selectedPageIndex]['title'],
        ),
        actions: [
          PopupMenuButton(
            // onSelected: (FilterOptions selectedValue) {
            //   setState(() {
            //     if (selectedValue == FilterOptions.Favorites) {
            //       _showOnlyFavorites = true;
            //     } else {
            //       _showOnlyFavorites = false;
            //     }
            //   });
            // },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (BuildContext context) {
              return _settings.map(
                (String setting) {
                  return PopupMenuItem(child: Text(setting), value: setting);
                },
              ).toList();
            },
          ),
        ],
      ),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        unselectedItemColor: Colors.black26,
        selectedItemColor: Colors.white,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.indigo,
            icon: Icon(Icons.check_box),
            title: Text('Daily Tracker'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.indigo,
            icon: Icon(Icons.insert_chart),
            title: Text('Weekly Tracker'),
          )
        ],
      ),
    );
  }
}

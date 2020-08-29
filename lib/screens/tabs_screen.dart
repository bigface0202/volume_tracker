import 'package:flutter/material.dart';
import 'package:volume_tracker/widgets/setting_dialog.dart';
import 'package:provider/provider.dart';

import '../models/user_info_prov.dart';
import '../models/user_info.dart';
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

  Future<double> showSettingDialog({
    @required BuildContext context,
    TransitionBuilder builder,
    bool useRootNavigator = true,
  }) {
    final Widget dialog = SettingDialog();
    return showDialog(
      context: context,
      useRootNavigator: useRootNavigator,
      builder: (BuildContext context) {
        return builder == null ? dialog : builder(context, dialog);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pages[_selectedPageIndex]['title'],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () async {
              double _bodyWeight = await showSettingDialog(context: context);
              final newUserInfo = UserInfo(
                id: "setting",
                bodyWeight: _bodyWeight,
              );
              Provider.of<UserInfoProv>(context, listen: false)
                  .addUserInfo(newUserInfo);
            },
          )
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

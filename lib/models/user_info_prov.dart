import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import './user_info.dart';
import '../helpers/db_helper.dart';

class UserInfoProv with ChangeNotifier {
  List<UserInfo> _userInfo = [];

  List<UserInfo> get userInfos {
    return [..._userInfo];
  }

  void addUserInfo(UserInfo info) {
    final newInfo = UserInfo(
      id: info.id,
      bodyWeight: info.bodyWeight,
    );
    _userInfo.add(newInfo);
    notifyListeners();
    DBHelper.insert('user_info', {
      'id': info.id,
      'bodyweight': info.bodyWeight,
    });
  }

  Future<void> fetchAndSetUserInfo() async {
    final dataList = await DBHelper.getData('user_info');
    _userInfo = dataList
        .map(
          (item) => UserInfo(
            id: item['id'],
            bodyWeight: item['bodyweight'],
          ),
        )
        .toList();
    notifyListeners();
  }
}

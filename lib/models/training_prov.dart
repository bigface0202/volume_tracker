import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import './training.dart';
import '../helpers/db_helper.dart';

class TrainingProv with ChangeNotifier {
  List<Training> _userTraining = [];

  List<Training> get userTrainings {
    return [..._userTraining];
  }

  List<Training> onedayTrainings(DateTime date) {
    return _userTraining
        .where((usrTg) =>
            DateFormat.yMMMMEEEEd().format(usrTg.date) ==
            DateFormat.yMMMMEEEEd().format(date))
        .toList();
  }

  void addTraining(Training training) {
    final newTraining = Training(
      id: training.id,
      part: training.part,
      weights: training.weights,
      times: training.times,
      volume: training.volume,
      date: training.date,
    );
    _userTraining.add(newTraining);
    notifyListeners();
    DBHelper.insert('user_trainings', {
      'id': training.id,
      'part': training.part,
      'weights': training.weights,
      'times': training.times,
      'volume': training.volume,
      'date': training.date.toString(),
    });
  }

  void removeTraining(String id) {
    final exsistingTrainingIndex =
        _userTraining.indexWhere((tg) => tg.id == id);
    _userTraining.removeAt(exsistingTrainingIndex);
    notifyListeners();
    DBHelper.delete('user_trainings', id);
  }

  Future<void> fetchAndSetTrainings() async {
    final dataList = await DBHelper.getData('user_trainings');
    _userTraining = dataList
        .map(
          (item) => Training(
              id: item['id'],
              part: item['part'],
              weights: item['weights'],
              times: item['times'],
              volume: item['volume'],
              date: DateTime.parse(item['date'])),
        )
        .toList();
    notifyListeners();
  }

  // List<KeyAndTime> get sumSpendTime {
  //   // タイトル毎に使った時間のリスト
  //   List<KeyAndTime> _spentTimeList = [];
  //   // タイトルのリストを作成
  //   List titleList = [];
  //   for (var i = 0; i < _userTraining.length; i++) {
  //     titleList.add(_userTraining[i].title);
  //   }
  //   // 重複するタイトルを削除
  //   titleList = titleList.toSet().toList();
  //   for (var i = 0; i < titleList.length; i++) {
  //     double _sumTime = 0;
  //     for (var j = 0; j < _userTraining.length; j++) {
  //       if (titleList[i] == _userTraining[j].title) {
  //         _sumTime += _userTraining[j].spentTime;
  //       }
  //     }
  //     _spentTimeList.add(KeyAndTime(key: titleList[i], sumTime: _sumTime));
  //   }
  //   // Sort: If you change the order of a and b, you can change ascending and descending.
  //   _spentTimeList.sort((a, b) => b.sumTime.compareTo(a.sumTime));
  //   return _spentTimeList;
  // }
}

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import './training.dart';
import '../helpers/db_helper.dart';

class TrainingProv with ChangeNotifier {
  List<Training> _userTraining = [];

  List<Training> get userTrainings {
    return [..._userTraining];
  }

  List<Training> onedayTrainings(String date) {
    List<Training> dayTgs =
        _userTraining.where((usrTg) => usrTg.date == date).toList();
    return dayTgs;
  }

  Map<String, double> volumeCalc(String date) {
    Map<String, double> partsVolume = {
      "Shoulder": 0,
      "Chest": 0,
      "Biceps": 0,
      "Triceps": 0,
      "Arm": 0,
      "Back": 0,
      "Abdominal": 0,
      "Leg": 0
    };
    List oneTgs = onedayTrainings(date);
    oneTgs.forEach((element) {
      partsVolume.update(element.part, (value) => value + element.volume);
    });
    return partsVolume;
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
      'date': training.date,
    });
  }

  void removeTraining(String id) {
    final exsistingTrainingIndex =
        _userTraining.indexWhere((tg) => tg.id == id);
    _userTraining.removeAt(exsistingTrainingIndex);
    notifyListeners();
    DBHelper.delete('user_trainings', id);
  }

  void removeTrainingByDate(String date) {
    final List<String> exsistingTrainingIds = [];
    // _userTraining.asMap().forEach((index, element) {
    //   if (element.date == date) {
    //     exsistingTrainingIds.add(element.id);
    //   }
    // });
    // exsistingTrainingIndexes.forEach((id) {
    //   _userTraining.removeAt(id);
    // });
    _userTraining.forEach((usrTg) {
      exsistingTrainingIds.add(usrTg.id);
    });
    notifyListeners();
    DBHelper.deleteMultiple('user_trainings', exsistingTrainingIds);
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
              date: item['date']),
        )
        .toList();
    notifyListeners();
  }
}

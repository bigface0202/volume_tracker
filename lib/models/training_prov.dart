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
    // return _userTraining
    List<Training> test =
        _userTraining.where((usrTg) => usrTg.date == date).toList();
    return test;
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

  List<String> get trainingDates {
    List<String> test = [];
    _userTraining.forEach((usrTg) {
      test.add(usrTg.date);
    });
    return test.toSet().toList();
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

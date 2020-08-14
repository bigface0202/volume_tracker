import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import './volume.dart';
import '../helpers/db_helper.dart';

class VolumeProv with ChangeNotifier {
  List<Volume> _userVolume = [];

  List<Volume> get userVolumes {
    return [..._userVolume];
  }

  void addVolume(Volume volume) {
    final newVolume = Volume(
        id: volume.id,
        date: volume.date,
        shoulder: volume.shoulder,
        chest: volume.chest,
        biceps: volume.biceps,
        triceps: volume.triceps,
        arm: volume.arm,
        back: volume.back,
        abdominal: volume.abdominal,
        leg: volume.leg);
    final volumeIndex = _userVolume
        .indexWhere((existedVolume) => existedVolume.date == newVolume.date);
    if (volumeIndex >= 0) {
      String _updateId = _userVolume[volumeIndex].id;
      _userVolume[volumeIndex] = newVolume;
      notifyListeners();
      DBHelper.update(
        'user_volumes',
        _updateId,
        {
          'id': volume.id,
          'date': volume.date,
          'shoulder': volume.shoulder,
          'chest': volume.chest,
          'biceps': volume.biceps,
          'triceps': volume.triceps,
          'arm': volume.arm,
          'back': volume.back,
          'abdominal': volume.abdominal,
          'leg': volume.leg,
        },
      );
    } else {
      _userVolume.add(newVolume);
      notifyListeners();
      DBHelper.insert(
        'user_volumes',
        {
          'id': volume.id,
          'date': volume.date,
          'shoulder': volume.shoulder,
          'chest': volume.chest,
          'biceps': volume.biceps,
          'triceps': volume.triceps,
          'arm': volume.arm,
          'back': volume.back,
          'abdominal': volume.abdominal,
          'leg': volume.leg,
        },
      );
    }
  }

  void removeVolume(String date) {
    final String deleteId =
        _userVolume.where((usrVol) => usrVol.date == date).toList()[0].id;
    final exsistingVolumeIndex =
        _userVolume.indexWhere((vol) => vol.id == deleteId);
    _userVolume.removeAt(exsistingVolumeIndex);
    notifyListeners();
    DBHelper.delete('user_volumes', deleteId);
  }

  Future<void> fetchAndSetVolumes() async {
    final dataList = await DBHelper.getData('user_volumes');
    _userVolume = dataList
        .map(
          (item) => Volume(
              id: item['id'],
              date: item['date'],
              shoulder: item['shoulder'],
              chest: item['chest'],
              biceps: item['biceps'],
              triceps: item['triceps'],
              arm: item['arm'],
              back: item['back'],
              abdominal: item['abdominal'],
              leg: item['leg']),
        )
        .toList();
    notifyListeners();
  }

  Map<String, double> calcPeriodVolume(DateTime sDate, DateTime eDate) {
    int _range = DateTimeRange(start: sDate, end: eDate).duration.inDays + 1;
    Map<String, double> _periodVolume = {
      'shoulder': 0,
      'chest': 0,
      'biceps': 0,
      'triceps': 0,
      'arm': 0,
      'back': 0,
      'abdominal': 0,
      'leg': 0,
    };
    List.generate(
      _range,
      (index) {
        final weekDay =
            DateFormat('yyyy-MM-dd').format(sDate.add(Duration(days: index)));
        for (var i = 0; i < _userVolume.length; i++) {
          if (_userVolume[i].date == weekDay) {
            _periodVolume['shoulder'] += userVolumes[i].shoulder;
            _periodVolume['chest'] += userVolumes[i].chest;
            _periodVolume['biceps'] += userVolumes[i].biceps;
            _periodVolume['triceps'] += userVolumes[i].triceps;
            _periodVolume['arm'] += userVolumes[i].arm;
            _periodVolume['back'] += userVolumes[i].back;
            _periodVolume['abdominal'] += userVolumes[i].abdominal;
            _periodVolume['leg'] += userVolumes[i].leg;
          }
        }
      },
    );
    return _periodVolume;
  }
}

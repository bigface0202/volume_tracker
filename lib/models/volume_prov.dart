import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

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
      print("not existed");
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

  void removeVolume(String id) {
    final exsistingVolumeIndex = _userVolume.indexWhere((vol) => vol.id == id);
    _userVolume.removeAt(exsistingVolumeIndex);
    notifyListeners();
    DBHelper.delete('user_volumes', id);
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
    print(dataList);
  }

  // Future<void> updateVolumes(String date, Volume newVolume) async {
  //   final volumeIndex =
  //       _userVolume.indexWhere((volume) => volume.date == date);
  //   _userVolume[volumeIndex] = newVolume;
  //   if (volumeIndex >= 0){

  //   }
  // }
}

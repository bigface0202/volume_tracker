import 'package:flutter/foundation.dart';

class UserInfo with ChangeNotifier {
  String id;
  String date;
  double bodyWeight;

  UserInfo({
    @required this.id,
    @required this.bodyWeight,
  });
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/training.dart';
import '../models/training_prov.dart';
import '../models/volume.dart';
import '../models/volume_prov.dart';
import '../models/user_info_prov.dart';
import '../widgets/day_training_list.dart';

class NewTrainingScreen extends StatefulWidget {
  static const routeName = '/new-training';
  @override
  _NewTrainingScreenState createState() => _NewTrainingScreenState();
}

class _NewTrainingScreenState extends State<NewTrainingScreen> {
  final _weightsController = TextEditingController();
  final _timesController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _timesForcusNode = FocusNode();
  final _weightFocusNode = FocusNode();
  String _selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String _selectedPart = 'Shoulder';
  double bodyWeight;
  bool _dayChanged = false;
  final List<String> _parts = [
    'Shoulder',
    'Chest',
    'Biceps',
    'Triceps',
    'Arm',
    'Back',
    'Abdominal',
    'Leg'
  ];

  @override
  void initState() {
    // TODO: implement initState
    final _userInfo = Provider.of<UserInfoProv>(context, listen: false);
    bodyWeight = _userInfo.userInfos.length > 0
        ? _userInfo.userInfos[0].bodyWeight
        : 60.0;
    super.initState();
  }

  @override
  void dispose() {
    _weightsController.dispose();
    _timesController.dispose();
    _timesForcusNode.dispose();
    _weightFocusNode.dispose();
    super.dispose();
  }

  _multiplyWeightTimes(String part, double weight, double times) {
    final double armWeight = bodyWeight * 0.05;
    final double upperArmWeight = bodyWeight * 0.03;
    final double handWeight = bodyWeight * 0.01;
    final double upperBodyWeight = bodyWeight * 0.64;
    final double lowerBodyWeight = bodyWeight * 0.34;
    if (weight == 0) {
      switch (part) {
        case 'Shoulder':
          return armWeight * times;
          break;
        case 'Chest':
          return upperBodyWeight * times;
          break;
        case 'Biceps':
          return upperArmWeight * times;
          break;
        case 'Triceps':
          return upperArmWeight * times;
          break;
        case 'Arm':
          return handWeight * times;
          break;
        case 'Back':
          return upperBodyWeight * times;
          break;
        case 'Leg':
          return upperBodyWeight * times;
          break;
        case 'Abdominal':
          return lowerBodyWeight * times;
          break;
      }
    } else {
      return weight * times;
    }
  }

  void _submitData() {
    final enteredPart = _selectedPart;
    final enteredWeights = double.parse(_weightsController.text);
    final enteredTimes = double.parse(_timesController.text);

    if (enteredPart.isEmpty ||
        enteredWeights < 0.0 ||
        enteredTimes < 0 ||
        _selectedDate == null) {
      return;
    }

    final newTg = Training(
      part: enteredPart,
      weights: enteredWeights,
      times: enteredTimes,
      volume: _multiplyWeightTimes(enteredPart, enteredWeights, enteredTimes),
      date: _selectedDate,
      id: DateTime.now().toString(),
    );
    Provider.of<TrainingProv>(context, listen: false).addTraining(newTg);
    final Map calculatedVolume =
        Provider.of<TrainingProv>(context, listen: false)
            .volumeCalc(_selectedDate);
    final newVol = Volume(
      id: DateTime.now().toString(),
      date: _selectedDate,
      shoulder: calculatedVolume["Shoulder"],
      chest: calculatedVolume["Chest"],
      biceps: calculatedVolume["Biceps"],
      triceps: calculatedVolume["Triceps"],
      arm: calculatedVolume["Arm"],
      back: calculatedVolume["Back"],
      abdominal: calculatedVolume["Abdominal"],
      leg: calculatedVolume["Leg"],
    );
    Provider.of<VolumeProv>(context, listen: false).addVolume(newVol);
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.parse(_selectedDate),
      firstDate: DateTime(2020),
      lastDate: DateTime(2021),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _dayChanged = true;
        _selectedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _selectedDate =
        _dayChanged ? _selectedDate : ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "New training",
        ),
      ),
      body: Builder(
        builder: (ctx) => GestureDetector(
          onTap: () {
            _weightFocusNode.unfocus();
            _timesForcusNode.unfocus();
          },
          child: Form(
            key: _form,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  left: 10,
                  right: 10,
                  bottom: MediaQuery.of(context).viewInsets.bottom +
                      10, //Get Keyboard height + 10
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Text(
                                'Chosen date: ',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                '$_selectedDate',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.calendar_today),
                              color: Colors.indigo,
                              onPressed: _presentDatePicker,
                            ),
                            Text('Change date')
                          ],
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          'Choose your training part',
                          style: TextStyle(fontSize: 16),
                        ),
                        DropdownButton<String>(
                          value: _selectedPart,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 30,
                          elevation: 16,
                          style: TextStyle(fontSize: 20, color: Colors.black),
                          underline: Container(
                            height: 2,
                            color: Colors.grey,
                          ),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedPart = newValue;
                            });
                          },
                          items: _parts.map(
                            (String part) {
                              return DropdownMenuItem(
                                value: part,
                                child: Text(part),
                              );
                            },
                          ).toList(),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            SizedBox(
                              height: 80,
                              width: 120,
                              // Weight TextFormField
                              child: TextFormField(
                                style: TextStyle(
                                  fontSize: 24,
                                ),
                                // decoration: InputDecoration(labelStyle: labelstyle),
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                controller: _weightsController,
                                focusNode: _weightFocusNode,
                                decoration: InputDecoration(errorMaxLines: 2),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please fill the field';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Please enter a valid number.';
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (_) => FocusScope.of(context)
                                    .requestFocus(_timesForcusNode),
                              ),
                            ),
                            Text(
                              'Kg.',
                              style: TextStyle(fontSize: 16),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            SizedBox(
                              height: 80,
                              width: 120,
                              child: TextFormField(
                                style: TextStyle(
                                  fontSize: 24,
                                ),
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                controller: _timesController,
                                focusNode: _timesForcusNode,
                                decoration: InputDecoration(errorMaxLines: 2),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please fill the field';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Please enter a valid number.';
                                  }
                                  if (double.parse(value) <= 0) {
                                    return 'Please enter a number greater than zero.';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Text(
                              'Times',
                              style: TextStyle(fontSize: 16),
                            )
                          ],
                        ),
                      ],
                    ),
                    FlatButton(
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        final isValid = _form.currentState.validate();
                        if (!isValid) {
                          return;
                        }
                        Scaffold.of(ctx).showSnackBar(
                          SnackBar(
                            content: Text(
                              '$_selectedPart is done!',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                        _form.currentState.save();
                        _submitData();
                      },
                      color: Colors.indigo,
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    DayTrainingList(_selectedDate),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

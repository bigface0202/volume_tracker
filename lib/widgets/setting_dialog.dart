import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_info_prov.dart';

class SettingDialog extends StatefulWidget {
  @override
  _SettingDialogState createState() => _SettingDialogState();
  final double _userBodyWeight;
  final GlobalKey<FormState> _key;
  SettingDialog(this._userBodyWeight, this._key);
}

class _SettingDialogState extends State<SettingDialog> {
  final _bodyWeightsController = TextEditingController();
  @override
  void dispose() {
    _bodyWeightsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final List<Widget> actions = [
      FlatButton(
        child: Text(localizations.cancelButtonLabel),
        onPressed: () => Navigator.pop<double>(context, widget._userBodyWeight),
      ),
      FlatButton(
        child: Text(localizations.okButtonLabel),
        onPressed: () {
          final isValid = widget._key.currentState.validate();
          if (!isValid) {
            return;
          }
          widget._key.currentState.save();
          double kilograms = double.tryParse(_bodyWeightsController.text);
          Navigator.pop<double>(context, kilograms);
        },
      ),
    ];
    final AlertDialog dialog = AlertDialog(
      title: Text('Your body weight'),
      content: Form(
        key: widget._key,
        child: TextFormField(
          controller: _bodyWeightsController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: '${widget._userBodyWeight} kg',
          ),
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
          autofocus: true,
        ),
      ),
      actions: actions,
    );
    return dialog;
  }
}

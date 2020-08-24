import 'package:flutter/material.dart';

class SettingDialog extends StatefulWidget {
  @override
  _SettingDialogState createState() => _SettingDialogState();
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
        onPressed: () => Navigator.pop(context),
      ),
      FlatButton(
        child: Text(localizations.okButtonLabel),
        onPressed: () {
          double kilograms = double.tryParse(_bodyWeightsController.text);
          Navigator.pop<double>(context, kilograms);
        },
      ),
    ];
    final AlertDialog dialog = AlertDialog(
      title: Text('Your body weight'),
      content: TextFormField(
        controller: _bodyWeightsController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: '60.0 kg',
        ),
        autofocus: true,
      ),
      actions: actions,
    );
    return dialog;
  }
}

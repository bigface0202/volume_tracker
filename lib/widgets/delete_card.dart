import 'package:flutter/material.dart';

class DeleteCard extends StatelessWidget {
  final _valueKey;
  final VoidCallback _deleteFunction;
  final Card _buildCard;

  DeleteCard(this._valueKey, this._deleteFunction, this._buildCard);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(_valueKey),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete, color: Colors.white, size: 40),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to remove this?'),
            actions: [
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              )
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Delete the card',
              textAlign: TextAlign.center,
            ),
          ),
        );
        _deleteFunction();
      },
      child: _buildCard,
    );
  }
}

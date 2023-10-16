import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String deviceId;
  final Function(String) onDelete;

  DeleteConfirmationDialog({required this.deviceId, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confirmation'),
      content: Text('Do you have delete deivice ?'),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Yes'),
          onPressed: () {
            onDelete(deviceId);
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}

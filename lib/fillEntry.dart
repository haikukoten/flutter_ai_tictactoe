import 'package:flutter/material.dart';

class FillEntry extends StatelessWidget {

  final String _entry; 

  FillEntry(this._entry);

  @override
  Widget build(BuildContext context) {
    return Text(
      (_entry == null ? '': _entry.toString()),
      style: TextStyle(
        fontWeight: FontWeight.bold, 
        fontSize: 40,
        color: Colors.green
      ),
    );
  }
}
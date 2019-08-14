import 'package:flutter/material.dart';

class FillEntry extends StatelessWidget {

  final String _entry; 

  final Color _color;

  final bool _shiftTextColor;

  FillEntry(this._color,this._entry,this._shiftTextColor);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      color: _color,
      duration: Duration(seconds: 1),
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      child: Text(
        (_entry == null ? '': _entry.toString()),
        style: TextStyle(
          fontWeight: FontWeight.bold, 
          fontSize: 40,
          color: _shiftTextColor ? Colors.green: Color(0xfffafafa),
        ),
      ),
    );
  }
}
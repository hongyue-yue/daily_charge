import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'dart:convert';

class SelectPicker extends StatefulWidget {
  SelectPicker({
    Key key,
    this.title,
    this.icon,
    this.iconColor,
    this.pickerData,
    this.selectedText,
    this.selectChange,
  }) : super(key: key);
  final String title;
  final String selectedText;
  final Function selectChange;
  final IconData icon;
  final Color iconColor;
  final String pickerData;
  @override
  _SelectPicker createState() => _SelectPicker();
}

class _SelectPicker extends State<SelectPicker> {
  Function _selectChange;
  String _pickerData;
  Color _iconColor;
  void initState() {
    super.initState();
    //初始化状态
    _selectChange = widget.selectChange;
    _iconColor = widget.iconColor;
    _pickerData = widget.pickerData;
  }

  void showClassPicker(BuildContext context) {
    Picker(
        adapter: PickerDataAdapter<String>(
            pickerdata: JsonDecoder().convert(_pickerData)),
        changeToFirst: true,
        hideHeader: true,
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          var arr = picker.adapter.text.split(",");
          List currentTipsTextARR = [
            arr[0].replaceAll(RegExp(r"\[|\]|\s"), ""),
            arr[1].replaceAll(RegExp(r"\[|\]|\s"), "")
          ];
          _selectChange(currentTipsTextARR);
        }).showDialog(context);
  }

  // @override
  // void didUpdateWidget(SelectPicker oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   print("didUpdateWidget");
  // }
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[300])),
        ),
        child: GestureDetector(
          child: Row(children: <Widget>[
            Icon(
              widget.icon,
              //Icons.widgets,
              color: _iconColor,
              size: 18.0,
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Text(
                widget.title,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.0,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Text(
                //'$_currentTipsText',
                widget.selectedText,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17.0,
                ),
              ),
            )
          ]),
          onTap: () {
            showClassPicker(context);
          },
        ));
  }
}

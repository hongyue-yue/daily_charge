import 'package:flutter/material.dart';
import 'package:daily_charge/compenonts/selectPicker.dart';
import 'package:daily_charge/util/common.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'pickerData.dart';

class NewSpend extends StatefulWidget {
  NewSpend({
    Key key,
  }) : super(key: key);
  @override
  _NewSpend createState() => _NewSpend();
}

class _NewSpend extends State<NewSpend> {
  String _classification = "餐饮支出 > 早午晚餐";
  String _account = "现金(CNY)";
  TextEditingController _amountController = TextEditingController();
  TextEditingController _remarkController = TextEditingController();
  var date = new DateTime.now();

  void save() async {
    var spend = {
      "key": date.millisecondsSinceEpoch,
      "category": "spend",
      "amount":
          _amountController.text != null ? _amountController.text : '0.00',
      "classification": _classification,
      "account": _account,
      "remark": _remarkController.text,
      "time": formatDate(date, "yyyy-MM-dd")
    };
    try {
      var res = await storage.writeBill(spend, spend["time"]);
      print(res);
      if (res) {
        Fluttertoast.showToast(
            msg: "保存成功！",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 2,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            TextField(
              controller: _amountController,
              style: TextStyle(color: Colors.tealAccent[400], fontSize: 40.0),
              decoration: InputDecoration(
                hintText: '0.00',
                hintStyle: TextStyle(color: Colors.tealAccent[400]),
                // 未获得焦点下划线颜色
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.tealAccent[400]),
                ),
                //获得焦点下划线颜色
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.tealAccent[400]),
                ),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SelectPicker(
                icon: Icons.widgets,
                iconColor: Colors.pink[200],
                title: "分类",
                selectedText: _classification,
                pickerData: classificationData,
                selectChange: (List val) {
                  setState(() {
                    _classification = val[0] + " > " + val[1];
                  });
                  print(_classification);
                }),
            SelectPicker(
                icon: Icons.credit_card,
                iconColor: Colors.orange[200],
                title: "账户",
                selectedText: _account,
                pickerData: accountData,
                selectChange: (List val) {
                  setState(() {
                    _account = val[1];
                  });
                  print(_account);
                }),
            Container(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[300])),
              ),
              child: Row(children: <Widget>[
                Icon(
                  Icons.assignment,
                  color: Colors.indigo[200],
                  size: 18.0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.0),
                  child: Text(
                    "备注",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Container(
                  width: 200.0,
                  height: 30.0,
                  padding: EdgeInsets.only(top: 0, bottom: 0, left: 15.0),
                  child: TextField(
                    controller: _remarkController,
                    style: TextStyle(color: Colors.black, fontSize: 16.0),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                )
              ]),
            ),
            Row(children: <Widget>[
              Container(
                // width: 150.0,
                // height: 50.0,
                padding: EdgeInsets.all(8.0),
                margin: EdgeInsets.only(top: 10.0, bottom: 20.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(0xFFE6E6E6).withOpacity(0.5)),
                child: Text(
                  '今天${date.month.toString()}月${date.day.toString()}日',
                  //new DateTime.now().toString().split(" ")[0],
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                  ),
                ),
              )
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  color: Colors.amber,
                  textTheme: ButtonTextTheme.primary,
                  padding: EdgeInsets.only(left: 50, right: 50),
                  splashColor: Colors.amber[300],
                  textColor: Colors.white,
                  shape: StadiumBorder(
                    side: BorderSide.none,
                  ),
                  onPressed: () {
                    save();
                  },
                  child: Text('保存', style: TextStyle(fontSize: 16.0)),
                ),
              ],
            )
          ]),
    );
  }
}

class NewIncome extends StatefulWidget {
  NewIncome({
    Key key,
  }) : super(key: key);
  @override
  _NewIncome createState() => _NewIncome();
}

class _NewIncome extends State<NewIncome> {
  String _classification = "餐饮 > 餐饮补助";
  String _account = "现金(CNY)";
  TextEditingController _amountController = TextEditingController();
  TextEditingController _remarkController = TextEditingController();
  var date = new DateTime.now();

  void save() async {
    var spend = {
      "key": date.millisecondsSinceEpoch,
      "category": "income",
      "amount":
          _amountController.text != null ? _amountController.text : '0.00',
      "classification": _classification,
      "account": _account,
      "remark": _remarkController.text,
      "time": formatDate(date, "yyyy-MM-dd")
    };
    try {
      var res = await storage.writeBill(spend, spend["time"]);
      if (res) {
        Fluttertoast.showToast(
            msg: "保存成功！",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 2,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      print(e);
    }
  }

  static final WhitelistingTextInputFormatter digitsOnly =
      WhitelistingTextInputFormatter(RegExp(r'\d+'));
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            TextField(
              controller: _amountController,
              style: TextStyle(color: Colors.red[700], fontSize: 40.0),
              decoration: InputDecoration(
                hintText: '0.00',
                hintStyle: TextStyle(color: Colors.red[700]),
                // 未获得焦点下划线颜色
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red[700]),
                ),
                //获得焦点下划线颜色
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red[700]),
                ),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SelectPicker(
                icon: Icons.widgets,
                iconColor: Colors.pink[200],
                title: "分类",
                selectedText: _classification,
                pickerData: icomeClassification,
                selectChange: (List val) {
                  setState(() {
                    _classification = val[0] + " > " + val[1];
                  });
                  //_classification = val;
                  print(_classification);
                }),
            SelectPicker(
                icon: Icons.credit_card,
                iconColor: Colors.orange[200],
                title: "账户",
                selectedText: _account,
                pickerData: accountData,
                selectChange: (List val) {
                  setState(() {
                    _account = val[1];
                  });
                  print(_account);
                }),
            Container(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[300])),
              ),
              child: Row(children: <Widget>[
                Icon(
                  Icons.assignment,
                  color: Colors.indigo[200],
                  size: 18.0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5.0),
                  child: Text(
                    "备注",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Container(
                  width: 200.0,
                  height: 30.0,
                  padding: EdgeInsets.only(top: 0, bottom: 0, left: 15.0),
                  child: TextField(
                    controller: _remarkController,
                    style: TextStyle(color: Colors.black, fontSize: 16.0),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                )
              ]),
            ),
            Row(children: <Widget>[
              Container(
                // width: 150.0,
                // height: 50.0,
                padding: EdgeInsets.all(8.0),
                margin: EdgeInsets.only(top: 10.0, bottom: 20.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(0xFFE6E6E6).withOpacity(0.5)),
                child: Text(
                  '今天${date.month.toString()}月${date.day.toString()}日',
                  //new DateTime.now().toString().split(" ")[0],
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                  ),
                ),
              )
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  color: Colors.amber,
                  textTheme: ButtonTextTheme.primary,
                  padding: EdgeInsets.only(left: 50, right: 50),
                  textColor: Colors.white,
                  splashColor: Colors.amber[300],
                  shape: StadiumBorder(
                    side: BorderSide.none,
                  ),
                  onPressed: () {
                    save();
                  },
                  child: Text('保存', style: TextStyle(fontSize: 16.0)),
                ),
              ],
            )
          ]),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:daily_charge/util/common.dart';
import 'package:daily_charge/redux/water/water_state.dart';
import 'package:daily_charge/compenonts/DetailCard.dart';

class AccountDetail extends StatefulWidget {
  AccountDetail({Key key, this.title, this.data, this.hiddenPicker})
      : super(key: key);
  final String title;
  final AmountData data;
  final bool hiddenPicker;
  @override
  State<AccountDetail> createState() => new _AccountDetail();
}

class _AccountDetail extends State<AccountDetail>
    with SingleTickerProviderStateMixin {
  var date = new DateTime.now();
  BaseData amountData;
  String title;
  String balance;
  num select = 0;
  List list = [];
  bool hiddenPicker;
  String pickerList = pickerData();
  static String pickerData() {
    var date = new DateTime.now();
    int year = date.year;
    int month = date.month;
    List list = [];
    for (var i = year; i > year - 3; i--) {
      Map map = {i.toString(): []};
      int m = i == year ? month - 1 : 12;
      for (var j = 1; j <= m; j++) {
        map[i.toString()].add(j.toString());
      }
      list.add(map);
    }
    return JsonEncoder().convert(list);
  }

  void initState() {
    super.initState();
    //初始化状态
    var lastMonth = date.add(new Duration(days: -date.day));
    title = '${lastMonth.year.toString()}年${lastMonth.month.toString()}月';
    init(widget.data.amountData);
  }

  void init(BaseData data) {
    amountData = data;
    list = select == 0 ? amountData.spendList : amountData.incomeList;
    balance = (amountData.incomeAmount - amountData.spendAmount > 0
            ? '+'
            : '') +
        (amountData.incomeAmount - amountData.spendAmount).toStringAsFixed(2);
  }

  void showClassPicker(BuildContext context) {
    Picker(
        adapter: PickerDataAdapter<String>(
            pickerdata: JsonDecoder().convert(pickerList)),
        changeToFirst: true,
        hideHeader: false,
        selectedTextStyle: TextStyle(color: Colors.blue, fontSize: 18),
        textStyle: TextStyle(color: Colors.teal[900], fontSize: 16),
        confirmText: "确定",
        cancelText: "取消",
        onConfirm: (Picker picker, List value) {
          var arr = picker.adapter.text.split(",");
          arr = [
            arr[0].replaceAll(RegExp(r"\[|\]|\s"), ""),
            arr[1].replaceAll(RegExp(r"\[|\]|\s"), "")
          ];
          title = '${arr[0]}年${arr[1]}月';

          getData(arr);
        }).showModal(context);
  }

  Future<List> getPathList() async {
    RegExp exp = new RegExp(r"\d+\-\d+\-\d+");
    List pathList = [];
    List list = await storage.getFileList();
    list.forEach((file) {
      Iterable<Match> matches = exp.allMatches(file.path);
      for (Match m in matches) {
        String match = m.group(0);
        pathList.add(match);
      }
    });
    return pathList;
  }

  void getData(List arr) async {
    var data;
    var prefs = await SharedPreferences.getInstance();
    title = '${arr[0]}年${arr[1]}月';
    var monthDataString = prefs.getString('${arr[0]}-${arr[1]}');
    if (monthDataString != null && monthDataString.length > 0) {
      var monthData = JsonDecoder().convert(monthDataString);
      data = BaseData(monthData['spendAmount'], monthData['incomeAmount'],
          monthData['spendList'], monthData['incomeList']);
    } else {
      var monthFristDay = new DateTime(int.parse(arr[0]), int.parse(arr[1]), 1);
      var lastMonthEndDay = monthFristDay.add(new Duration(days: -1));
      var nextMonthFristDay = new DateTime(
          int.parse(arr[1]) == 12 ? int.parse(arr[0]) + 1 : int.parse(arr[0]),
          int.parse(arr[1]) == 12 ? 1 : int.parse(arr[1]) + 1,
          1);
      List monthList = [];
      List spendList = [], incomeList = [];
      double spendAmount = 0.00, incomeAmount = 0.00;
      List pathList = await getPathList();

      for (var i = pathList.length; i > 0; i--) {
        var item = pathList[i - 1];
        if (DateTime.parse(item).isAfter(lastMonthEndDay) &&
            DateTime.parse(item).isBefore(nextMonthFristDay)) {
          List list = await storage.readFile(item);
          if (list.length > 0) {
            monthList.add(list);
          }
        }
      }

      if (monthList.length > 0) {
        monthList.forEach((item) {
          item.forEach((key) {
            if (key["category"] == "spend") {
              spendList.add(key);
              spendAmount += double.parse(key['amount']);
            } else if (key["category"] == "income") {
              incomeList.add(key);
              incomeAmount += double.parse(key['amount']);
            }
          });
        });
        data = BaseData(spendAmount, incomeAmount, spendList, incomeList);
        await prefs.setString(
            '${arr[0]}-${arr[1]}',
            JsonEncoder().convert({
              'spendAmount': spendAmount,
              'incomeAmount': incomeAmount,
              'spendList': spendList,
              'incomeList': incomeList,
            }));
      } else {
        data = BaseData(0.00, 0.00, [], []);
      }
    }
    init(data);
    setState(() {});
  }

  Widget listWater() {
    if (list.length > 0) {
      return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return DetailCard(data: list[index]);
          });
    } else {
      return Container(
        margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.description,
                  color: Colors.limeAccent[100],
                  size: 120.0,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Text(
                    '无记录',
                    style: TextStyle(
                      color: Colors.grey[900],
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Text(
                  '什么都还没有呢，快去添加吧',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14.0,
                  ),
                )
              ],
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      backgroundColor: Colors.grey.shade200,
      body: Column(children: <Widget>[
        Container(
            height: 200.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: EdgeInsets.only(top: 0, bottom: 20.0, left: 30.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      textDirection: TextDirection.rtl,
                      children: <Widget>[
                        Row(children: <Widget>[
                          Text('结余',
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.grey[300]))
                        ]),
                        Row(children: <Widget>[
                          Container(
                              padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                              child: Text(balance,
                                  style: TextStyle(
                                      fontSize: 30.0,
                                      color: (amountData.incomeAmount -
                                                  amountData.spendAmount) >=
                                              0
                                          ? Colors.deepOrange
                                          : Colors.green)))
                        ]),
                        Row(children: <Widget>[
                          Text.rich(
                            TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: "收入",
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.grey[300])),
                              TextSpan(
                                  text: amountData.incomeAmount
                                      .toStringAsFixed(2),
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.white))
                            ]),
                          ),
                          Container(
                              padding: EdgeInsets.only(left: 10.0, right: 10.0),
                              child: Text('|',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.grey[300]))),
                          Text.rich(
                            TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: "支出",
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.grey[300])),
                              TextSpan(
                                  text:
                                      amountData.spendAmount.toStringAsFixed(2),
                                  style: TextStyle(
                                      fontSize: 16.0, color: Colors.white))
                            ]),
                          ),
                        ]),
                      ]),
                ))),
        Container(
          margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: GestureDetector(
                    onTap: () {
                      select = 0;
                      list = amountData.spendList;
                      setState(() {});
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 10.0, right: 10.0),
                      padding: EdgeInsets.only(
                          left: 35.0, right: 35.0, top: 5.0, bottom: 5.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: select == 0 ? Colors.blueAccent : Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Text('支出',
                          style: TextStyle(
                              fontSize: 14.0,
                              color: select == 0
                                  ? Colors.white
                                  : Colors.grey[500])),
                    )),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                    onTap: () {
                      select = 1;
                      list = amountData.incomeList;
                      setState(() {});
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 10.0, right: 10.0),
                      padding: EdgeInsets.only(
                          left: 35.0, right: 35.0, top: 5.0, bottom: 5.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: select == 1 ? Colors.blueAccent : Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Text('收入',
                          style: TextStyle(
                              fontSize: 14.0,
                              color: select == 1
                                  ? Colors.white
                                  : Colors.grey[500])),
                    )),
              ),
              Expanded(
                  flex: 1,
                  child: Offstage(
                    offstage: widget.hiddenPicker,
                    child: GestureDetector(
                        onTap: () {
                          showClassPicker(context);
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Icon(
                                Icons.filter_list,
                                color: Colors.grey[500],
                                size: 20.0,
                              ),
                              Container(
                                  margin:
                                      EdgeInsets.only(left: 5.0, right: 10.0),
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.grey[500]),
                                  ))
                            ])),
                  ))
            ],
          ),
        ),
        Expanded(child: listWater())
      ]),
    );
  }
}

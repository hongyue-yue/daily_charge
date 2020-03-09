import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:daily_charge/util/common.dart';
import 'package:daily_charge/compenonts/AccountWaterCard.dart';
import 'package:daily_charge/view/accountWater/AccountDetail.dart';

import 'package:daily_charge/redux/app_state.dart';
import 'package:daily_charge/redux/water/water_state.dart';
import 'package:daily_charge/redux/water/water_action.dart';

class AccountWater extends StatefulWidget {
  AccountWater({
    Key key,
  }) : super(key: key);
  @override
  AccountWaterState createState() => AccountWaterState();
}

class AccountWaterState extends State<AccountWater> {
  List pathList = [];
  var date = new DateTime.now();

  @override
  void initState() {
    super.initState();
    getWater();
  }

  void getWater() async {
    RegExp exp = new RegExp(r"\d+\-\d+\-\d+");
    List list = await storage.getFileList();
    list.forEach((file) {
      Iterable<Match> matches = exp.allMatches(file.path);
      for (Match m in matches) {
        String match = m.group(0);
        pathList.add(match);
      }
    });
    getTodayData();
    getWeekData();
    getMonthData();
    getLastMonthData();
  }

  void getTodayData() async {
    var store = StoreProvider.of<AppState>(context);
    var todayPath = formatDate(date, "yyyy-MM-dd");
    List list = await storage.readFile(todayPath);

    List spendList = [], incomeList = [];
    double spendAmount = 0.00, incomeAmount = 0.00;
    String dateRange = "${date.month.toString()}月${date.day.toString()}日";
    if (list.length > 0) {
      list.forEach((item) {
        if (item["category"] == "spend") {
          spendList.add(item);
          spendAmount += double.parse(item['amount']);
        } else if (item["category"] == "income") {
          incomeList.add(item);
          incomeAmount += double.parse(item['amount']);
        }
      });
    }
    store.dispatch(TodayDataAction(
        BaseData(spendAmount, incomeAmount, spendList, incomeList), dateRange));
    //setState(() {});
  }

  void getWeekData() async {
    var store = StoreProvider.of<AppState>(context);
    var currWeek = date.weekday;
    var week =
        formatDate(date.add(new Duration(days: -currWeek)), "yyyy-MM-dd");
    var weekDate = DateTime.parse(week);
    String weekRange =
        "${date.add(new Duration(days: -currWeek + 1)).month.toString()}月${date.add(new Duration(days: -currWeek + 1)).day.toString()}日-${date.add(new Duration(days: 7 - currWeek)).month.toString()}月${date.add(new Duration(days: 7 - currWeek)).day.toString()}日";
    List weekList = [];

    List spendList = [], incomeList = [];
    double spendAmount = 0.00, incomeAmount = 0.00;

    for (var i = pathList.length; i > 0; i--) {
      var item = pathList[i - 1];
      if (DateTime.parse(item).isAfter(weekDate)) {
        //weekArr.add(item);
        List list = await storage.readFile(item);
        if (list.length > 0) {
          weekList.add(list);
        }
      } else {
        break;
      }
    }
    weekList.forEach((item) {
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

    store.dispatch(WeekDataAction(
        BaseData(spendAmount, incomeAmount, spendList, incomeList), weekRange));
  }

  void getMonthData() async {
    var store = StoreProvider.of<AppState>(context);
    var currday = date.day;
    var currMonth = date.month;
    var currYear = date.year;
    var monthEndDay;

    var lastMonthEndDay = DateTime.parse(
        formatDate(date.add(new Duration(days: -currday)), "yyyy-MM-dd"));

    var monthStartDay = DateTime.parse(
        "${currYear.toString()}-${currMonth < 10 ? "0" + currMonth.toString() : currMonth.toString()}-01");
    if (currMonth == 12) {
      monthEndDay =
          DateTime.parse("${currYear + 1}-01-01").add(new Duration(days: -1));
    } else {
      monthEndDay = DateTime.parse(
              "${currYear.toString()}-${currMonth < 10 ? "0" + (currMonth + 1).toString() : currMonth.toString()}-01")
          .add(new Duration(days: -1));
    }
    String monthRange =
        '${currMonth.toString()}月${monthStartDay.day.toString()}日-${currMonth.toString()}月${monthEndDay.day.toString()}日';
    List monthList = [];
    List spendList = [], incomeList = [];
    double spendAmount = 0.00, incomeAmount = 0.00;

    for (var i = pathList.length; i > 0; i--) {
      var item = pathList[i - 1];
      if (DateTime.parse(item).isAfter(lastMonthEndDay)) {
        //weekArr.add(item);
        List list = await storage.readFile(item);
        if (list.length > 0) {
          monthList.add(list);
        }
      } else {
        break;
      }
    }
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
    store.dispatch(MonthDataAction(
        BaseData(spendAmount, incomeAmount, spendList, incomeList),
        monthRange));
  }

  void getLastMonthData() async {
    var store = StoreProvider.of<AppState>(context);
    var prefs = await SharedPreferences.getInstance();

    var currday = date.day;
    var lastMonthEndDay = DateTime.parse(
        formatDate(date.add(new Duration(days: -currday)), "yyyy-MM-dd"));
    var lastMonthStartDay = DateTime.parse(
        '${lastMonthEndDay.year.toString()}-${(lastMonthEndDay.month < 10 ? "0" : "") + lastMonthEndDay.month.toString()}-01');
    var comMonthStartDay = lastMonthStartDay.add(new Duration(days: -1));
    var comMonthEndDay = lastMonthEndDay.add(new Duration(days: 1));
    List monthList = [];
    List spendList = [], incomeList = [];
    double spendAmount = 0.00, incomeAmount = 0.00;

    String lastMonthRange =
        '${lastMonthEndDay.month.toString()}月1日-${lastMonthEndDay.month.toString()}月${lastMonthEndDay.day.toString()}日';

    var lastMonthDataString = prefs.getString(
        '${lastMonthEndDay.year.toString()}-${lastMonthEndDay.month.toString()}');

    if (lastMonthDataString != null && lastMonthDataString.length > 0) {
      var lastMonthData = JsonDecoder().convert(lastMonthDataString);
      store.dispatch(LastMonthDataAction(
          BaseData(lastMonthData['spendAmount'], lastMonthData['incomeAmount'],
              lastMonthData['spendList'], lastMonthData['incomeList']),
          lastMonthData['lastMonthRange']));
    } else {
      for (var i = pathList.length; i > 0; i--) {
        var item = pathList[i - 1];
        if (DateTime.parse(item).isAfter(comMonthStartDay) &&
            DateTime.parse(item).isBefore(comMonthEndDay)) {
          //weekArr.add(item);
          List list = await storage.readFile(item);
          if (list.length > 0) {
            monthList.add(list);
          }
        }
      }
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
      store.dispatch(LastMonthDataAction(
          BaseData(spendAmount, incomeAmount, spendList, incomeList),
          lastMonthRange));
      await prefs.setString(
          '${lastMonthEndDay.year.toString()}-${lastMonthEndDay.month.toString()}',
          JsonEncoder().convert({
            'spendAmount': spendAmount,
            'incomeAmount': incomeAmount,
            'spendList': spendList,
            'incomeList': incomeList,
            'lastMonthRange': lastMonthRange
          }));
    }
  }

  turnPage(AmountData amountData, String title) {
    Navigator.push(
        context,
        new MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) {
              return AccountDetail(title: title, data: amountData);
            }));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, appState) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('账单流水'),
            ),
            backgroundColor: Colors.grey.shade200,
            body: Column(children: <Widget>[
              Container(
                  height: 220.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/bg2.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        padding:
                            EdgeInsets.only(top: 0, bottom: 20.0, left: 30.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            textDirection: TextDirection.rtl,
                            children: <Widget>[
                              Row(children: <Widget>[
                                Text.rich(TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: date.month.toString(),
                                      style: TextStyle(
                                          fontSize: 26.0,
                                          color: Colors.lime[400])),
                                  TextSpan(
                                      text: "月-支出",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.grey[300]))
                                ])),
                              ]),
                              Row(children: <Widget>[
                                Container(
                                    padding:
                                        EdgeInsets.only(top: 5.0, bottom: 5.0),
                                    child: Text(
                                        appState
                                            .monthData.amountData.spendAmount
                                            .toStringAsFixed(2),
                                        style: TextStyle(
                                            fontSize: 30.0,
                                            color: Colors.white)))
                              ]),
                              Row(children: <Widget>[
                                Text.rich(TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: "本月收入",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.grey[300])),
                                  TextSpan(
                                      text: appState
                                          .monthData.amountData.incomeAmount
                                          .toStringAsFixed(2),
                                      style: TextStyle(
                                          fontSize: 16.0, color: Colors.white))
                                ])),
                              ]),
                            ]),
                      ))),
              AccountWaterCard(
                title: "今天",
                icon: Icons.date_range,
                iconColor: Colors.lightBlue[400],
                data: appState.todayData.amountData,
                timeRange: appState.todayData.dateRange,
                onTap: () => turnPage(appState.todayData, "今天"),
              ), //'${date.month.toString()}月${date.day.toString()}日');
              AccountWaterCard(
                  title: "本周",
                  icon: Icons.calendar_today,
                  iconColor: Colors.deepOrange[400],
                  data: appState.weekData.amountData,
                  timeRange: appState.weekData.dateRange,
                  onTap: () => turnPage(appState.weekData, "本周")),
              AccountWaterCard(
                  title: "本月",
                  icon: Icons.donut_large,
                  iconColor: Colors.amber[400],
                  data: appState.monthData.amountData,
                  timeRange: appState.monthData.dateRange,
                  onTap: () => turnPage(appState.monthData, "本月")),
              AccountWaterCard(
                  title: "上月",
                  icon: Icons.memory,
                  iconColor: Colors.pink[400],
                  data: appState.lastMonthData.amountData,
                  timeRange: appState.lastMonthData.dateRange,
                  onTap: () => turnPage(appState.lastMonthData, "上月"))
            ]),
          );
        });
  }
}

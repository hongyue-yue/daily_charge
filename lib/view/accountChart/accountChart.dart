import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:daily_charge/util/common.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AccountChart extends StatefulWidget {
  AccountChart({
    Key key,
  }) : super(key: key);

  @override
  State<AccountChart> createState() => new _AccountChart();
}

class _AccountChart extends State<AccountChart> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
                bottom: TabBar(
                    isScrollable: true,
                    labelColor: Colors.lime,
                    unselectedLabelColor: Colors.white,
                    tabs: [
                  Tab(text: "支出"),
                  Tab(text: "收入"),
                ])),
            body: TabBarView(children: [SpendCharts(), IcomeCharts()])));
  }
}

class SpendCharts extends StatefulWidget {
  SpendCharts({
    Key key,
  }) : super(key: key);

  @override
  State<SpendCharts> createState() => new _SpendCharts();
}

class _SpendCharts extends State<SpendCharts> {
  var date = new DateTime.now();
  static List classificationData = ['餐饮支出', '住宿支出', '市内交通'];
  List data;
  Map option = {};

  @override
  initState() {
    super.initState();
    getData();
  }

  getData() async {
    Map<String, double> map = {};
    var prefs = await SharedPreferences.getInstance();
    var currday = date.day;
    var lastMonthEndDay = DateTime.parse(
        formatDate(date.add(new Duration(days: -currday)), "yyyy-MM-dd"));
    var lastMonthDataString = prefs.getString(
        '${lastMonthEndDay.year.toString()}-${lastMonthEndDay.month.toString()}');

    var lastMonthData = JsonDecoder().convert(lastMonthDataString);
    String text =
        "${lastMonthEndDay.year.toString()}年${lastMonthEndDay.month.toString()}月支出项";

    lastMonthData["spendList"].forEach((item) {
      String classification = item["classification"].split(' > ')[0];
      if (map[classification] == null) {
        map[classification] = double.parse(item["amount"]);
      } else {
        map[classification] += double.parse(item["amount"]);
      }
    });

    List<Map> data = [];
    map.keys.forEach((item) {
      data.add({'value': map[item], 'name': item});
    });

    option = {
      'title': {'text': text, 'left': 'center'},
      'tooltip': {'trigger': 'item', 'formatter': '{a} <br/>{b}: {c} ({d}%)'},
      'legend': {
        'bottom': 20,
        'left': 'center',
        'data': classificationData,
      },
      'series': [
        {
          'name': '支出项:',
          'type': 'pie',
          'radius': ['40%', '70%'],
          'label': {
            'normal': {'show': false, 'position': 'center'},
            'emphasis': {
              'show': true,
              'textStyle': {'fontSize': '20', 'fontWeight': 'bold'}
            }
          },
          'labelLine': {
            'normal': {'show': false}
          },
          'data': data
        }
      ]
    };
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      width: 300,
      height: 250,
      child: Echarts(option: JsonEncoder().convert(option)),
    );
  }
}

class IcomeCharts extends StatefulWidget {
  IcomeCharts({
    Key key,
  }) : super(key: key);

  @override
  State<IcomeCharts> createState() => new _IcomeCharts();
}

class _IcomeCharts extends State<IcomeCharts> {
  var date = new DateTime.now();
  static List classificationData = [
    '餐饮',
    '住宿',
    '市内交通费',
    '城际交通费',
    '公杂费',
    '应酬',
    '工作收入',
    '其他收入'
  ];
  List data;
  Map option = {};

  @override
  initState() {
    super.initState();
    getData();
  }

  getData() async {
    Map<String, double> map = {};
    var prefs = await SharedPreferences.getInstance();
    var currday = date.day;
    var lastMonthEndDay = DateTime.parse(
        formatDate(date.add(new Duration(days: -currday)), "yyyy-MM-dd"));
    var lastMonthDataString = prefs.getString(
        '${lastMonthEndDay.year.toString()}-${lastMonthEndDay.month.toString()}');

    var lastMonthData = JsonDecoder().convert(lastMonthDataString);
    String text =
        "${lastMonthEndDay.year.toString()}年${lastMonthEndDay.month.toString()}月收入项";

    lastMonthData["incomeList"].forEach((item) {
      String classification = item["classification"].split(' > ')[0];
      if (map[classification] == null) {
        map[classification] = double.parse(item["amount"]);
      } else {
        map[classification] += double.parse(item["amount"]);
      }
    });

    List<Map> data = [];
    map.keys.forEach((item) {
      data.add({'value': map[item], 'name': item});
    });

    option = {
      'title': {'text': text, 'left': 'center'},
      'tooltip': {'trigger': 'item', 'formatter': '{a} <br/>{b}: {c} ({d}%)'},
      'legend': {
        'bottom': 20,
        'left': 'center',
        'data': classificationData,
      },
      'series': [
        {
          'name': '支出项:',
          'type': 'pie',
          'radius': ['40%', '70%'],
          'label': {
            'normal': {'show': false, 'position': 'center'},
            'emphasis': {
              'show': true,
              'textStyle': {'fontSize': '20', 'fontWeight': 'bold'}
            }
          },
          'labelLine': {
            'normal': {'show': false}
          },
          'data': data
        }
      ]
    };
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      width: 300,
      height: 250,
      child: Echarts(option: JsonEncoder().convert(option)),
    );
  }
}

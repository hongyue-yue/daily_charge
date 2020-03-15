import 'package:flutter/material.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:daily_charge/util/common.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'dart:convert';
import 'package:daily_charge/redux/water/water_state.dart';

class AccountChart extends StatefulWidget {
  AccountChart({
    Key key,
  }) : super(key: key);

  @override
  State<AccountChart> createState() => new _AccountChart();
}

class _AccountChart extends State<AccountChart> {
  static var date = new DateTime.now();

  List selectDate;
  BaseData monthData = BaseData(0.00, 0.00, [], []);
  String pickerList = pickerData();
  static String pickerData() {
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
    var currday = date.day;
    var lastMonth = date.add(new Duration(days: -currday));
    selectDate = [lastMonth.year.toString(), lastMonth.month.toString()];
    getData();
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

  getData() async {
    var prefs = await SharedPreferences.getInstance();
    var monthDataString = prefs.getString('${selectDate[0]}-${selectDate[1]}');
    if (monthDataString != null && monthDataString.length > 0) {
      var data = JsonDecoder().convert(monthDataString);
      monthData = BaseData(data['spendAmount'], data['incomeAmount'],
          data['spendList'], data['incomeList']);
    } else {
      var monthFristDay =
          new DateTime(int.parse(selectDate[0]), int.parse(selectDate[1]), 1);
      var lastMonthEndDay = monthFristDay.add(new Duration(days: -1));
      var nextMonthFristDay = new DateTime(
          int.parse(selectDate[1]) == 12
              ? int.parse(selectDate[0]) + 1
              : int.parse(selectDate[0]),
          int.parse(selectDate[1]) == 12 ? 1 : int.parse(selectDate[1]) + 1,
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
        monthData = BaseData(spendAmount, incomeAmount, spendList, incomeList);
        await prefs.setString(
            '${selectDate[0]}-${selectDate[1]}',
            JsonEncoder().convert({
              'spendAmount': spendAmount,
              'incomeAmount': incomeAmount,
              'spendList': spendList,
              'incomeList': incomeList,
            }));
      } else {
        monthData = BaseData(0.00, 0.00, [], []);
      }
    }
    setState(() {});
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
          selectDate = [
            arr[0].replaceAll(RegExp(r"\[|\]|\s"), ""),
            arr[1].replaceAll(RegExp(r"\[|\]|\s"), "")
          ];
          getData();
        }).showModal(context);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
                title: Text('图表'),
                actions: <Widget>[
                  IconButton(
                    // action button
                    icon: Icon(Icons.filter_list),
                    onPressed: () {
                      showClassPicker(context);
                    },
                  ),
                ],
                bottom: TabBar(
                    isScrollable: true,
                    labelColor: Colors.lime,
                    unselectedLabelColor: Colors.white,
                    tabs: [
                      Tab(text: "支出"),
                      Tab(text: "收入"),
                    ])),
            body: TabBarView(children: [
              SpendCharts(date: selectDate, monthData: monthData),
              IcomeCharts(date: selectDate, monthData: monthData)
            ])));
  }
}

class SpendCharts extends StatefulWidget {
  SpendCharts({
    Key key,
    this.date,
    this.monthData,
  }) : super(key: key);
  final List date;
  final BaseData monthData;
  @override
  State<SpendCharts> createState() => new _SpendCharts();
}

class _SpendCharts extends State<SpendCharts> {
  var date = new DateTime.now();
  static List classificationData = ['餐饮支出', '住宿支出', '市内交通'];

  Map option = {};
  bool chartsHidden = false;
  void initState() {
    super.initState();
    getData();
  }

  @override
  void didUpdateWidget(SpendCharts oldWidget) {
    super.didUpdateWidget(oldWidget);
    getData();
  }

  getData() async {
    Map<String, double> map = {};
    String text = '${widget.date[0]}年${widget.date[1]}月支出项';
    if (widget.monthData.spendList.length > 0) {
      chartsHidden = false;
      widget.monthData.spendList.forEach((item) {
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
    } else {
      chartsHidden = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: !chartsHidden
          ? Echarts(option: JsonEncoder().convert(option))
          : Row(
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

class IcomeCharts extends StatefulWidget {
  IcomeCharts({
    Key key,
    this.date,
    this.monthData,
  }) : super(key: key);
  final List date;
  final BaseData monthData;
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

  Map option = {};
  bool chartsHidden = false;
  void initState() {
    super.initState();
    getData();
  }

  @override
  void didUpdateWidget(IcomeCharts oldWidget) {
    super.didUpdateWidget(oldWidget);
    getData();
  }

  getData() async {
    Map<String, double> map = {};
    String text = '${widget.date[0]}年${widget.date[1]}月收入项';
    if (widget.monthData.spendList.length > 0) {
      chartsHidden = false;
      widget.monthData.incomeList.forEach((item) {
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
    } else {
      chartsHidden = true;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      child: !chartsHidden
          ? Echarts(option: JsonEncoder().convert(option))
          : Row(
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

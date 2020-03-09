import 'package:flutter/material.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:daily_charge/compenonts/navigationIconView.dart';
import "global_config.dart";

import "view/createBill/createBill.dart";
import "view/accountWater/AccountWater.dart";
import "view/accountChart/accountChart.dart";

import "package:daily_charge/redux/store.dart";
import 'package:daily_charge/redux/app_state.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final store = createStore();
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
        store: store,
        child: MaterialApp(
          title: 'Daily Charge',
          theme: GlobalConfig.themeData,
          home: HomePage(),
        ));
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => new _AppState();
}

class _AppState extends State<HomePage> with TickerProviderStateMixin {
  int _currentIndex = 0;
  List<NavigationIconView> _navigationViews;
  List<StatefulWidget> _pageList;
  StatefulWidget _currentPage;

  @override
  void initState() {
    super.initState();
    _navigationViews = <NavigationIconView>[
      new NavigationIconView(
        icon: Icon(Icons.insert_comment),
        title: Text('流水'),
        vsync: this,
      ),
      new NavigationIconView(
        icon: Icon(Icons.create),
        title: Text('记一笔'),
        vsync: this,
      ),
      new NavigationIconView(
        icon: Icon(Icons.insert_chart),
        title: Text('图表'),
        vsync: this,
      ),
    ];
    for (NavigationIconView view in _navigationViews) {
      view.controller.addListener(_rebuild);
    }

    _pageList = <StatefulWidget>[
      AccountWater(),
      CreateBill(),
      AccountChart(),
    ];
    _currentPage = _pageList[_currentIndex];
  }

  void _rebuild() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    for (NavigationIconView view in _navigationViews) {
      view.controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar bottomNavigationBar = new BottomNavigationBar(
        items: _navigationViews
            .map((NavigationIconView navigationIconView) =>
                navigationIconView.item)
            .toList(),
        currentIndex: _currentIndex,
        fixedColor: Colors.blue,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            _navigationViews[_currentIndex].controller.reverse();
            _currentIndex = index;
            _navigationViews[_currentIndex].controller.forward();
            _currentPage = _pageList[_currentIndex];
          });
        });
    return Scaffold(
      body: new Center(
        child: _currentPage,
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

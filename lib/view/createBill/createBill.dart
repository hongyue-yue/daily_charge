import 'package:flutter/material.dart';
import "package:daily_charge/view/createBill/balancePayments.dart";

class CreateBill extends StatefulWidget {
  CreateBill({
    Key key,
  }) : super(key: key);
  @override
  _CreateBill createState() => _CreateBill();
}

class _CreateBill extends State<CreateBill> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
                title: Text('记一笔'),
                bottom: TabBar(
                    isScrollable: true,
                    labelColor: Colors.lime,
                    unselectedLabelColor: Colors.white,
                    tabs: [
                      Tab(text: "支出"),
                      Tab(text: "收入"),
                    ])),
            body: TabBarView(children: [NewSpend(), NewIncome()])));
  }
}

// class Spend extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return NewSpend();
//   }
// }

// class Income extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return NewIncome();
//   }
// }

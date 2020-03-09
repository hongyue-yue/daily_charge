import 'package:flutter/material.dart';
import 'package:daily_charge/redux/water/water_state.dart';
import 'package:daily_charge/compenonts/DetailCard.dart';

class AccountDetail extends StatefulWidget {
  AccountDetail({Key key, this.title, this.data}) : super(key: key);
  final String title;
  final AmountData data;
  @override
  State<AccountDetail> createState() => new _AccountDetail();
}

class _AccountDetail extends State<AccountDetail>
    with SingleTickerProviderStateMixin {
  BaseData amountData;
  String title;
  String balance;
  num select = 0;
  List list = [];
  void initState() {
    super.initState();
    //初始化状态
    amountData = widget.data.amountData;
    title = widget.title;
    list = amountData.spendList;
    balance = (amountData.incomeAmount - amountData.spendAmount > 0
            ? '+'
            : '') +
        (amountData.incomeAmount - amountData.spendAmount).toStringAsFixed(2);
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
                                      fontSize: 30.0, color: Colors.white)))
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
              GestureDetector(
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
                            color:
                                select == 0 ? Colors.white : Colors.grey[500])),
                  )),
              GestureDetector(
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
                            color:
                                select == 1 ? Colors.white : Colors.grey[500])),
                  )),
            ],
          ),
        ),
        Expanded(
            child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return DetailCard(data: list[index]);
                }))
      ]),
    );
  }
}

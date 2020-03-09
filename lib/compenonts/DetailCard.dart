import 'package:flutter/material.dart';

class DetailCard extends StatefulWidget {
  DetailCard({Key key, this.data}) : super(key: key);
  final Map data;
  @override
  DetailCardState createState() => DetailCardState();
}

class DetailCardState extends State<DetailCard> {
  void dispose() {
    super.dispose();
  }

  void simpleDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
              title: Text(
                '账单详情',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              children: <Widget>[
                SimpleDialogOption(
                  child: Row(children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text.rich(
                        TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: "类型：",
                              style: TextStyle(
                                  fontSize: 13.0, color: Colors.black)),
                          TextSpan(
                              text: widget.data['category'] == 'spend'
                                  ? '支出'
                                  : '收入',
                              style:
                                  TextStyle(fontSize: 13.0, color: Colors.grey))
                        ]),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text.rich(
                        TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: "分类：",
                              style: TextStyle(
                                  fontSize: 13.0, color: Colors.black)),
                          TextSpan(
                              text:
                                  widget.data['classification'].split(' > ')[1],
                              style:
                                  TextStyle(fontSize: 13.0, color: Colors.grey))
                        ]),
                      ),
                    )
                  ]),
                ),
                SimpleDialogOption(
                  child: Row(children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Text.rich(
                        TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: "账户：",
                              style: TextStyle(
                                  fontSize: 13.0, color: Colors.black)),
                          TextSpan(
                              text: widget.data['account'],
                              style:
                                  TextStyle(fontSize: 13.0, color: Colors.grey))
                        ]),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text.rich(
                        TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: "金额：",
                              style: TextStyle(
                                  fontSize: 13.0, color: Colors.black)),
                          TextSpan(
                              text: double.parse(widget.data['amount'])
                                  .toStringAsFixed(2),
                              style:
                                  TextStyle(fontSize: 13.0, color: Colors.grey))
                        ]),
                      ),
                    )
                  ]),
                ),
                SimpleDialogOption(
                    child: Row(children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Text.rich(
                      TextSpan(children: <TextSpan>[
                        TextSpan(
                            text: "备注：",
                            style:
                                TextStyle(fontSize: 13.0, color: Colors.black)),
                        TextSpan(
                            text: widget.data['remark'],
                            style:
                                TextStyle(fontSize: 13.0, color: Colors.grey))
                      ]),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text.rich(
                      TextSpan(children: <TextSpan>[
                        TextSpan(
                            text: "时间：",
                            style:
                                TextStyle(fontSize: 13.0, color: Colors.black)),
                        TextSpan(
                            text: widget.data['time'],
                            style:
                                TextStyle(fontSize: 13.0, color: Colors.grey))
                      ]),
                    ),
                  )
                ]))
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          simpleDialog(context);
        },
        child: Container(
            margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 2.0),
            padding:
                EdgeInsets.only(top: 10.0, bottom: 10.0, left: 8.0, right: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            child: Row(children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 2.0, bottom: 2.0),
                          child: Text(
                            widget.data['classification'].split(' > ')[1],
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 2.0, bottom: 2.0),
                          child: Text(
                            widget.data['time'],
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.0,
                            ),
                          ),
                        )
                      ])),
              Expanded(
                  flex: 1,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 2.0, bottom: 2.0),
                          child: Text(
                            (widget.data['category'] == 'spend' ? '-' : '+') +
                                double.parse(widget.data['amount'])
                                    .toStringAsFixed(2),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: widget.data['category'] == 'spend'
                                  ? Colors.green
                                  : Colors.deepOrange,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 2.0, bottom: 2.0),
                          child: Text(
                            widget.data['account'],
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.0,
                            ),
                          ),
                        )
                      ]))
            ])));
  }
}

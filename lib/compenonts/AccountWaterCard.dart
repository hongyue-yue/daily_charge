import 'package:flutter/material.dart';
import 'package:daily_charge/redux/water/water_state.dart';

class AccountWaterCard extends StatefulWidget {
  AccountWaterCard(
      {Key key,
      this.icon,
      this.iconColor,
      this.data,
      this.timeRange,
      this.title,
      this.onTap})
      : super(key: key);
  final IconData icon;
  final Color iconColor;
  final BaseData data;
  final String timeRange;
  final String title;
  final Function onTap;
  @override
  AccountWaterCardState createState() => AccountWaterCardState();
}

class AccountWaterCardState extends State<AccountWaterCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
          margin: EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0),
          padding:
              EdgeInsets.only(top: 10.0, bottom: 10.0, left: 8.0, right: 8.0),
          //height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300],
                offset: Offset(5.0, 5.0),
                blurRadius: 5.0,
                spreadRadius: 5.0,
              )
            ],
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Icon(
                  widget.icon,
                  color: widget.iconColor,
                  size: 30.0,
                ),
              ),
              Expanded(
                  flex: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Text(
                              widget.title,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              widget.data.incomeAmount.toStringAsFixed(2),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.deepOrange,
                                fontSize: 14.0,
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Text(
                              widget.timeRange,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              widget.data.spendAmount.toStringAsFixed(2),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 14.0,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  )),
              Expanded(
                flex: 1,
                child: Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.indigo[200],
                  size: 30.0,
                ),
              ),
            ],
          )),
    );
  }
}

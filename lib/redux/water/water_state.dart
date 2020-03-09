final Map baseData = {
  "spendAmount": 0.00,
  "incomeAmount": 0.00,
  "spendList": [],
  "incomeList": []
};

class BaseData {
  double spendAmount = 0.00;
  double incomeAmount = 0.00;
  List spendList = [];
  List incomeList = [];
  BaseData(
      this.spendAmount, this.incomeAmount, this.spendList, this.incomeList);
  BaseData.fromJson(Map data) {
    this.spendAmount = data['spendAmount'];
    this.incomeAmount = data['incomeAmount'];
    this.spendList = data['spendList'];
    this.incomeList = data['incomeList'];
  }
}

class AmountData {
  BaseData amountData;
  String dateRange;

  AmountData(this.amountData, this.dateRange);

  factory AmountData.initial() {
    return AmountData(BaseData.fromJson(baseData), "");
  }
}

// class WeekData {
//   BaseData weekData;
//   String weekRange;

//   WeekData(this.weekData, this.weekRange);

//   factory WeekData.initial() {
//     return WeekData(BaseData.fromJson(baseData), "");
//   }
// }

// class MonthData {
//   BaseData monthData;
//   String monthRange;

//   MonthData(this.monthData, this.monthRange);

//   factory MonthData.initial() {
//     return MonthData(BaseData.fromJson(baseData), "");
//   }
// }

// class LastMonthData {
//   BaseData lastMonthData;
//   String lastMonthRange;

//   LastMonthData(this.lastMonthData, this.lastMonthRange);

//   factory LastMonthData.initial() {
//     return LastMonthData(BaseData.fromJson(baseData), "");
//   }
// }

import 'water_state.dart';

class TodayDataAction {
  BaseData todayData;
  String todayDate;

  TodayDataAction(this.todayData, this.todayDate);
}

class WeekDataAction {
  BaseData weekData;
  String weekRange;

  WeekDataAction(this.weekData, this.weekRange);
}

class MonthDataAction {
  BaseData monthData;
  String monthRange;

  MonthDataAction(this.monthData, this.monthRange);
}

class LastMonthDataAction {
  BaseData lastMonthData;
  String lastMonthRange;

  LastMonthDataAction(this.lastMonthData, this.lastMonthRange);
}

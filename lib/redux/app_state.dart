import 'package:daily_charge/redux/water/water_state.dart';

class AppState {
  AmountData todayData;
  AmountData weekData;
  AmountData monthData;
  AmountData lastMonthData;

  AppState(this.todayData, this.weekData, this.monthData, this.lastMonthData);

  factory AppState.initial() {
    // 对于存在多个页面State情况，
    // 可以通过AppState(ListState.initial()， ListState2.initial()， ListState3.initial())这样的形式添加
    return AppState(AmountData.initial(), AmountData.initial(),
        AmountData.initial(), AmountData.initial());
  }
}

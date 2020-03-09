import 'water_action.dart';
import 'water_state.dart';

AmountData todayDataReducer(AmountData pre, dynamic action) {
  if (action is TodayDataAction) {
    return AmountData(action.todayData, action.todayDate);
  }
  return pre;
}

AmountData weekDataReducer(AmountData pre, dynamic action) {
  if (action is WeekDataAction) {
    return AmountData(action.weekData, action.weekRange);
  }
  return pre;
}

AmountData monthDataReducer(AmountData pre, dynamic action) {
  if (action is MonthDataAction) {
    return AmountData(action.monthData, action.monthRange);
  }
  return pre;
}

AmountData lastMonthDataReducer(AmountData pre, dynamic action) {
  if (action is LastMonthDataAction) {
    return AmountData(action.lastMonthData, action.lastMonthRange);
  }
  return pre;
}

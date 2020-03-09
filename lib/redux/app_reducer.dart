import 'app_state.dart';
import 'package:daily_charge/redux/water/water_reducer.dart';

AppState appReducer(AppState state, dynamic action) {
  // 对于存在多个页面Reducer情况，
  // 可以通过AppState(listReducer(state.listState, action), listReducer2(state.listState2, action), listReducer3(state.listState3, action))这样的形式添加
  return AppState(
      todayDataReducer(state.todayData, action),
      weekDataReducer(state.weekData, action),
      monthDataReducer(state.monthData, action),
      lastMonthDataReducer(state.lastMonthData, action));
}

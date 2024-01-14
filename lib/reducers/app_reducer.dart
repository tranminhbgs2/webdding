// File: lib/reducers/app_reducer.dart

import 'package:webdding/models/redux/appState.dart';
import 'package:webdding/reducers/customer_reducer.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    customer: customerReducer(state.customer, action),
    // Kết hợp các reducers khác ở đây
  );
}

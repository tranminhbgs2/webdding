// ignore_for_file: file_names

import 'package:webdding/models/user.dart';
import 'package:webdding/reducers/customer_reducer.dart';

class AppState {
  final Customer? customer;

  AppState({this.customer});

  AppState copyWith({Customer? customer}) {
    return AppState(customer: customer ?? this.customer);
  }

  AppState appReducer(AppState state, dynamic  action) {
    return state.copyWith(
      customer: customerReducer(state.customer, action),
    );
  }

  // Thêm các phần khác của trạng thái ứng dụng nếu cần
}

class UpdateCustomerAction {
  final Customer updatedCustomer;

  UpdateCustomerAction(this.updatedCustomer);
}


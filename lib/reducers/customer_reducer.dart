// Import các actions liên quan đến Customer ở đây

import 'package:webdding/models/redux/appState.dart';
import 'package:webdding/models/user.dart';

Customer customerReducer(Customer? customer, action) {
  // Xử lý các actions liên quan đến Customer
  if (customer == null) {
    return Customer(); // Trả về một Customer mặc định hoặc xử lý khác
  }
  // Xử lý các actions
  if (action is UpdateCustomerAction) {
    return action.updatedCustomer;
  }
  return customer;
}

import 'package:get/get.dart';

class User {
  String? accessToken, refreshToken;
  String? fullName, position, lcName, firstName, lastName, department;
  int? id, lcID;

  List<int> focusProducts = [];

  User(Map<String, dynamic> data, {this.accessToken, this.refreshToken}) {
    firstName = (data['first_name'] as String).capitalizeFirst;
    lastName = (data['last_name'] as String).capitalizeFirst;

    fullName = _getFullName(middleName: data['middle_names']);
    position = (data['current_positions'] as List).last['title'];
    lcName = ((data['current_offices'] as List).last['name'] as String).capitalizeFirst;
    id = data['id'];
    lcID = (data['current_offices'] as List).last['id'];

    for (final String prod in (data['current_positions'] as List).last['focus_products']) {
      focusProducts.add(int.parse(prod));
    }
    if (focusProducts.length > 1) {
      department = "OGT";
    } else {
      switch (focusProducts[0]) {
        case 7:
          department = "OGV";
          break;
        case 8:
          department = "OGTa";
          break;
        case 9:
          department = "OGTe";
          break;
      }
    }
  }

  String _getFullName({String? middleName}) {
    return '$firstName ${middleName == null ? lastName?.capitalizeFirst : '${middleName.capitalizeFirst} $lastName'}';
  }
}

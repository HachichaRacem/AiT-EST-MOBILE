import 'package:aiesec_im/controllers/main_controller.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class User {
  String? accessToken, refreshToken;
  String? fullName, position, lcName, firstName, lastName, department;
  int? id, lcID, termID;

  List<int> focusProducts = [];
  List<Map<String, String>> deptMembers = [];

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
    termID = (data['current_positions'] as List).last['term_id'];

    // Fetches user's department members using EXPA
    const String query =
        "query committeeTerm(\$id: ID!, \$termId: ID!) {\n  committeeTerm(id: \$id, term_id: \$termId) {\n    id\n    name\n    committee_departments {\n      total_count\n      edges {\n        node {\n          id\n          name\n          member_positions {\n            facets\n            edges {\n              node {\n                id\n                title\n                person {\n                  id\n                  full_name\n                  profile_photo\n                  last_active_at\n                  __typename\n                }\n                function {\n                  id\n                  name\n                  __typename\n                }\n                reports_to_position_id\n                reports_to {\n                  id\n                  __typename\n                }\n                role {\n                  name\n                  __typename\n                }\n                team_id\n                vp_id\n                __typename\n              }\n              __typename\n            }\n            __typename\n          }\n          permissions {\n            can_archive\n            __typename\n          }\n          __typename\n        }\n        __typename\n      }\n      __typename\n    }\n    member_position {\n      id\n      title\n      function {\n        id\n        name\n        __typename\n      }\n      person {\n        id\n        full_name\n        profile_photo\n        last_active_at\n        __typename\n      }\n      reports_to_position_id\n      role {\n        name\n        __typename\n      }\n      team_id\n      vp_id\n      __typename\n    }\n    __typename\n  }\n}\n";
    MainController.dio
        .post("https://gis-api.aiesec.org/graphql",
            queryParameters: {
              "operationName": "committeeTerm",
              "query": query,
              "variables": {"id": "$lcID", "termId": termID}
            },
            options: Options(headers: {"Authorization": accessToken}))
        .then((value) {
      final List committeeDepartments =
          value.data['data']['committeeTerm']['committee_departments']['edges'];
      final departmentElements = committeeDepartments.firstWhere(
          (element) => element['node']['name'] == department)['node']['member_positions']['edges'];
      for (final Map member in departmentElements) {
        if ((member['node']['person']['full_name'] as String).contains("deleted")) {
          continue;
        }
        deptMembers.add({
          "fullName": member['node']['person']['full_name'],
          "id": member['node']['person']['id'],
          "position": member['node']['title']
        });
      }
    });
  }

  String _getFullName({String? middleName}) {
    return '$firstName ${middleName == null ? lastName?.capitalizeFirst : '${middleName.capitalizeFirst} $lastName'}';
  }
}

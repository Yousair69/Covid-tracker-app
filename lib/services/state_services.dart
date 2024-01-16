import 'dart:convert';

import 'package:covid_tracker_app/models/world_states_model.dart';
import 'package:covid_tracker_app/services/Utils/app_url.dart';
import 'package:http/http.dart' as http;

class StateServices {
  Future<WorldStatesModel> fetchWorldStateRecord() async {
    final response = await http.get(Uri.parse(AppUrl.worldStateApi));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return WorldStatesModel.fromJson(data);
    } else {
      throw Exception('error');
    }
  }

  Future<List<dynamic>> countiresListApi() async {
    var data;
    final response = await http.get(Uri.parse(AppUrl.countriesList));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('error');
    }
  }
}

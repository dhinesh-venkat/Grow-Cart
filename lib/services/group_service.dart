import 'dart:convert';

import 'package:easy_shop/app.dart';
import 'package:http/http.dart' as http;

import '../models/api_response.dart';
import '../models/group.dart';

class GroupService {
  String url = App.BASE_URL + "api/group?&pagenumber=0&pagesize=20";

  Future<APIResponse<List<Group>>> getGroupList() {
    return http.get(url + '/api/group?&pagenumber=0&pagesize=20').then((data) {
      print('Status code : ${data.statusCode}');
      if (data.statusCode == 200) {
        final Iterable jsonData = json.decode(data.body);
        final List<Group> groups =
            jsonData.map((e) => Group.fromJson(e)).toList();

        return APIResponse<List<Group>>(data: groups);
      }
      return APIResponse<List<Group>>(
          error: true, errorMessage: 'An error occured');
    }).catchError((e) {
      print("Error is thrown : "+e.toString());
      return APIResponse<List<Group>>(error: true, errorMessage: 'An error occured');
    });
  }
}

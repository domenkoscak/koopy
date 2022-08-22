import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:koopy/main.dart';
import 'dart:convert';

class HomeController extends GetxController {
  RxBool showItem = true.obs;

  @override
  void onReady() async {
    List lists = await getLists();
    showItem.value = !lists.isEmpty;
  }

  Future getLists() async {
    var storage = GetStorage();
    return await http.get(
      Uri.parse(baseUrl +
          "family/lists/" +
          storage.read("selectedFamily").toString()),
      headers: {"Authorization": "Bearer " + storage.read("token")},
    ).then(
      (value) {
        print(json.decode(value.body));
        return json.decode(value.body);
      },
    );
  }
}
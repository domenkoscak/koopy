import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:koopy/components/functions/login.dart';
import 'package:koopy/components/variables.dart';

Future<String> checkForToken() async {
  final storage = GetStorage();
  if (storage.read('token') != null) {
    await http.get(Uri.parse(baseUrl+"user/1")).then((response) async {
      if (response.statusCode == 401) {
        await login(storage.read('username'), storage.read('password'));
      }
    });
    return storage.read('token');
  } else if (storage.read('username') != null &&
      storage.read('password') != null) {
    await login(storage.read('username'), storage.read('password'));
    return storage.read('token');
  } else {
    return "";
  }
}
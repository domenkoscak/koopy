import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:koopy/components/functions/Fernet.dart';
import 'package:koopy/components/home/Home.dart';
import 'package:koopy/components/register/mail/MailController.dart';
import 'package:koopy/components/register/name/NameController.dart';
import 'package:koopy/components/theme.dart';
import 'package:koopy/components/variables.dart';
import 'package:password_strength/password_strength.dart';

class PasswordController extends GetxController {
  RxMap<String, double> animationOffsets = {
    "title": 500.0,
    "subtitle": 500.0,
    "input": 500.0,
    "input1": 500.0,
    "button": 500.0,
    "signIn": 500.0,
    "strength": 0.0,
  }.obs;
  RxDouble passwordStrength = 0.0.obs;
  RxString passwordStrengthString = "".obs;
  Rx<Color> strengthColor = light.error.obs;
  bool passwordOK = false;
  double strength = 0.0;

  TextEditingController password = TextEditingController();
  TextEditingController repeatedPass = TextEditingController();
  RxString repeatPassword = "".obs;

  Future registerUser() async {
    MailController mc = Get.find();
    NameController nc = Get.find();

    await http
        .post(
      Uri.parse(baseUrl + "user"),
      body: json.encode(
        {
          "mail": mc.mail.text,
          "name": nc.name.text,
          "password": encryptFernet(password.text)
        },
      ),
    )
        .then(
      (response) {
        if (response.statusCode == 201) {
          final storage = GetStorage();
          storage.write('token', json.decode(response.body)["token"]);
        }
      },
    );
  }

  void next() async {
    comparePasswords(repeatedPass.text);
    if (!passwordOK) {
      return;
    }

    await registerUser();

    animationOffsets["button"] = -500.0;
    await Future.delayed(Duration(milliseconds: 100));
    animationOffsets["input1"] = -500.0;
    await Future.delayed(Duration(milliseconds: 50));
    animationOffsets["strength"] = -500.0;
    await Future.delayed(Duration(milliseconds: 50));
    animationOffsets["input"] = -500.0;
    await Future.delayed(Duration(milliseconds: 50));
    animationOffsets["subtitle"] = -500.0;
    await Future.delayed(Duration(milliseconds: 100));
    animationOffsets["title"] = -500.0;
    await Future.delayed(Duration(milliseconds: 200));
    Get.off(() => Home());
  }

  void onChange(String password) {
    strength = estimatePasswordStrength(password);

    double maxWidth = MediaQuery.of(Get.context!).size.width - 44;
    passwordStrength.value = maxWidth * strength;

    if (strength < 0.5) {
      passwordStrengthString.value = "Really!?!";
      strengthColor.value = light.error;
    } else if (strength >= 0.5 && strength < 0.7) {
      passwordStrengthString.value = "I know you can do better!";
      strengthColor.value = light.secondary;
    } else if (strength >= 0.7 && strength < 0.9) {
      passwordStrengthString.value = "Just a little...";
      strengthColor.value = light.tertiary;
    } else {
      passwordStrengthString.value = "Respect.";
      strengthColor.value = light.primary;
    }
  }

  void comparePasswords(String repeat) {
    if (repeat != password.text) {
      repeatPassword.value = "Passwords do not match!";
      passwordOK = false;
    } else if (!password.text.isEmpty) {
      repeatPassword.value = "";
      if (strength >= 0.7) passwordOK = true;
    }
  }

  @override
  void onReady() async {
    animationOffsets["title"] = 0;
    await Future.delayed(Duration(milliseconds: 100));
    animationOffsets["subtitle"] = 0;
    await Future.delayed(Duration(milliseconds: 50));
    animationOffsets["input"] = 0;
    await Future.delayed(Duration(milliseconds: 50));
    animationOffsets["input1"] = 0;
    await Future.delayed(Duration(milliseconds: 100));
    animationOffsets["button"] = 0;

    super.onReady();
  }
}

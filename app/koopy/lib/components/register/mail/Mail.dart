import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:koopy/components/register/mail/MailController.dart';
import 'package:koopy/components/theme.dart';

class Mail extends StatelessWidget {
  const Mail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MailController c = Get.put(MailController());

    return Obx(
      () => Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SizedBox(),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                curve: Curves.easeInOutCubicEmphasized,
                transform: Matrix4.translationValues(c.animationOffsets["title"]!, 0, 0),
                child: Text(
                  "Welcome!",
                  style: title,
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                curve: Curves.easeInOutCubicEmphasized,
                transform: Matrix4.translationValues(c.animationOffsets["subtitle"]!, 0, 0),
                child: Text(
                  "It is good to see you!",
                  style: subtitle,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              AnimatedContainer(
                curve: Curves.easeInOutCubic,
                duration: Duration(milliseconds: 200),
                transform: Matrix4.translationValues(c.animationOffsets["input"]!, 0, 0),
                child: TextField(
                  controller: c.mail,
                  style: TextStyle(color: light.primary),
                  cursorColor: light.primary,
                  onChanged: (value) => c.clearErrors(),
                  decoration: InputDecoration(
                    errorText:
                        c.mailError.value == "" ? null : c.mailError.value,
                    labelText: "E-Mail",
                    labelStyle: TextStyle(color: light.primary),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                curve: Curves.easeInOutCubicEmphasized,
                transform: Matrix4.translationValues(c.animationOffsets["button"]!, 0, 0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () => c.checkMail(),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      minimumSize: Size.fromHeight(50),
                    ),
                    child: Text(
                      "NEXT",
                      style: TextStyle(
                        color: light.background,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                curve: Curves.easeInOutCubic,
                transform:
                    Matrix4.translationValues(c.animationOffsets["signIn"]!, 0, 0),
                child: TextButton(
                  onPressed: () {}, // TODO: next
                  child: Text(
                    "Want to sign in?",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

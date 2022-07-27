import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:koopy/components/home/screen/list/ListController.dart';

class List extends StatelessWidget {
  const List({Key? key, required this.listName}) : super(key: key);
  final String listName;

  @override
  Widget build(BuildContext context) {
    ListController c = Get.put(ListController());

    return Container(
      margin: EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).colorScheme.primary,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Theme.of(Get.context!)
                .colorScheme
                .onBackground
                .withOpacity(0.4),
            blurRadius: 16,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20, left: 25),
            child: Text(
              listName,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Theme.of(Get.context!).colorScheme.background,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            constraints: BoxConstraints(
              minHeight: 50,
              maxHeight: 400,
            ),
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(Get.context!).colorScheme.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Obx(
              () => ListView(
                shrinkWrap: true,
                children: c.list,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

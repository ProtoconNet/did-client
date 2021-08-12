import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wallet/provider/global_variable.dart';
import 'package:wallet/util/logger.dart';

class VCCard extends StatelessWidget {
  VCCard(
      {key,
      required this.name,
      required this.description,
      required this.type,
      required this.icon,
      required this.status})
      : super(key: key);
  final g = Get.put(GlobalVariable());
  final log = Log();

  final String name;
  final String description;
  final String type;
  final IconData icon;
  final String status;

  @override
  Widget build(BuildContext context) {
    log.i("VCCard build");

    return Card(
        margin: EdgeInsets.all(0),
        elevation: 1.0,
        child: Container(
          decoration: BoxDecoration(color: Get.theme.cardColor, borderRadius: BorderRadius.circular(10.0)),
          child: Padding(
              padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 20.0, bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: status == "noVC"
                    ? [
                        Icon(icon, color: Colors.grey),
                        Text(type),
                        SizedBox(height: 10),
                        Text(description),
                        SizedBox(height: 10),
                        TextButton(onPressed: () {}, child: Text(name + ' 추가하기'))
                      ]
                    : [
                        Icon(icon, color: Colors.grey),
                        Text(type),
                        SizedBox(height: 10),
                        SizedBox(height: 10),
                        TextButton(onPressed: () {}, child: Text(name))
                      ],
              )),
        ));
  }
}

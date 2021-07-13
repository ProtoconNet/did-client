import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wallet/providers/global_variable.dart';

class VerifiableCredentialCard extends StatelessWidget {
  VerifiableCredentialCard({Key key, this.icon, this.name, this.status}) : super(key: key);
  final g = Get.put(GlobalVariable());

  final IconData icon;
  final String name;
  final String status;

  @override
  Widget build(BuildContext context) {
    g.log.i("VCCard build");
    return Card(
        margin: EdgeInsets.all(0),
        elevation: 1.0,
        child: Container(
          decoration: BoxDecoration(color: Get.theme.cardColor, borderRadius: BorderRadius.circular(10.0)),
          child: Padding(
            padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 20.0, bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5.0, right: 15.0),
                  child: Icon(icon, color: Colors.grey),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            name,
                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          status == "noVC"
                              ? Text("issue".tr)
                              : (status == "wait" ? CircularProgressIndicator() : Text(' '))
                        ],
                      ),
                    ],
                  ),
                  flex: 3,
                ),
              ],
            ),
          ),
        ));
  }
}

import 'package:doc_truyen_tranh/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: Get.put(HomeController())!..init(),
      builder: (ctl) => Scaffold(
        body: SafeArea(
          child: ListView.builder(
            itemCount: ctl.data.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(ctl.data[index]),
            ),
          ),
        ),
      ),
    );
  }
}

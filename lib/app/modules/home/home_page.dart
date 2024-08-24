import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_maker/app/modules/home/home_controller.dart';
import 'package:pdf_maker/app/modules/home/widget/button_widget.dart';
import 'package:pdf_maker/app/modules/home/widget/loading_button_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Maker'),
      ),
      body: Center(
        child: Column(
          children: [
            Obx(() {
              return controller.isLoading.value
                  ? const LoadingButtonWidget()
                  : ButtonWidget(
                      text: 'Get PDF',
                      onClicked: () {
                        controller.generatePdf();
                      },
                    );
            }),
          ],
        ),
      ),
    );
  }
}

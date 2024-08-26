import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_maker/app/core/helpers/pdf_helper.dart';
import 'package:pdf_maker/app/modules/home/controller.dart';
import 'package:universal_html/html.dart' as html;


class CvPreviewPage extends StatelessWidget {
  final CvController cvController = Get.put( CvController());

   CvPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview CV'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                Uint8List pdfBytes =
                    await CvPdfHelper.generate(cvController.cv.value);

                // Create a Blob and open a new window with the PDF
                final blob = html.Blob([pdfBytes], 'application/pdf');
                final url = html.Url.createObjectUrlFromBlob(blob);
                html.window.open(url, '_blank');
                html.Url.revokeObjectUrl(url);
              },
              child: const Text('Generate PDF'),
            ),
          ],
        ),
      ),
    );
  }
}

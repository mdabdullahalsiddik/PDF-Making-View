import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfViewPage extends StatelessWidget {
  final File pdfFile;

  const PdfViewPage({super.key, required this.pdfFile});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('PDF View'),
        ),
        body: PDFView(
          filePath: pdfFile.path,
        ),
      );
}

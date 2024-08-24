import 'dart:io';
import 'package:open_file/open_file.dart';

class PdfHelper {
  static Future<void> openFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }
}

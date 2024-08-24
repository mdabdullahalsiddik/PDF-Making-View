import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:pdf_maker/app/data/models/invoice.dart';

class PdfInvoicePdfHelper {
  static Future<File> generate(Invoice invoice) async {
    final pdf = pw.Document();

    // Pre-generate the QR code image to use it in the PDF synchronously
    final qrImage = await generateQRCode(invoice);

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          buildHeader(invoice, qrImage),
          pw.SizedBox(height: 20),
          buildTitle(invoice),
          buildInvoice(invoice),
          pw.Divider(),
          buildTotal(invoice),
          pw.SizedBox(height: 20),
        ],
        footer: (context) => buildFooter(invoice),
      ),
    );

    return saveDocument(name: 'invoice.pdf', pdf: pdf);
  }

  static pw.Widget buildHeader(Invoice invoice, qrImage) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text("Supplier Information",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 2),
                  pw.Text(invoice.supplier.name,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 2),
                  pw.Text(invoice.supplier.address),
                  pw.SizedBox(height: 10),
                  pw.Text("Customer Information",
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 2),
                  pw.Text(invoice.customer.name,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 2),
                  pw.Text(invoice.customer.address),
                ],
              ),
              pw.SizedBox(
                width: 100,
                height: 100,
                child: qrImage,
              )
            ],
          ),
        ],
      );

  static pw.Widget buildTitle(Invoice invoice) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('INVOICE',
              style:
                  pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 0.8 * PdfPageFormat.cm),
          pw.Text(invoice.info.description),
          pw.SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static pw.Widget buildInvoice(Invoice invoice) {
    final headers = [
      'Description',
      'Date',
      'Quantity',
      'Unit Price',
      'VAT',
      'Total'
    ];
    final data = invoice.items.map((item) {
      return [
        item.description,
        item.date.toString(),
        '${item.quantity}',
        '\$${item.unitPrice}',
        '${item.vat}%',
        '\$${item.unitPrice * item.quantity}',
      ];
    }).toList();

    return pw.Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.center,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.centerRight,
        5: pw.Alignment.centerRight,
      },
    );
  }

  static pw.Widget buildTotal(Invoice invoice) {
    final total = invoice.items
        .map((item) => item.unitPrice * item.quantity)
        .reduce((item1, item2) => item1 + item2);
    final vat = total * 0.19;

    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.Row(
        children: [
          pw.Spacer(flex: 6),
          pw.Expanded(
            flex: 4,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Total excluding VAT',
                  value: total,
                  unite: true,
                ),
                buildText(
                  title: 'VAT 19%',
                  value: vat,
                  unite: true,
                ),
                pw.Divider(),
                buildText(
                  title: 'Total amount due',
                  titleStyle: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  value: total + vat,
                  unite: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget buildFooter(Invoice invoice) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Divider(),
          pw.SizedBox(height: 2 * PdfPageFormat.mm),
          pw.Text(invoice.supplier.paymentInfo),
        ],
      );

  static Future<pw.Image> generateQRCode(Invoice invoice) async {
    // Combine invoice details into a single string for the QR code
    final qrData = 'Invoice Number: ${invoice.info.number}\n'
        'Date: ${invoice.info.date}\n'
        'Supplier: ${invoice.supplier.name}\n'
        'Customer: ${invoice.customer.name}\n'
        'Description: ${invoice.info.description}\n'
        'Items: ${invoice.items.length}\n'
        'Total: \$${invoice.items.map((item) => item.unitPrice * item.quantity).reduce((item1, item2) => item1 + item2)}\n';

    final qrPainter = QrPainter(
      data: qrData,
      gapless: true,
      version: QrVersions.auto,
    );

    final image = await qrPainter.toImageData(200, format: ImageByteFormat.png);
    final pdfImage = pw.MemoryImage(image!.buffer.asUint8List());

    return pw.Image(pdfImage);
  }

  static pw.Widget buildText({
    required String title,
    required double value,
    double width = double.infinity,
    pw.TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? pw.TextStyle(fontWeight: pw.FontWeight.bold);

    return pw.Container(
      width: width,
      child: pw.Row(
        children: [
          pw.Expanded(child: pw.Text(title, style: style)),
          pw.Text('\$${value.toStringAsFixed(2)}', style: unite ? style : null),
        ],
      ),
    );
  }

  static Future<File> saveDocument({
    required String name,
    required pw.Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);
    return file;
  }
}

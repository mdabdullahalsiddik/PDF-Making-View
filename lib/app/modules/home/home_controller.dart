import 'package:get/get.dart';
import 'package:pdf_maker/app/core/helpers/pdf_invoice_helper.dart';
import 'package:pdf_maker/app/data/models/customer.dart';
import 'package:pdf_maker/app/data/models/invoice.dart';
import 'package:pdf_maker/app/data/models/invoice_info.dart';
import 'package:pdf_maker/app/data/models/invoice_item.dart';
import 'package:pdf_maker/app/data/models/supplier.dart';
import 'package:pdf_maker/app/modules/home/widget/pdf_view.dart';

class HomeController extends GetxController {
   RxBool isLoading = false.obs;
  Future<void> generatePdf() async {
    final invoice = createSampleInvoice();
   

    try {
      isLoading.value = true;
      final pdfFile = await PdfInvoicePdfHelper.generate(invoice);
      isLoading.value = false;

      Get.to(() => PdfViewPage(pdfFile: pdfFile));
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to generate PDF: $e');
    }
  }

  Invoice createSampleInvoice() {
    final date = DateTime.now();
    final dueDate = date.add(const Duration(days: 7));

    return Invoice(
      supplier: const Supplier(
        name: 'Md. Abdullah Al Siddik',
        address: 'Dhaka, Bangladesh',
        paymentInfo: 'Thank you for your payment!',
      ),
      customer: const Customer(
        name: 'Jane Doe',
        address: 'Mountain View, California, United States',
      ),
      info: InvoiceInfo(
        date: date,
        dueDate: dueDate,
        description: 'Payment Invoice',
        number: '${DateTime.now().year}-9999',
      ),
      items: [
        InvoiceItem(
            description: 'Coffee',
            date: date,
            quantity: 3,
            vat: 0.19,
            unitPrice: 5.99),
        InvoiceItem(
            description: 'Water',
            date: date,
            quantity: 8,
            vat: 0.19,
            unitPrice: 0.99),
       
      ],
    );
  }
}

import 'package:pdf_maker/app/data/models/customer.dart';
import 'package:pdf_maker/app/data/models/invoice_info.dart';
import 'package:pdf_maker/app/data/models/invoice_item.dart';

import 'package:pdf_maker/app/data/models/supplier.dart';

class Invoice {
  final Supplier supplier;
  final Customer customer;
  final InvoiceInfo info;
  final List<InvoiceItem> items;

  Invoice({
    required this.supplier,
    required this.customer,
    required this.info,
    required this.items,
  });
}

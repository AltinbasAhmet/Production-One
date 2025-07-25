import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/stock_log.dart';

Future<void> generateStockReportPdf() async {
  final pdf = pw.Document();
  final box = Hive.box<StockLog>('stock_logs');
  final logs = box.values.toList().reversed.toList();

  pdf.addPage(
    pw.MultiPage(
      build: (pw.Context context) => [
        pw.Text('Stok Raporu', style: pw.TextStyle(fontSize: 24)),
        pw.SizedBox(height: 20),
        pw.Table.fromTextArray(
          headers: ['Tür', 'Değişim', 'Yeni Stok', 'Zaman'],
          data: logs.map((log) => [
            log.type,
            log.change.toString(),
            log.newStock.toString(),
            DateFormat('dd.MM.yyyy HH:mm').format(log.timestamp),
          ]).toList(),
        ),
      ],
    ),
  );

  await Printing.layoutPdf(onLayout: (format) => pdf.save());
}

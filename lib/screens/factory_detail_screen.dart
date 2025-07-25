import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:storage_sisecam/models/stock_log.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:storage_sisecam/services/stock_data.dart';


class FactoryDetailScreen extends StatefulWidget {
  final String factoryName;

  const FactoryDetailScreen({Key? key, required this.factoryName}) : super(key: key);

  @override
  State<FactoryDetailScreen> createState() => _FactoryDetailScreenState();
}

class _FactoryDetailScreenState extends State<FactoryDetailScreen> {
  late Box<StockData> stockBox;
  int rawMaterialStock = 50;
  int productStock = 30;

  List<int> rawMaterialHistory = [40, 42, 45, 48, 49, 50, 50, 51, 52, 50];
  List<int> productStockHistory = [20, 25, 27, 28, 29, 30, 30, 32, 33, 30];

@override
void initState() {
  super.initState();
  stockBox = Hive.box<StockData>('stock_data');

  final data = stockBox.get(widget.factoryName);
  if (data != null) {
    setState(() {
      rawMaterialStock = data.rawMaterialStock;
      productStock = data.productStock;
      rawMaterialHistory = List<int>.from(data.rawMaterialHistory);
      productStockHistory = List<int>.from(data.productStockHistory);
    });
  } else {
    setState(() {
      rawMaterialStock = 50;
      productStock = 30;
      rawMaterialHistory = [50];
      productStockHistory = [30];
    });
  }
}

void saveData() {
  final stockData = StockData()
    ..rawMaterialStock = rawMaterialStock
    ..productStock = productStock
    ..rawMaterialHistory = List<int>.from(rawMaterialHistory)
    ..productStockHistory = List<int>.from(productStockHistory);

  stockBox.put(widget.factoryName, stockData);
}

  
  
  void updateStock({required bool isRaw, required int amount}) async {
    setState(() {
      if (isRaw) {
        rawMaterialStock += amount;
        rawMaterialHistory.add(rawMaterialStock);
        if (rawMaterialHistory.length > 10) rawMaterialHistory.removeAt(0);
      } else {
        productStock += amount;
        productStockHistory.add(productStock);
        if (productStockHistory.length > 10) productStockHistory.removeAt(0);
      }
      saveData();
    });

    final log = StockLog()
      ..type = isRaw ? 'Hammadde' : 'Ürün'
      ..change = amount
      ..newStock = isRaw ? rawMaterialStock : productStock
      ..timestamp = DateTime.now();

    final box = Hive.box<StockLog>('stock_logs');
    await box.add(log);
  }

  void showStockInputDialog({required bool increase}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stok Türü Seçin'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<bool>(
              title: const Text('Hammadde'),
              value: true,
              groupValue: null,
              onChanged: (value) {
                Navigator.pop(context);
                showAmountDialog(isRaw: true, increase: increase);
              },
            ),
            RadioListTile<bool>(
              title: const Text('Ürün'),
              value: false,
              groupValue: null,
              onChanged: (value) {
                Navigator.pop(context);
                showAmountDialog(isRaw: false, increase: increase);
              },
            ),
          ],
        ),
      ),
    );
  }

  void showAmountDialog({required bool isRaw, required bool increase}) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${isRaw ? 'Hammadde' : 'Ürün'} için ${increase ? 'Ekleme' : 'Azaltma'}'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Miktar',
            hintText: 'Örn: 5',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              final input = controller.text.trim();
              final int? amount = int.tryParse(input);

              if (amount != null && amount > 0) {
                updateStock(
                  isRaw: isRaw,
                  amount: increase ? amount : -amount,
                );
              }
              Navigator.pop(context);
            },
            child: const Text('Onayla'),
          ),
        ],
      ),
    );
  }

  void generatePdfReport() async {
    final box = Hive.box<StockLog>('stock_logs');
    final logs = box.values.toList();

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Stok Geçmiş Raporu', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 16),
              ...logs.map((log) => pw.Text(
                '${log.type} | ${log.change > 0 ? '+' : ''}${log.change} → ${log.newStock} | ${DateFormat('dd/MM/yyyy HH:mm').format(log.timestamp)}'
              )),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  Widget buildStockCard(String title, int stock) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Stok: $stock', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget buildLineChart(List<int> values, Color color) {
    return SizedBox(
      height: 180,
      child: LineChart(
        LineChartData(
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: values.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.toDouble())).toList(),
              isCurved: true,
              color: color,
              barWidth: 3,
              dotData: FlDotData(show: false),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.factoryName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: generatePdfReport,
            tooltip: 'PDF Raporu',
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: buildStockCard('Hammadde', rawMaterialStock)),
                const SizedBox(width: 16),
                Expanded(child: buildStockCard('Ürün', productStock)),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Son 10 Hammadde Stok Takibi'),
            buildLineChart(rawMaterialHistory, Colors.blue),
            const SizedBox(height: 16),
            const Text('Son 10 Ürün Stok Takibi'),
            buildLineChart(productStockHistory, Colors.orange),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => showStockInputDialog(increase: true),
                  icon: const Icon(Icons.add),
                  label: const Text('Stok Ekle'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
                ElevatedButton.icon(
                  onPressed: () => showStockInputDialog(increase: false),
                  icon: const Icon(Icons.remove),
                  label: const Text('Stok Azalt'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

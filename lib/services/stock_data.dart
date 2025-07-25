// lib/models/stock_data.dart

import 'package:hive/hive.dart';

part 'stock_data.g.dart';

@HiveType(typeId: 1)
class StockData extends HiveObject {
  @HiveField(0)
  late int rawMaterialStock;

  @HiveField(1)
  late int productStock;

  @HiveField(2)
  late List<int> rawMaterialHistory;

  @HiveField(3)
  late List<int> productStockHistory;
}

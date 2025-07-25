import 'package:hive/hive.dart';

part 'stock_log.g.dart';

// Bu dosya build_runner ile otomatik oluşur

@HiveType(typeId: 0)
class StockLog extends HiveObject {
  @HiveField(0)
  late String type; // "hammadde" veya "urun"
  
  @HiveField(1)
  late int change; // +5, -3 gibi değişim
  
  @HiveField(2)
  late int newStock; // Yeni stok değeri
  
  @HiveField(3)
  late DateTime timestamp; // Zaman damgası
}

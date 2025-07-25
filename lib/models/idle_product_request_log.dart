// lib/models/idle_product_request_log.dart

import 'package:hive/hive.dart';

part 'idle_product_request_log.g.dart';

@HiveType(typeId: 5)
class IdleProductRequestLog extends HiveObject {
  @HiveField(0)
  String productCode;

  @HiveField(1)
  String productName;

  @HiveField(2)
  int quantity;

  @HiveField(3)
  String requestedBy;

  @HiveField(4)
  String requestedFactory;

  @HiveField(5)
  DateTime requestDate;

  IdleProductRequestLog({
    required this.productCode,
    required this.productName,
    required this.quantity,
    required this.requestedBy,
    required this.requestedFactory,
    required this.requestDate,
  });
}

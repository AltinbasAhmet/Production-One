// lib/models/idle_product_request.dart

import 'package:hive/hive.dart';

part 'idle_product_request.g.dart';

@HiveType(typeId: 6)
class IdleProductRequest extends HiveObject {
  @HiveField(0)
  String productCode;

  @HiveField(1)
  String productName;

  @HiveField(2)
  int quantity;

  @HiveField(3)
  String requesterFactory;

  @HiveField(4)
  DateTime requestDate;

  IdleProductRequest({
    required this.productCode,
    required this.productName,
    required this.quantity,
    required this.requesterFactory,
    required this.requestDate,
  });
}

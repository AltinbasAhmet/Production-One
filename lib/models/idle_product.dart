// lib/models/idle_product.dart

import 'dart:typed_data';
import 'package:hive/hive.dart';

part 'idle_product.g.dart';

@HiveType(typeId: 4)
class IdleProduct extends HiveObject {
  @HiveField(0)
  String code;

  @HiveField(1)
  String name;

  @HiveField(2)
  String description;

  @HiveField(3)
  String factory;

  @HiveField(4)
  DateTime addedDate;

  @HiveField(5)
  DateTime expirationDate;

  @HiveField(6)
  Uint8List? imageBytes; // Fotoğraf için

  @HiveField(7)
  Uint8List? pdfBytes; // PDF raporu için

  @HiveField(8)
  int? stockQuantity; // Stok adedi

  IdleProduct({
    required this.code,
    required this.name,
    required this.description,
    required this.factory,
    required this.addedDate,
    required this.expirationDate,
    this.imageBytes,
    this.pdfBytes,
    required this.stockQuantity,
  });

  IdleProduct copyWith({
    String? code,
    String? name,
    String? description,
    String? factory,
    DateTime? addedDate,
    DateTime? expirationDate,
    Uint8List? imageBytes,
    Uint8List? pdfBytes,
    int? stockQuantity,
  }) {
    return IdleProduct(
      code: code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
      factory: factory ?? this.factory,
      addedDate: addedDate ?? this.addedDate,
      expirationDate: expirationDate ?? this.expirationDate,
      imageBytes: imageBytes ?? this.imageBytes,
      pdfBytes: pdfBytes ?? this.pdfBytes,
      stockQuantity: stockQuantity ?? this.stockQuantity,
    );
  }
}

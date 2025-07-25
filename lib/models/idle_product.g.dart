// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'idle_product.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IdleProductAdapter extends TypeAdapter<IdleProduct> {
  @override
  final int typeId = 4;

  @override
  IdleProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IdleProduct(
      code: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      factory: fields[3] as String,
      addedDate: fields[4] as DateTime,
      expirationDate: fields[5] as DateTime,
      imageBytes: fields[6] as Uint8List?,
      pdfBytes: fields[7] as Uint8List?,
      stockQuantity: fields[8] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, IdleProduct obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.factory)
      ..writeByte(4)
      ..write(obj.addedDate)
      ..writeByte(5)
      ..write(obj.expirationDate)
      ..writeByte(6)
      ..write(obj.imageBytes)
      ..writeByte(7)
      ..write(obj.pdfBytes)
      ..writeByte(8)
      ..write(obj.stockQuantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IdleProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

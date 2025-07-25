// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'idle_product_request.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IdleProductRequestAdapter extends TypeAdapter<IdleProductRequest> {
  @override
  final int typeId = 6;

  @override
  IdleProductRequest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IdleProductRequest(
      productCode: fields[0] as String,
      productName: fields[1] as String,
      quantity: fields[2] as int,
      requesterFactory: fields[3] as String,
      requestDate: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, IdleProductRequest obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.productCode)
      ..writeByte(1)
      ..write(obj.productName)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.requesterFactory)
      ..writeByte(4)
      ..write(obj.requestDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IdleProductRequestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

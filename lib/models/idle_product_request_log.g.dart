// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'idle_product_request_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IdleProductRequestLogAdapter extends TypeAdapter<IdleProductRequestLog> {
  @override
  final int typeId = 5;

  @override
  IdleProductRequestLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IdleProductRequestLog(
      productCode: fields[0] as String,
      productName: fields[1] as String,
      quantity: fields[2] as int,
      requestedBy: fields[3] as String,
      requestedFactory: fields[4] as String,
      requestDate: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, IdleProductRequestLog obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.productCode)
      ..writeByte(1)
      ..write(obj.productName)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.requestedBy)
      ..writeByte(4)
      ..write(obj.requestedFactory)
      ..writeByte(5)
      ..write(obj.requestDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IdleProductRequestLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

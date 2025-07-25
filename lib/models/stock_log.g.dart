// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StockLogAdapter extends TypeAdapter<StockLog> {
  @override
  final int typeId = 0;

  @override
  StockLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StockLog()
      ..type = fields[0] as String
      ..change = fields[1] as int
      ..newStock = fields[2] as int
      ..timestamp = fields[3] as DateTime;
  }

  @override
  void write(BinaryWriter writer, StockLog obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.change)
      ..writeByte(2)
      ..write(obj.newStock)
      ..writeByte(3)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

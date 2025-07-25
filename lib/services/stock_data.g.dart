// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StockDataAdapter extends TypeAdapter<StockData> {
  @override
  final int typeId = 1;

  @override
  StockData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StockData()
      ..rawMaterialStock = fields[0] as int
      ..productStock = fields[1] as int
      ..rawMaterialHistory = (fields[2] as List).cast<int>()
      ..productStockHistory = (fields[3] as List).cast<int>();
  }

  @override
  void write(BinaryWriter writer, StockData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.rawMaterialStock)
      ..writeByte(1)
      ..write(obj.productStock)
      ..writeByte(2)
      ..write(obj.rawMaterialHistory)
      ..writeByte(3)
      ..write(obj.productStockHistory);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StockDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

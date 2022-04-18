// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CounterModelAdapter extends TypeAdapter<CounterModel> {
  @override
  final int typeId = 0;

  @override
  CounterModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CounterModel(
      id: fields[0] as String,
      count: fields[1] as int,
      bookTitles: (fields[2] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, CounterModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.count)
      ..writeByte(2)
      ..write(obj.bookTitles);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CounterModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

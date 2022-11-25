// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_feed_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PostsFeedEntityAdapter extends TypeAdapter<PostsFeedEntity> {
  @override
  final int typeId = 2;

  @override
  PostsFeedEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PostsFeedEntity(
      data: fields[0] as PostsFeedData,
      kind: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PostsFeedEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.data)
      ..writeByte(1)
      ..write(obj.kind);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostsFeedEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PostsFeedDataAdapter extends TypeAdapter<PostsFeedData> {
  @override
  final int typeId = 3;

  @override
  PostsFeedData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PostsFeedData(
      modhash: fields[0] as dynamic,
      children: (fields[1] as List)?.cast<PostsFeedDataChild>(),
      before: fields[2] as String,
      dist: fields[3] as int,
      after: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PostsFeedData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.modhash)
      ..writeByte(1)
      ..write(obj.children)
      ..writeByte(2)
      ..write(obj.before)
      ..writeByte(3)
      ..write(obj.dist)
      ..writeByte(4)
      ..write(obj.after);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostsFeedDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PostsFeedDataChildAdapter extends TypeAdapter<PostsFeedDataChild> {
  @override
  final int typeId = 4;

  @override
  PostsFeedDataChild read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PostsFeedDataChild(
      data: fields[0] as PostsFeedDataChildrenData,
      kind: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PostsFeedDataChild obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.data)
      ..writeByte(1)
      ..write(obj.kind);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostsFeedDataChildAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

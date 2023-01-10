// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_provider.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubredditInfoAdapter extends TypeAdapter<SubredditInfo> {
  @override
  final int typeId = 1;

  @override
  SubredditInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubredditInfo(
      name: fields[0] as String?,
      postsFeed: fields[1] as PostsFeedEntity?,
      subredditInformation: fields[2] as SubredditInformationEntity?,
    );
  }

  @override
  void write(BinaryWriter writer, SubredditInfo obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.postsFeed)
      ..writeByte(2)
      ..write(obj.subredditInformation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubredditInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

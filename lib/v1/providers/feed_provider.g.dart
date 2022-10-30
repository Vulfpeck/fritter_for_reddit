// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_provider.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubredditInfoAdapter extends TypeAdapter<SubredditInfo> {
  @override
  final typeId = 1;

  @override
  SubredditInfo read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubredditInfo(
      name: fields[0] as String,
      postsFeed: fields[1] as PostsFeedEntity,
      subredditInformation: SubredditInformationEntity.fromJson(fields[2]),
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
      ..write(obj.subredditInformation?.toJson());
  }
}

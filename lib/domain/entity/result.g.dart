// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ResultImpl _$$ResultImplFromJson(Map<String, dynamic> json) => _$ResultImpl(
      id: (json['id'] as num?)?.toInt(),
      playerId: (json['playerId'] as num).toInt(),
      sessionId: (json['sessionId'] as num).toInt(),
      score: (json['score'] as num).toInt(),
      rank: (json['rank'] as num).toInt(),
    );

Map<String, dynamic> _$$ResultImplToJson(_$ResultImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'playerId': instance.playerId,
      'sessionId': instance.sessionId,
      'score': instance.score,
      'rank': instance.rank,
    };

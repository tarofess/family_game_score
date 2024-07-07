// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'result_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ResultHistory {
  Player get player => throw _privateConstructorUsedError;
  Session get session => throw _privateConstructorUsedError;
  Result get result => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ResultHistoryCopyWith<ResultHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResultHistoryCopyWith<$Res> {
  factory $ResultHistoryCopyWith(
          ResultHistory value, $Res Function(ResultHistory) then) =
      _$ResultHistoryCopyWithImpl<$Res, ResultHistory>;
  @useResult
  $Res call({Player player, Session session, Result result});

  $PlayerCopyWith<$Res> get player;
  $SessionCopyWith<$Res> get session;
  $ResultCopyWith<$Res> get result;
}

/// @nodoc
class _$ResultHistoryCopyWithImpl<$Res, $Val extends ResultHistory>
    implements $ResultHistoryCopyWith<$Res> {
  _$ResultHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? player = null,
    Object? session = null,
    Object? result = null,
  }) {
    return _then(_value.copyWith(
      player: null == player
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as Player,
      session: null == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as Session,
      result: null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as Result,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PlayerCopyWith<$Res> get player {
    return $PlayerCopyWith<$Res>(_value.player, (value) {
      return _then(_value.copyWith(player: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $SessionCopyWith<$Res> get session {
    return $SessionCopyWith<$Res>(_value.session, (value) {
      return _then(_value.copyWith(session: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ResultCopyWith<$Res> get result {
    return $ResultCopyWith<$Res>(_value.result, (value) {
      return _then(_value.copyWith(result: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ResultHistoryImplCopyWith<$Res>
    implements $ResultHistoryCopyWith<$Res> {
  factory _$$ResultHistoryImplCopyWith(
          _$ResultHistoryImpl value, $Res Function(_$ResultHistoryImpl) then) =
      __$$ResultHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Player player, Session session, Result result});

  @override
  $PlayerCopyWith<$Res> get player;
  @override
  $SessionCopyWith<$Res> get session;
  @override
  $ResultCopyWith<$Res> get result;
}

/// @nodoc
class __$$ResultHistoryImplCopyWithImpl<$Res>
    extends _$ResultHistoryCopyWithImpl<$Res, _$ResultHistoryImpl>
    implements _$$ResultHistoryImplCopyWith<$Res> {
  __$$ResultHistoryImplCopyWithImpl(
      _$ResultHistoryImpl _value, $Res Function(_$ResultHistoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? player = null,
    Object? session = null,
    Object? result = null,
  }) {
    return _then(_$ResultHistoryImpl(
      player: null == player
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as Player,
      session: null == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as Session,
      result: null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as Result,
    ));
  }
}

/// @nodoc

class _$ResultHistoryImpl implements _ResultHistory {
  const _$ResultHistoryImpl(
      {required this.player, required this.session, required this.result});

  @override
  final Player player;
  @override
  final Session session;
  @override
  final Result result;

  @override
  String toString() {
    return 'ResultHistory(player: $player, session: $session, result: $result)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResultHistoryImpl &&
            (identical(other.player, player) || other.player == player) &&
            (identical(other.session, session) || other.session == session) &&
            (identical(other.result, result) || other.result == result));
  }

  @override
  int get hashCode => Object.hash(runtimeType, player, session, result);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ResultHistoryImplCopyWith<_$ResultHistoryImpl> get copyWith =>
      __$$ResultHistoryImplCopyWithImpl<_$ResultHistoryImpl>(this, _$identity);
}

abstract class _ResultHistory implements ResultHistory {
  const factory _ResultHistory(
      {required final Player player,
      required final Session session,
      required final Result result}) = _$ResultHistoryImpl;

  @override
  Player get player;
  @override
  Session get session;
  @override
  Result get result;
  @override
  @JsonKey(ignore: true)
  _$$ResultHistoryImplCopyWith<_$ResultHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

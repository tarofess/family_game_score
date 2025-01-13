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

  /// Create a copy of ResultHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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

  /// Create a copy of ResultHistory
  /// with the given fields replaced by the non-null parameter values.
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

  /// Create a copy of ResultHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlayerCopyWith<$Res> get player {
    return $PlayerCopyWith<$Res>(_value.player, (value) {
      return _then(_value.copyWith(player: value) as $Val);
    });
  }

  /// Create a copy of ResultHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SessionCopyWith<$Res> get session {
    return $SessionCopyWith<$Res>(_value.session, (value) {
      return _then(_value.copyWith(session: value) as $Val);
    });
  }

  /// Create a copy of ResultHistory
  /// with the given fields replaced by the non-null parameter values.
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

  /// Create a copy of ResultHistory
  /// with the given fields replaced by the non-null parameter values.
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

  /// Create a copy of ResultHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
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

  /// Create a copy of ResultHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResultHistoryImplCopyWith<_$ResultHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ResultHistorySection {
  Session get session => throw _privateConstructorUsedError;
  List<ResultHistoryItems> get items => throw _privateConstructorUsedError;

  /// Create a copy of ResultHistorySection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResultHistorySectionCopyWith<ResultHistorySection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResultHistorySectionCopyWith<$Res> {
  factory $ResultHistorySectionCopyWith(ResultHistorySection value,
          $Res Function(ResultHistorySection) then) =
      _$ResultHistorySectionCopyWithImpl<$Res, ResultHistorySection>;
  @useResult
  $Res call({Session session, List<ResultHistoryItems> items});

  $SessionCopyWith<$Res> get session;
}

/// @nodoc
class _$ResultHistorySectionCopyWithImpl<$Res,
        $Val extends ResultHistorySection>
    implements $ResultHistorySectionCopyWith<$Res> {
  _$ResultHistorySectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResultHistorySection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? session = null,
    Object? items = null,
  }) {
    return _then(_value.copyWith(
      session: null == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as Session,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ResultHistoryItems>,
    ) as $Val);
  }

  /// Create a copy of ResultHistorySection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SessionCopyWith<$Res> get session {
    return $SessionCopyWith<$Res>(_value.session, (value) {
      return _then(_value.copyWith(session: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ResultHistorySectionImplCopyWith<$Res>
    implements $ResultHistorySectionCopyWith<$Res> {
  factory _$$ResultHistorySectionImplCopyWith(_$ResultHistorySectionImpl value,
          $Res Function(_$ResultHistorySectionImpl) then) =
      __$$ResultHistorySectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Session session, List<ResultHistoryItems> items});

  @override
  $SessionCopyWith<$Res> get session;
}

/// @nodoc
class __$$ResultHistorySectionImplCopyWithImpl<$Res>
    extends _$ResultHistorySectionCopyWithImpl<$Res, _$ResultHistorySectionImpl>
    implements _$$ResultHistorySectionImplCopyWith<$Res> {
  __$$ResultHistorySectionImplCopyWithImpl(_$ResultHistorySectionImpl _value,
      $Res Function(_$ResultHistorySectionImpl) _then)
      : super(_value, _then);

  /// Create a copy of ResultHistorySection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? session = null,
    Object? items = null,
  }) {
    return _then(_$ResultHistorySectionImpl(
      session: null == session
          ? _value.session
          : session // ignore: cast_nullable_to_non_nullable
              as Session,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ResultHistoryItems>,
    ));
  }
}

/// @nodoc

class _$ResultHistorySectionImpl implements _ResultHistorySection {
  const _$ResultHistorySectionImpl(
      {required this.session, required final List<ResultHistoryItems> items})
      : _items = items;

  @override
  final Session session;
  final List<ResultHistoryItems> _items;
  @override
  List<ResultHistoryItems> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'ResultHistorySection(session: $session, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResultHistorySectionImpl &&
            (identical(other.session, session) || other.session == session) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, session, const DeepCollectionEquality().hash(_items));

  /// Create a copy of ResultHistorySection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResultHistorySectionImplCopyWith<_$ResultHistorySectionImpl>
      get copyWith =>
          __$$ResultHistorySectionImplCopyWithImpl<_$ResultHistorySectionImpl>(
              this, _$identity);
}

abstract class _ResultHistorySection implements ResultHistorySection {
  const factory _ResultHistorySection(
          {required final Session session,
          required final List<ResultHistoryItems> items}) =
      _$ResultHistorySectionImpl;

  @override
  Session get session;
  @override
  List<ResultHistoryItems> get items;

  /// Create a copy of ResultHistorySection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResultHistorySectionImplCopyWith<_$ResultHistorySectionImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ResultHistoryItems {
  Player get player => throw _privateConstructorUsedError;
  Result get result => throw _privateConstructorUsedError;

  /// Create a copy of ResultHistoryItems
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResultHistoryItemsCopyWith<ResultHistoryItems> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResultHistoryItemsCopyWith<$Res> {
  factory $ResultHistoryItemsCopyWith(
          ResultHistoryItems value, $Res Function(ResultHistoryItems) then) =
      _$ResultHistoryItemsCopyWithImpl<$Res, ResultHistoryItems>;
  @useResult
  $Res call({Player player, Result result});

  $PlayerCopyWith<$Res> get player;
  $ResultCopyWith<$Res> get result;
}

/// @nodoc
class _$ResultHistoryItemsCopyWithImpl<$Res, $Val extends ResultHistoryItems>
    implements $ResultHistoryItemsCopyWith<$Res> {
  _$ResultHistoryItemsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResultHistoryItems
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? player = null,
    Object? result = null,
  }) {
    return _then(_value.copyWith(
      player: null == player
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as Player,
      result: null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as Result,
    ) as $Val);
  }

  /// Create a copy of ResultHistoryItems
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlayerCopyWith<$Res> get player {
    return $PlayerCopyWith<$Res>(_value.player, (value) {
      return _then(_value.copyWith(player: value) as $Val);
    });
  }

  /// Create a copy of ResultHistoryItems
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ResultCopyWith<$Res> get result {
    return $ResultCopyWith<$Res>(_value.result, (value) {
      return _then(_value.copyWith(result: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ResultHistoryItemsImplCopyWith<$Res>
    implements $ResultHistoryItemsCopyWith<$Res> {
  factory _$$ResultHistoryItemsImplCopyWith(_$ResultHistoryItemsImpl value,
          $Res Function(_$ResultHistoryItemsImpl) then) =
      __$$ResultHistoryItemsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Player player, Result result});

  @override
  $PlayerCopyWith<$Res> get player;
  @override
  $ResultCopyWith<$Res> get result;
}

/// @nodoc
class __$$ResultHistoryItemsImplCopyWithImpl<$Res>
    extends _$ResultHistoryItemsCopyWithImpl<$Res, _$ResultHistoryItemsImpl>
    implements _$$ResultHistoryItemsImplCopyWith<$Res> {
  __$$ResultHistoryItemsImplCopyWithImpl(_$ResultHistoryItemsImpl _value,
      $Res Function(_$ResultHistoryItemsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ResultHistoryItems
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? player = null,
    Object? result = null,
  }) {
    return _then(_$ResultHistoryItemsImpl(
      player: null == player
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as Player,
      result: null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as Result,
    ));
  }
}

/// @nodoc

class _$ResultHistoryItemsImpl implements _ResultHistoryItems {
  const _$ResultHistoryItemsImpl({required this.player, required this.result});

  @override
  final Player player;
  @override
  final Result result;

  @override
  String toString() {
    return 'ResultHistoryItems(player: $player, result: $result)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResultHistoryItemsImpl &&
            (identical(other.player, player) || other.player == player) &&
            (identical(other.result, result) || other.result == result));
  }

  @override
  int get hashCode => Object.hash(runtimeType, player, result);

  /// Create a copy of ResultHistoryItems
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResultHistoryItemsImplCopyWith<_$ResultHistoryItemsImpl> get copyWith =>
      __$$ResultHistoryItemsImplCopyWithImpl<_$ResultHistoryItemsImpl>(
          this, _$identity);
}

abstract class _ResultHistoryItems implements ResultHistoryItems {
  const factory _ResultHistoryItems(
      {required final Player player,
      required final Result result}) = _$ResultHistoryItemsImpl;

  @override
  Player get player;
  @override
  Result get result;

  /// Create a copy of ResultHistoryItems
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResultHistoryItemsImplCopyWith<_$ResultHistoryItemsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

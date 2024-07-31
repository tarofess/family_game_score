// Mocks generated by Mockito 5.4.4 from annotations
// in family_game_score/test/viewmodel/setting_viewmodel_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/widgets.dart' as _i3;
import 'package:flutter_riverpod/src/internals.dart' as _i5;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i4;
import 'package:riverpod/src/internals.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeProviderContainer_0 extends _i1.SmartFake
    implements _i2.ProviderContainer {
  _FakeProviderContainer_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeProviderSubscription_1<State1> extends _i1.SmartFake
    implements _i2.ProviderSubscription<State1> {
  _FakeProviderSubscription_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeBuildContext_2 extends _i1.SmartFake implements _i3.BuildContext {
  _FakeBuildContext_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [Ref].
///
/// See the documentation for Mockito's code generation for more information.
class MockRef<State extends Object?> extends _i1.Mock
    implements _i2.Ref<State> {
  MockRef() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.ProviderContainer get container => (super.noSuchMethod(
        Invocation.getter(#container),
        returnValue: _FakeProviderContainer_0(
          this,
          Invocation.getter(#container),
        ),
      ) as _i2.ProviderContainer);

  @override
  T refresh<T>(_i2.Refreshable<T>? provider) => (super.noSuchMethod(
        Invocation.method(
          #refresh,
          [provider],
        ),
        returnValue: _i4.dummyValue<T>(
          this,
          Invocation.method(
            #refresh,
            [provider],
          ),
        ),
      ) as T);

  @override
  void invalidate(_i2.ProviderOrFamily? provider) => super.noSuchMethod(
        Invocation.method(
          #invalidate,
          [provider],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void notifyListeners() => super.noSuchMethod(
        Invocation.method(
          #notifyListeners,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void listenSelf(
    void Function(
      State?,
      State,
    )? listener, {
    void Function(
      Object,
      StackTrace,
    )? onError,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #listenSelf,
          [listener],
          {#onError: onError},
        ),
        returnValueForMissingStub: null,
      );

  @override
  void invalidateSelf() => super.noSuchMethod(
        Invocation.method(
          #invalidateSelf,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void onAddListener(void Function()? cb) => super.noSuchMethod(
        Invocation.method(
          #onAddListener,
          [cb],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void onRemoveListener(void Function()? cb) => super.noSuchMethod(
        Invocation.method(
          #onRemoveListener,
          [cb],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void onResume(void Function()? cb) => super.noSuchMethod(
        Invocation.method(
          #onResume,
          [cb],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void onCancel(void Function()? cb) => super.noSuchMethod(
        Invocation.method(
          #onCancel,
          [cb],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void onDispose(void Function()? cb) => super.noSuchMethod(
        Invocation.method(
          #onDispose,
          [cb],
        ),
        returnValueForMissingStub: null,
      );

  @override
  T read<T>(_i2.ProviderListenable<T>? provider) => (super.noSuchMethod(
        Invocation.method(
          #read,
          [provider],
        ),
        returnValue: _i4.dummyValue<T>(
          this,
          Invocation.method(
            #read,
            [provider],
          ),
        ),
      ) as T);

  @override
  bool exists(_i2.ProviderBase<Object?>? provider) => (super.noSuchMethod(
        Invocation.method(
          #exists,
          [provider],
        ),
        returnValue: false,
      ) as bool);

  @override
  T watch<T>(_i2.AlwaysAliveProviderListenable<T>? provider) =>
      (super.noSuchMethod(
        Invocation.method(
          #watch,
          [provider],
        ),
        returnValue: _i4.dummyValue<T>(
          this,
          Invocation.method(
            #watch,
            [provider],
          ),
        ),
      ) as T);

  @override
  _i2.ProviderSubscription<T> listen<T>(
    _i2.AlwaysAliveProviderListenable<T>? provider,
    void Function(
      T?,
      T,
    )? listener, {
    void Function(
      Object,
      StackTrace,
    )? onError,
    bool? fireImmediately,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #listen,
          [
            provider,
            listener,
          ],
          {
            #onError: onError,
            #fireImmediately: fireImmediately,
          },
        ),
        returnValue: _FakeProviderSubscription_1<T>(
          this,
          Invocation.method(
            #listen,
            [
              provider,
              listener,
            ],
            {
              #onError: onError,
              #fireImmediately: fireImmediately,
            },
          ),
        ),
      ) as _i2.ProviderSubscription<T>);
}

/// A class which mocks [WidgetRef].
///
/// See the documentation for Mockito's code generation for more information.
class MockWidgetRef extends _i1.Mock implements _i5.WidgetRef {
  MockWidgetRef() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.BuildContext get context => (super.noSuchMethod(
        Invocation.getter(#context),
        returnValue: _FakeBuildContext_2(
          this,
          Invocation.getter(#context),
        ),
      ) as _i3.BuildContext);

  @override
  T watch<T>(_i2.ProviderListenable<T>? provider) => (super.noSuchMethod(
        Invocation.method(
          #watch,
          [provider],
        ),
        returnValue: _i4.dummyValue<T>(
          this,
          Invocation.method(
            #watch,
            [provider],
          ),
        ),
      ) as T);

  @override
  bool exists(_i2.ProviderBase<Object?>? provider) => (super.noSuchMethod(
        Invocation.method(
          #exists,
          [provider],
        ),
        returnValue: false,
      ) as bool);

  @override
  void listen<T>(
    _i2.ProviderListenable<T>? provider,
    void Function(
      T?,
      T,
    )? listener, {
    void Function(
      Object,
      StackTrace,
    )? onError,
  }) =>
      super.noSuchMethod(
        Invocation.method(
          #listen,
          [
            provider,
            listener,
          ],
          {#onError: onError},
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i2.ProviderSubscription<T> listenManual<T>(
    _i2.ProviderListenable<T>? provider,
    void Function(
      T?,
      T,
    )? listener, {
    void Function(
      Object,
      StackTrace,
    )? onError,
    bool? fireImmediately,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #listenManual,
          [
            provider,
            listener,
          ],
          {
            #onError: onError,
            #fireImmediately: fireImmediately,
          },
        ),
        returnValue: _FakeProviderSubscription_1<T>(
          this,
          Invocation.method(
            #listenManual,
            [
              provider,
              listener,
            ],
            {
              #onError: onError,
              #fireImmediately: fireImmediately,
            },
          ),
        ),
      ) as _i2.ProviderSubscription<T>);

  @override
  T read<T>(_i2.ProviderListenable<T>? provider) => (super.noSuchMethod(
        Invocation.method(
          #read,
          [provider],
        ),
        returnValue: _i4.dummyValue<T>(
          this,
          Invocation.method(
            #read,
            [provider],
          ),
        ),
      ) as T);

  @override
  State refresh<State>(_i2.Refreshable<State>? provider) => (super.noSuchMethod(
        Invocation.method(
          #refresh,
          [provider],
        ),
        returnValue: _i4.dummyValue<State>(
          this,
          Invocation.method(
            #refresh,
            [provider],
          ),
        ),
      ) as State);

  @override
  void invalidate(_i2.ProviderOrFamily? provider) => super.noSuchMethod(
        Invocation.method(
          #invalidate,
          [provider],
        ),
        returnValueForMissingStub: null,
      );
}

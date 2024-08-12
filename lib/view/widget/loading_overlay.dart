import 'package:flutter/material.dart';

class LoadingOverlay {
  final BuildContext _context;
  OverlayEntry? _overlay;
  bool _isLoading = false;

  LoadingOverlay._private(this._context);

  factory LoadingOverlay.of(BuildContext context) {
    return LoadingOverlay._private(context);
  }

  void show() {
    if (!_isLoading) {
      _isLoading = true;
      _overlay = OverlayEntry(
        builder: (context) => ColoredBox(
          color: Colors.black.withOpacity(0.5),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
      Overlay.of(_context).insert(_overlay!);
    }
  }

  void hide() {
    if (_isLoading) {
      _overlay?.remove();
      _overlay = null;
      _isLoading = false;
    }
  }

  Future<T> during<T>(Future<T> Function() asyncFunction) async {
    show();
    try {
      final result = await asyncFunction();
      return result;
    } finally {
      hide();
    }
  }

  bool get isLoading => _isLoading;
}

extension LoadingOverlayExtension on Widget {
  Widget withLoadingOverlay({Key? key}) {
    return _LoadingOverlayWidget(key: key, child: this);
  }
}

class _LoadingOverlayWidget extends StatefulWidget {
  final Widget child;

  const _LoadingOverlayWidget({required this.child, super.key});

  @override
  _LoadingOverlayWidgetState createState() => _LoadingOverlayWidgetState();
}

class _LoadingOverlayWidgetState extends State<_LoadingOverlayWidget> {
  late LoadingOverlay _loadingOverlay;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadingOverlay = LoadingOverlay.of(context);
  }

  @override
  void dispose() {
    _loadingOverlay.hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResultHistoryView extends ConsumerWidget {
  const ResultHistoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: Container(
      child: Text('ResultHistory'),
    ));
  }
}

import 'package:flutter/material.dart';

class ScaffoldTheme extends StatelessWidget {
  final Future<void> Function()? onRefresh;
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Drawer? drawer;

  const ScaffoldTheme({
    super.key,
    required this.body,
    this.onRefresh,
    this.appBar,
    this.floatingActionButton,
    this.drawer,
  });

  @override
  Widget build(BuildContext context) {
    final Widget content =
        onRefresh != null
            ? RefreshIndicator(
              onRefresh: onRefresh!,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: body,
              ),
            )
            : body;

    return Scaffold(
      drawer: drawer,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      body: content,
    );
  }
}

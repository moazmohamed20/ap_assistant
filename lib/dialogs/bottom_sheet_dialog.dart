import 'package:flutter/material.dart';

class BottomSheetDialog extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;

  const BottomSheetDialog({super.key, required this.title, required this.body, this.actions});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // * Title
          Padding(
            padding: const EdgeInsets.only(left: 24, top: 24, right: 24, bottom: 0),
            child: Text(title, style: Theme.of(context).textTheme.titleLarge),
          ),

          // * Body
          Padding(
            padding: const EdgeInsets.only(left: 24, top: 16, right: 24, bottom: 24),
            child: body,
          ),

          // * Actions
          if (actions?.isNotEmpty ?? false)
            Padding(
              padding: const EdgeInsets.all(8),
              child: OverflowBar(
                spacing: 8,
                alignment: MainAxisAlignment.end,
                overflowDirection: VerticalDirection.down,
                overflowAlignment: OverflowBarAlignment.end,
                children: actions!,
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

Future<void> showFlowchartDialog(BuildContext context, String title) async {
  return showDialog(
    context: context,
    builder: (_) => Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            title: Text(title),
            actions: [
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))
            ],
          ),
          Flexible(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 3,
              child: Image.asset('assets/images/flowchart.png', fit: BoxFit.contain),
            ),
          )
        ],
      ),
    ),
  );
}

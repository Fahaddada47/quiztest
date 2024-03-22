import 'package:flutter/material.dart';

class alert_dialog extends StatelessWidget {
  const alert_dialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text("Loading next question..."),
        ],
      ),
    );
  }
}
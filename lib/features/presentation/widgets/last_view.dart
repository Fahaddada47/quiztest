import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LastView extends StatefulWidget {
  const LastView({
    super.key,
    required this.currentScore,
  });

  final int currentScore;

  @override
  State<LastView> createState() => _lastViewState();
}

class _lastViewState extends State<LastView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time\'s Up'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Time\'s Up!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Total Score: ${widget.currentScore}',
              style: TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back(result: widget.currentScore);
              },
              child: const Text('Back to Home'),
            ),

          ],
        ),
      ),
    );
  }
}


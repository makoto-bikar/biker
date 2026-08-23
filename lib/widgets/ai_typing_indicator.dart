import 'dart:async';

import 'package:flutter/material.dart';

class AiTypingIndicator extends StatefulWidget {
  const AiTypingIndicator({
    super.key,
  });

  @override
  State<AiTypingIndicator> createState() => _AiTypingIndicatorState();
}

class _AiTypingIndicatorState extends State<AiTypingIndicator> {
  int dotCount = 1;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
      const Duration(milliseconds: 400),
      (_) {
        if (!mounted) return;

        setState(() {
          dotCount++;

          if (dotCount > 3) {
            dotCount = 1;
          }
        });
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          "🤖  ${"●" * dotCount}",
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
            letterSpacing: 4,
          ),
        ),
      ),
    );
  }
}
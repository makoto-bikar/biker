import 'dart:async';

import 'package:flutter/material.dart';

class AiTypingIndicator extends StatefulWidget {
  const AiTypingIndicator({
    super.key,
  });

  @override
  State<AiTypingIndicator> createState() =>
      _AiTypingIndicatorState();
}

class _AiTypingIndicatorState
    extends State<AiTypingIndicator> {
  Timer? timer;

  int activeDot = 0;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
      const Duration(milliseconds: 580),
      (_) {
        if (!mounted) return;

        setState(() {
          activeDot++;

          if (activeDot > 2) {
            activeDot = 0;
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
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDot(0),

          const SizedBox(
            width: 6,
          ),

          _buildDot(1),

          const SizedBox(
            width: 6,
          ),

          _buildDot(2),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    final bool active =
        activeDot == index;

    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 390,
      ),

      width: active ? 8 : 6,
      height: active ? 8 : 6,

      decoration: BoxDecoration(
        color: active
            ? Colors.white
            : Colors.white30,
        shape: BoxShape.circle,
      ),
    );
  }
}
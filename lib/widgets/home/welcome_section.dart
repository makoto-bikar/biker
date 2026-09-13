import 'package:flutter/material.dart';

import '../../widgets/question_card.dart';

class WelcomeSection extends StatelessWidget {
  final List<String> questions;

  final Future<void> Function(String question) onQuestionTap;

  const WelcomeSection({
    super.key,
    required this.questions,
    required this.onQuestionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ===================================================
        // おすすめ
        // ===================================================

        const Text(
          "おすすめ",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(
          height: 14,
        ),

        // ===================================================
        // おすすめ質問
        // ===================================================

        ...questions.map(
          (question) => QuestionCard(
            text: question,
            onTap: () async {
              await onQuestionTap(question);
            },
          ),
        ),

        const SizedBox(
          height: 18,
        ),

        // ===================================================
        // BIKAR AI Welcome
        // ===================================================

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(
            14,
          ),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(
              16,
            ),
          ),
          child: const Text(
            "🤖 こんにちは！BIKER AIです。\n"
            "何でも聞いてください！",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),

        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
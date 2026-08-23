import 'package:flutter/material.dart';

class QuestionCard extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const QuestionCard({
    super.key,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),

      child: InkWell(
        borderRadius: BorderRadius.circular(16),

        onTap: onTap,

        child: Container(
          width: double.infinity,

          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 14,
          ),

          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.10),

            borderRadius:
                BorderRadius.circular(16),

            border: Border.all(
              color: Colors.white.withOpacity(0.18),
              width: 1,
            ),
          ),

          child: Row(
            children: [
              // =========================
              // アイコン
              // =========================

              Container(
                width: 32,
                height: 32,

                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white70,
                  size: 16,
                ),
              ),

              const SizedBox(width: 14),

              // =========================
              // 質問
              // =========================

              Expanded(
                child: Text(
                  text,

                  textAlign: TextAlign.left,

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // =========================
              // 矢印
              // =========================

              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white38,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
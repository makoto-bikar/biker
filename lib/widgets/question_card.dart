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
      padding: const EdgeInsets.only(bottom: 10),

      child: InkWell(
        borderRadius: BorderRadius.circular(14),

        onTap: onTap,

        child: Container(
          width: double.infinity,

          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),

          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.10),

            borderRadius:
                BorderRadius.circular(14),

            border: Border.all(
              color: Colors.white.withOpacity(0.16),
              width: 1,
            ),
          ),

          child: Row(
            children: [
              // =========================
              // アイコン
              // =========================

              Container(
                width: 30,
                height: 30,

                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),

                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white70,
                  size: 15,
                ),
              ),

              const SizedBox(width: 12),

              // =========================
              // 質問
              // =========================

              Expanded(
                child: Text(
                  text,

                  textAlign: TextAlign.left,

                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.35,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // =========================
              // 矢印
              // =========================

              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white38,
                size: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

import '../../models/chat_message.dart';
import '../../services/openai_service.dart';
import '../../services/custom_plan_service.dart';
import 'custom_plan_card.dart';
import 'product_recommendation_card.dart';

class ChatMessageItem extends StatelessWidget {
  final ChatMessage message;

  final List<ProductRecommendation> products;

  final CustomPlan? customPlan;

  final Future<void> Function(String searchQuery) onAmazonSearch;

  const ChatMessageItem({
    super.key,
    required this.message,
    required this.products,
    required this.customPlan,
    required this.onAmazonSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: message.isUser ? 32 : 10,
      ),
      alignment: message.isUser
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: message.isUser
              ? MediaQuery.of(context).size.width * 0.68
              : MediaQuery.of(context).size.width * 0.94,
        ),
        decoration: message.isUser
            ? BoxDecoration(
                color: const Color(0xFF292929),
                borderRadius: BorderRadius.circular(18),
              )
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =================================================
            // 本文
            // =================================================

            Text(
              message.text,
              style: TextStyle(
                color: message.isUser
                    ? const Color(0xFFE8E8E8)
                    : Colors.white,
                fontSize: 14,
                height: 1.5,
              ),
            ),

            // =================================================
            // Custom Plan
            // =================================================

            if (!message.isUser && customPlan != null) ...[
              const SizedBox(
                height: 20,
              ),

              CustomPlanCard(
                plan: customPlan!,
                onAmazonSearch: onAmazonSearch,
              ),
            ],

            // =================================================
            // 商品
            // =================================================

            if (!message.isUser && products.isNotEmpty) ...[
              const SizedBox(
                height: 16,
              ),

              const Text(
                "おすすめ商品",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              ...products.map(
                (product) => ProductRecommendationCard(
                  product: product,
                  onAmazonSearch: onAmazonSearch,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
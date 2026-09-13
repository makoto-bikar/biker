import 'package:flutter/material.dart';

import '../../services/openai_service.dart';

class ProductRecommendationCard extends StatelessWidget {
  final ProductRecommendation product;

  final Future<void> Function(String searchQuery) onAmazonSearch;

  const ProductRecommendationCard({
    super.key,
    required this.product,
    required this.onAmazonSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      padding: const EdgeInsets.all(
        14,
      ),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(
          14,
        ),
        border: Border.all(
          color: Colors.white12,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===================================================
          // 商品名
          // ===================================================

          Text(
            product.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
          ),

          // ===================================================
          // カテゴリ
          // ===================================================

          if (product.category.isNotEmpty) ...[
            const SizedBox(
              height: 4,
            ),

            Text(
              product.category,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 11,
              ),
            ),
          ],

          // ===================================================
          // おすすめ理由
          // ===================================================

          if (product.reason.isNotEmpty) ...[
            const SizedBox(
              height: 8,
            ),

            Text(
              product.reason,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ],

          const SizedBox(
            height: 12,
          ),

          // ===================================================
          // Amazon検索
          // ===================================================

          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                onAmazonSearch(
                  product.searchQuery,
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(
                  color: Colors.white24,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 11,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
              ),
              child: const Text(
                "Amazonで検索",
                style: TextStyle(
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
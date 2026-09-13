import 'package:flutter/material.dart';

import '../home_screen.dart';

class CustomStepScreen extends StatelessWidget {
  final String manufacturer;
  final String bike;
  final String year;
  final String style;

  const CustomStepScreen({
    super.key,
    required this.manufacturer,
    required this.bike,
    required this.year,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            22,
            20,
            22,
            40,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ==================================================
              // ヘッダー
              // ==================================================

              const Text(
                "理想の一台まで、あと一歩。",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "あなたのバイクと理想のスタイルを分析して、\n"
                "最初にやるべきカスタムをAIが選びました。",
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 15,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 32),

              // ==================================================
              // STEP
              // ==================================================

              Row(
                children: [

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: const Text(
                      "STEP 1",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Text(
                    "最初のカスタム",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // ==================================================
              // カスタムカード
              // ==================================================

              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: const Color(0xFF111111),

                  borderRadius: BorderRadius.circular(22),

                  border: Border.all(
                    color: Colors.white12,
                  ),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    const Text(
                      "ミラーを交換する",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 14),

                    const Text(
                      "理想の一台に近づけるために、\n"
                      "まずはミラーを交換してフロント周りを\n"
                      "すっきりさせましょう。",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        height: 1.7,
                      ),
                    ),

                    const SizedBox(height: 22),

                    // ------------------------------------------
                    // 難易度・時間
                    // ------------------------------------------

                    Row(
                      children: [

                        _InfoChip(
                          icon: Icons.star_outline,
                          label: "難易度 ★☆☆☆☆",
                        ),

                        const SizedBox(width: 10),

                        _InfoChip(
                          icon: Icons.schedule,
                          label: "約15分",
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ==================================================
              // 必要なパーツ
              // ==================================================

              const Text(
                "必要なパーツ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              _ProductCard(
                name: "チョッパータイプ ミラー",
                type: "カスタムパーツ",
                onPressed: () {
                  // 後でAmazonアソシエイトリンクを設定
                },
              ),

              const SizedBox(height: 28),

              // ==================================================
              // 必要な工具
              // ==================================================

              const Text(
                "必要な工具",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              _ProductCard(
                name: "14mm メガネレンチ",
                type: "工具",
                onPressed: () {
                  // 後でAmazonアソシエイトリンクを設定
                },
              ),

              const SizedBox(height: 30),

              // ==================================================
              // AIからの一言
              // ==================================================

              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.04),

                  borderRadius: BorderRadius.circular(18),

                  border: Border.all(
                    color: Colors.white10,
                  ),
                ),

                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Icon(
                      Icons.auto_awesome,
                      color: Colors.white70,
                      size: 20,
                    ),

                    SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        "まずは簡単なカスタムから始めましょう。"
                        "一つ完成させるだけでも、理想の一台に一歩近づきます。",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ==================================================
              // AI相談
              // ==================================================

              SizedBox(
                width: double.infinity,
                height: 56,

                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HomeScreen(),
                      ),
                    );
                  },

                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,

                    side: const BorderSide(
                      color: Colors.white24,
                    ),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),

                  child: const Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [

                      Icon(
                        Icons.chat_bubble_outline,
                        size: 18,
                      ),

                      SizedBox(width: 8),

                      Text(
                        "このカスタムについてAIに聞く",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // ==================================================
              // バイク情報
              // ==================================================

              Center(
                child: Text(
                  "$manufacturer $bike  •  $year  •  $style",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white30,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// ================================================================
// 情報チップ
// ================================================================

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
      ),

      child: Row(
        children: [

          Icon(
            icon,
            color: Colors.white60,
            size: 15,
          ),

          const SizedBox(width: 6),

          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}


// ================================================================
// 商品カード
// ================================================================

class _ProductCard extends StatelessWidget {
  final String name;
  final String type;
  final VoidCallback onPressed;

  const _ProductCard({
    required this.name,
    required this.type,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: const Color(0xFF111111),

        borderRadius: BorderRadius.circular(16),

        border: Border.all(
          color: Colors.white10,
        ),
      ),

      child: Row(
        children: [

          Container(
            width: 46,
            height: 46,

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
            ),

            child: const Icon(
              Icons.build_outlined,
              color: Colors.white70,
              size: 22,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  type,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          TextButton(
            onPressed: onPressed,

            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),

            child: const Text(
              "Amazon",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
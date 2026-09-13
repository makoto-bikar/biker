import 'package:flutter/material.dart';
import 'experience_screen.dart';

class StyleScreen extends StatefulWidget {
  final String manufacturer;
  final String bike;
  final String year;

  const StyleScreen({
    super.key,
    required this.manufacturer,
    required this.bike,
    required this.year,
  });

  @override
  State<StyleScreen> createState() => _StyleScreenState();
}

class _StyleScreenState extends State<StyleScreen> {
  // =========================
  // 全体シルエット
  // =========================

  final List<String> silhouettes = [
    "チョッパー",
    "ボバー",
    "ストリート",
  ];

  String? selectedSilhouette;

  // =========================
  // タンク
  // =========================

  final List<String> tanks = [
    "スポーツスター",
    "ピーナッツ",
  ];

  String? selectedTank;

  // =========================
  // ハンドル
  // =========================

  final List<String> handlebars = [
    "エイプ",
    "プルバック",
  ];

  String? selectedHandlebar;

  // =========================
  // フロントフォーク
  // =========================

  final List<String> frontForks = [
    "ロング",
    "ノーマル",
  ];

  String? selectedFrontFork;

  // =========================
  // 全項目が選択されているか
  // =========================

  bool get canGenerate {
    return selectedSilhouette != null &&
        selectedTank != null &&
        selectedHandlebar != null &&
        selectedFrontFork != null;
  }

  // =========================
  // 仮ビジュアル
  // 後から画像に差し替える
  // =========================

  Widget _buildVisual({
    required String title,
    required String imagePath,
    required bool selected,
    required VoidCallback onTap,
    double height = 120,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: height,
        decoration: BoxDecoration(
          color: selected
              ? Colors.white
              : const Color(0xFF151515),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? Colors.white
                : Colors.white12,
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            Padding(
  padding: const EdgeInsets.all(6),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(14),
    child: Image.asset(
      imagePath,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
    ),
  ),
),

            if (selected)
              const Positioned(
                top: 12,
                right: 12,
                child: Icon(
                  Icons.check_circle,
                  color: Colors.black,
                  size: 22,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // =========================
  // セクションタイトル
  // =========================

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  // =========================
  // 次へ
  // =========================

  void _goNext() {
    if (!canGenerate) return;

    // 現段階では既存のExperienceScreenへ
    //
    // 今後ここで、
    // silhouette / tank / handlebar / fork
    // を画像生成AIへ渡す。
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ExperienceScreen(
          manufacturer: widget.manufacturer,
          bike: widget.bike,
          year: widget.year,
          style: selectedSilhouette!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final horizontalPadding =
        screenWidth > 700
            ? screenWidth * 0.18
            : 24.0;

    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
          ),

          child: Column(
            children: [
              // =========================
              // ヘッダー
              // =========================

              Row(
                children: [
                  const Text(
                    "BIKER",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),

                  const Spacer(),

                  Text(
                    "${widget.bike} / ${widget.year}",
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 38),

              // =========================
              // タイトル
              // =========================

              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "STYLE",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "理想のバイクを組み立てよう。",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // =========================
              // スクロールエリア
              // =========================

              Expanded(
                child: SingleChildScrollView(
                  physics:
                      const BouncingScrollPhysics(),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      // =========================
                      // シルエット
                      // =========================

                      _buildSectionTitle(
                        "SILHOUETTE",
                      ),

                      SizedBox(
                        height: 170,
                        child: ListView.separated(
                          scrollDirection:
                              Axis.horizontal,
                          itemCount:
                              silhouettes.length,
                          separatorBuilder:
                              (_, __) =>
                                  const SizedBox(
                            width: 12,
                          ),
                          itemBuilder:
                              (context, index) {
                            final item =
                                silhouettes[index];

                            return SizedBox(
                              width: 230,
                              child: _buildVisual(
                                title: item,
                                icon: Icons
                                    .two_wheeler,
                                selected:
                                    selectedSilhouette ==
                                        item,
                                onTap: () {
                                  setState(() {
                                    selectedSilhouette =
                                        item;
                                  });
                                },
                                height: 170,
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 30),

                      // =========================
                      // タンク
                      // =========================

                      _buildSectionTitle(
                        "TANK",
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: _buildVisual(
                              title:
                                  tanks[0],
                              imagePath: 'assets/images/tank_sportster.png',
                              selected:
                                  selectedTank ==
                                      tanks[0],
                              onTap: () {
                                setState(() {
                                  selectedTank =
                                      tanks[0];
                                });
                              },
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: _buildVisual(
                              title:
                                  tanks[1],
                              imagePath: 'assets/images/tank_peanut.png',
                              selected:
                                  selectedTank ==
                                      tanks[1],
                              onTap: () {
                                setState(() {
                                  selectedTank =
                                      tanks[1];
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // =========================
                      // ハンドル
                      // =========================

                      _buildSectionTitle(
                        "HANDLEBAR",
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: _buildVisual(
                              title:
                                  handlebars[0],
                              imagePath: 'assets/images/handlebar_ape.png',
                              selected:
                                  selectedHandlebar ==
                                      handlebars[0],
                              onTap: () {
                                setState(() {
                                  selectedHandlebar =
                                      handlebars[0];
                                });
                              },
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: _buildVisual(
                              title:
                                  handlebars[1],
                              imagePath: 'assets/images/handlebar_pullback.png',
                              selected:
                                  selectedHandlebar ==
                                      handlebars[1],
                              onTap: () {
                                setState(() {
                                  selectedHandlebar =
                                      handlebars[1];
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // =========================
                      // フロントフォーク
                      // =========================

                      _buildSectionTitle(
                        "FRONT FORK",
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: _buildVisual(
                              title:
                                  frontForks[0],
                              imagePath: 'assets/images/fork_long.png',
                              selected:
                                  selectedFrontFork ==
                                      frontForks[0],
                              onTap: () {
                                setState(() {
                                  selectedFrontFork =
                                      frontForks[0];
                                });
                              },
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: _buildVisual(
                              title:
                                  frontForks[1],
                              imagePath: 'assets/images/fork_normal.png',
                              selected:
                                  selectedFrontFork ==
                                      frontForks[1],
                              onTap: () {
                                setState(() {
                                  selectedFrontFork =
                                      frontForks[1];
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),

              // =========================
              // 生成ボタン
              // =========================

              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed:
                      canGenerate
                          ? _goNext
                          : null,

                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.white,
                    foregroundColor:
                        Colors.black,
                    disabledBackgroundColor:
                        const Color(0xFF181818),
                    disabledForegroundColor:
                        Colors.white24,
                    elevation: 0,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                  ),

                  child: const Text(
                    "このスタイルで生成",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
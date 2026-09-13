import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/firestore_service.dart';
import '../../services/bike_image_service.dart';
import 'bike_result_screen.dart';

class LoadingScreen extends StatefulWidget {
  final String manufacturer;
  final String bike;
  final String year;
  final String style;

  // ------------------------------------------------------------
  // experienceは既存のオンボーディングとの互換性のため残す
  // 画像生成には使用しない
  // ------------------------------------------------------------

  final String experience;

  const LoadingScreen({
    super.key,
    required this.manufacturer,
    required this.bike,
    required this.year,
    required this.style,
    required this.experience,
  });

  @override
  State<LoadingScreen> createState() =>
      _LoadingScreenState();
}

class _LoadingScreenState
    extends State<LoadingScreen> {

  // ============================================================
  // ステップ
  // ============================================================

  final List<String> steps = [
    "バイク情報を確認しています...",
    "あなたのスタイルを分析しています...",
    "理想のカスタムを考えています...",
    "あなたのバイクをデザインしています...",
    "理想の一台を生成しています...",
  ];

  int currentStep = 0;

  // ------------------------------------------------------------
  // 現在の進捗率
  // 0.0 = 0%
  // 1.0 = 100%
  // ------------------------------------------------------------

  double progress = 0.0;

  bool isGenerating = false;

  String? errorMessage;

  Uint8List? generatedImage;

  // ------------------------------------------------------------
  // 画像生成中に進捗を少しずつ進めるためのTimer
  // ------------------------------------------------------------

  Timer? progressTimer;


  // ============================================================
  // 初期化
  // ============================================================

  @override
  void initState() {
    super.initState();

    _startGeneration();
  }


  // ============================================================
  // 画像生成開始
  // ============================================================

  Future<void> _startGeneration() async {

  print("========== START GENERATION ==========");

  // ----------------------------------------------------------
  // 二重実行防止
  // ----------------------------------------------------------

  if (isGenerating) {
    print("========== ALREADY GENERATING ==========");
    return;
  }

    setState(() {
      isGenerating = true;
      currentStep = 0;
      progress = 0.05;
      errorMessage = null;
      generatedImage = null;
    });

    try {

      // ========================================================
      // STEP 1
      // バイク情報を確認
      // ========================================================

      _updateStep(0);

print("========== BEFORE PROGRESS 1 ==========");

await _animateProgressTo(
  0.15,
  const Duration(milliseconds: 900),
);

print("========== AFTER PROGRESS 1 ==========");
print("========== BEFORE FIRESTORE SAVE ==========");

await FirestoreService().saveUser(
  manufacturer: widget.manufacturer,
  bike: widget.bike,
  year: widget.year,
  style: widget.style,
  experience: widget.experience,
);

print("========== AFTER FIRESTORE SAVE ==========");


      // ========================================================
      // STEP 2
      // スタイル分析
      // ========================================================

      _updateStep(1);

      await _animateProgressTo(
        0.30,
        const Duration(milliseconds: 900),
      );

      await Future.delayed(
        const Duration(milliseconds: 400),
      );


      // ========================================================
      // STEP 3
      // 理想のカスタムを考える
      // ========================================================

      _updateStep(2);

      await _animateProgressTo(
        0.45,
        const Duration(milliseconds: 900),
      );

      await Future.delayed(
        const Duration(milliseconds: 400),
      );


      // ========================================================
      // STEP 4
      // あなたのバイクをデザイン
      // ========================================================

      _updateStep(3);

      await _animateProgressTo(
        0.60,
        const Duration(milliseconds: 900),
      );


      // ========================================================
      // STEP 5
      // 理想の一台を生成
      // ========================================================

      _updateStep(4);

      // --------------------------------------------------------
      // ここから画像生成
      //
      // 60%で止まらないように、
      // 画像生成中も60% → 95%まで徐々に進める
      //
      // 95%から先には、画像生成が完了するまで進まない
      // --------------------------------------------------------

      _startGenerationProgress();


      // ========================================================
// OpenAI画像生成
// ========================================================

print("========== BEFORE BIKE IMAGE SERVICE ==========");
print("manufacturer: ${widget.manufacturer}");
print("bike: ${widget.bike}");
print("year: ${widget.year}");
print("style: ${widget.style}");

generatedImage =
    await BikeImageService.generateBikeImage(
  manufacturer: widget.manufacturer,
  bike: widget.bike,
  year: widget.year,
  style: widget.style,
);

print("========== AFTER BIKE IMAGE SERVICE ==========");
print("generatedImage is null: ${generatedImage == null}");


      // ========================================================
      // 画像生成失敗
      // ========================================================

      if (generatedImage == null) {
        throw Exception(
          "画像生成に失敗しました。",
        );
      }


      // ========================================================
      // 画像生成完了
      // ========================================================

      _stopGenerationProgress();


      // --------------------------------------------------------
      // 95% → 100%
      //
      // 画像が完成してから最後の100%へ進む
      // --------------------------------------------------------

      await _animateProgressTo(
        1.0,
        const Duration(milliseconds: 600),
      );


      // ========================================================
      // オンボーディング完了
      // ========================================================

      final prefs =
          await SharedPreferences.getInstance();

      await prefs.setBool(
        'onboarding_completed',
        true,
      );


      // --------------------------------------------------------
      // 画面がまだ存在するか確認
      // --------------------------------------------------------

      if (!mounted) {
        return;
      }


      // ========================================================
      // 理想の一台画面へ
      // ========================================================

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              BikeResultScreen(
            imageBytes:
                generatedImage!,

            manufacturer:
                widget.manufacturer,

            bike:
                widget.bike,

            year:
                widget.year,

            style:
                widget.style,
          ),
        ),
      );

    } catch (e) {

      // --------------------------------------------------------
      // エラーが起きたらTimerを停止
      // --------------------------------------------------------

      _stopGenerationProgress();

      if (!mounted) {
        return;
      }

      setState(() {
        isGenerating = false;

        errorMessage =
            "画像の生成に失敗しました。\n"
            "もう一度試してください。";
      });
    }
  }


  // ============================================================
  // STEP更新
  // ============================================================

  void _updateStep(
    int step,
  ) {

    if (!mounted) {
      return;
    }

    setState(() {
      currentStep = step;
    });
  }


  // ============================================================
  // プログレスを滑らかに進める
  //
  // 例：
  //
  // 5%
  // ↓
  // 6%
  // ↓
  // 7%
  // ↓
  // ...
  // ↓
  // 15%
  //
  // のように徐々に進む
  // ============================================================

  Future<void> _animateProgressTo(
    double target,
    Duration duration,
  ) async {

    if (!mounted) {
      return;
    }

    final start = progress;

    final difference =
        target - start;

    // ----------------------------------------------------------
    // すでに目標値以上なら何もしない
    // ----------------------------------------------------------

    if (difference <= 0) {
      return;
    }

    // ----------------------------------------------------------
    // アニメーションを30段階に分ける
    // ----------------------------------------------------------

    const int frames = 30;

    final frameDuration =
        Duration(
      milliseconds:
          duration.inMilliseconds ~/ frames,
    );

    for (
      int i = 1;
      i <= frames;
      i++
    ) {

      if (!mounted) {
        return;
      }

      await Future.delayed(
        frameDuration,
      );

      if (!mounted) {
        return;
      }

      final value =
          start +
          (
            difference *
            (i / frames)
          );

      setState(() {
        progress = value;
      });
    }
  }


  // ============================================================
  // 画像生成中のプログレス
  //
  // 60% → 95%
  //
  // OpenAIの画像生成には時間差があるため、
  // 生成が終わるまでゆっくり進ませる。
  //
  // 95%に到達したらそこで待機。
  // ============================================================

  void _startGenerationProgress() {

    // ----------------------------------------------------------
    // 既存Timerがあれば停止
    // ----------------------------------------------------------

    _stopGenerationProgress();


    progressTimer =
        Timer.periodic(
      const Duration(milliseconds: 150),
      (_) {

        if (!mounted) {
          return;
        }

        // ------------------------------------------------------
        // 95%に到達したら、それ以上進めない
        // ------------------------------------------------------

        if (progress >= 0.95) {
          return;
        }


        setState(() {

          progress += 0.003;

          // ----------------------------------------------------
          // 万が一95%を超えないようにする
          // ----------------------------------------------------

          if (progress > 0.95) {
            progress = 0.95;
          }
        });
      },
    );
  }


  // ============================================================
  // プログレスTimer停止
  // ============================================================

  void _stopGenerationProgress() {

    progressTimer?.cancel();

    progressTimer = null;
  }


  // ============================================================
  // dispose
  // ============================================================

  @override
  void dispose() {

    _stopGenerationProgress();

    super.dispose();
  }


  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {

    final width =
        MediaQuery.of(context).size.width;


    return Scaffold(
      backgroundColor:
          Colors.black,

      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.symmetric(
            horizontal:
                width * 0.08,
          ),

          child: Column(
            children: [

              const Spacer(),


              // ==================================================
              // AIアイコン
              // ==================================================

              AnimatedContainer(
                duration:
                    const Duration(
                  milliseconds: 500,
                ),

                width: 84,
                height: 84,

                decoration:
                    BoxDecoration(
                  color:
                      Colors.white10,

                  shape:
                      BoxShape.circle,

                  border:
                      Border.all(
                    color:
                        Colors.white12,
                  ),
                ),

                child:
                    const Icon(
                  Icons.auto_awesome,
                  color:
                      Colors.white,
                  size:
                      38,
                ),
              ),


              const SizedBox(
                height: 20,
              ),


              // ==================================================
              // BIKER AI
              // ==================================================

              const Text(
                "BIKER AI",

                style:
                    TextStyle(
                  color:
                      Colors.white,

                  fontSize:
                      30,

                  fontWeight:
                      FontWeight.bold,

                  letterSpacing:
                      2,
                ),
              ),


              const SizedBox(
                height: 12,
              ),


              // ==================================================
              // 説明
              // ==================================================

              Text(
                errorMessage ??
                    "あなたの理想の一台を\n"
                    "デザインしています",

                textAlign:
                    TextAlign.center,

                style:
                    TextStyle(
                  color:
                      errorMessage != null
                          ? Colors.redAccent
                          : Colors.white70,

                  fontSize:
                      16,

                  height:
                      1.5,
                ),
              ),


              const SizedBox(
                height: 28,
              ),


              // ==================================================
              // プログレスバー
              // ==================================================

              ClipRRect(
                borderRadius:
                    BorderRadius.circular(
                  20,
                ),

                child:
                    LinearProgressIndicator(
                  minHeight:
                      9,

                  value:
                      progress,

                  backgroundColor:
                      Colors.white12,

                  valueColor:
                      const AlwaysStoppedAnimation<
                          Color>(
                    Colors.white,
                  ),
                ),
              ),


              const SizedBox(
                height: 10,
              ),


              // ==================================================
              // パーセント
              // ==================================================

              Text(
                "${(progress * 100).toInt()}%",

                style:
                    const TextStyle(
                  color:
                      Colors.white,

                  fontSize:
                      16,

                  fontWeight:
                      FontWeight.bold,
                ),
              ),


              const SizedBox(
                height: 24,
              ),


              // ==================================================
              // 現在のステップ
              // ==================================================

              AnimatedSwitcher(
                duration:
                    const Duration(
                  milliseconds: 350,
                ),

                child:
                    Text(
                  errorMessage != null
                      ? "生成に失敗しました"
                      : steps[currentStep],

                  key:
                      ValueKey(
                    errorMessage != null
                        ? "error"
                        : currentStep,
                  ),

                  textAlign:
                      TextAlign.center,

                  style:
                      const TextStyle(
                    color:
                        Colors.white,

                    fontSize:
                        17,

                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ),


              const SizedBox(
                height: 22,
              ),


              // ==================================================
              // ステップ一覧
              // ==================================================

              Expanded(
                child:
                    ListView.builder(
                  physics:
                      const NeverScrollableScrollPhysics(),

                  itemCount:
                      steps.length,

                  itemBuilder:
                      (
                    context,
                    index,
                  ) {

                    final bool done =
                        index <
                        currentStep;

                    final bool active =
                        index ==
                        currentStep;

                    return Padding(
                      padding:
                          const EdgeInsets.only(
                        bottom:
                            10,
                      ),

                      child:
                          Row(
                        children: [

                          // ========================================
                          // アイコン
                          // ========================================

                          SizedBox(
                            width:
                                23,

                            child:
                                Icon(
                              done
                                  ? Icons.check_circle
                                  : active
                                      ? Icons
                                          .autorenew
                                      : Icons
                                          .radio_button_unchecked,

                              color:
                                  done
                                      ? Colors
                                          .greenAccent
                                      : active
                                          ? Colors
                                              .white
                                          : Colors
                                              .white24,

                              size:
                                  20,
                            ),
                          ),


                          const SizedBox(
                            width:
                                12,
                          ),


                          // ========================================
                          // テキスト
                          // ========================================

                          Expanded(
                            child:
                                Text(
                              steps[index],

                              style:
                                  TextStyle(
                                color:
                                    done
                                        ? Colors
                                            .greenAccent
                                        : active
                                            ? Colors
                                                .white
                                            : Colors
                                                .white38,

                                fontSize:
                                    14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),


              // ==================================================
              // エラー時
              // ==================================================

              if (errorMessage != null)

                Padding(
                  padding:
                      const EdgeInsets.only(
                    bottom:
                        18,
                  ),

                  child:
                      SizedBox(
                    width:
                        double.infinity,

                    height:
                        50,

                    child:
                        ElevatedButton(
                      onPressed:
                          _startGeneration,

                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.white,

                        foregroundColor:
                            Colors.black,

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            16,
                          ),
                        ),
                      ),

                      child:
                          const Text(
                        "もう一度生成する",

                        style:
                            TextStyle(
                          fontSize:
                              16,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )

              else

                const Padding(
                  padding:
                      EdgeInsets.only(
                    bottom:
                        16,
                  ),

                  child:
                      Text(
                    "あと少しです...",

                    style:
                        TextStyle(
                      color:
                          Colors.white38,

                      fontSize:
                          14,
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
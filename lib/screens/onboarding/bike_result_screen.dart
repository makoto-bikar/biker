import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../home_screen.dart';



class BikeResultScreen extends StatelessWidget {
  final Uint8List imageBytes;

  final String manufacturer;
  final String bike;
  final String year;
  final String style;

  const BikeResultScreen({
    super.key,
    required this.imageBytes,
    required this.manufacturer,
    required this.bike,
    required this.year,
    required this.style,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          Colors.black,

      body: SafeArea(
        child: Column(
          children: [

            // ==================================================
            // ヘッダー
            // ==================================================

            Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                22,
                18,
                22,
                10,
              ),

              child:
                  Row(
                children: [

                  const Expanded(
                    child:
                        Text(
                      "あなたの理想の一台",

                      style:
                          TextStyle(
                        color:
                            Colors.white,

                        fontSize:
                            21,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),

                  const Icon(
                    Icons.auto_awesome,
                    color:
                        Colors.white70,
                    size:
                        22,
                  ),
                ],
              ),
            ),


            // ==================================================
            // スクロール
            // ==================================================

            Expanded(
              child:
                  SingleChildScrollView(
                padding:
                    const EdgeInsets.fromLTRB(
                  22,
                  15,
                  22,
                  30,
                ),

                child:
                    Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    // ============================================
                    // AI画像
                    // ============================================

                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),

                      child:
                          AspectRatio(
                        aspectRatio:
                            1,

                        child:
                            Image.memory(
                          imageBytes,

                          fit:
                              BoxFit.cover,

                          gaplessPlayback:
                              true,
                        ),
                      ),
                    ),


                    const SizedBox(
                      height:
                          24,
                    ),


                    // ============================================
                    // タイトル
                    // ============================================

                    const Text(
                      "あなたの理想のバイク",

                      style:
                          TextStyle(
                        color:
                            Colors.white,

                        fontSize:
                            27,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),


                    const SizedBox(
                      height:
                          10,
                    ),


                    Text(
                      "BIKER AIがあなたのバイクと\n"
                      "目指すスタイルからデザインしました。",

                      style:
                          const TextStyle(
                        color:
                            Colors.white70,

                        fontSize:
                            15,

                        height:
                            1.6,
                      ),
                    ),


                    const SizedBox(
                      height:
                          22,
                    ),


                    // ============================================
                    // バイク情報
                    // ============================================

                    Container(
                      width:
                          double.infinity,

                      padding:
                          const EdgeInsets.all(
                        16,
                      ),

                      decoration:
                          BoxDecoration(
                        color:
                            Colors.white10,

                        borderRadius:
                            BorderRadius.circular(
                          16,
                        ),

                        border:
                            Border.all(
                          color:
                              Colors.white12,
                        ),
                      ),

                      child:
                          Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          Text(
                            "$manufacturer $bike",

                            style:
                                const TextStyle(
                              color:
                                  Colors.white,

                              fontSize:
                                  18,

                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(
                            height:
                                8,
                          ),

                          Text(
                            "$year  •  $style",

                            style:
                                const TextStyle(
                              color:
                                  Colors.white60,

                              fontSize:
                                  14,
                            ),
                          ),
                        ],
                      ),
                    ),


                    const SizedBox(
                      height:
                          28,
                    ),


                    // ============================================
                    // 次のステップ
                    // ============================================

                    const Text(
                      "次は、このバイクに近づけよう。",

                      style:
                          TextStyle(
                        color:
                            Colors.white,

                        fontSize:
                            20,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),


                    const SizedBox(
                      height:
                          10,
                    ),


                    const Text(
                      "現在のバイクから、この理想の一台に\n"
                      "近づくためのカスタムをAIが一緒に考えます。",

                      style:
                          TextStyle(
                        color:
                            Colors.white70,

                        fontSize:
                            14,

                        height:
                            1.6,
                      ),
                    ),


                    const SizedBox(
                      height:
                          22,
                    ),


                    // ============================================
                    // AI相談ボタン
                    // ============================================

                    SizedBox(
                      width:
                          double.infinity,

                      height:
                          56,

                      child:
                          ElevatedButton(
                        onPressed: () {

                          Navigator.pushReplacement(
                            context,

                            MaterialPageRoute(
                              builder: (_) =>
                                  const HomeScreen(
                                startCustomPlan: true,
                             ),
                            ),
                          );
                        },

                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.white,

                          foregroundColor:
                              Colors.black,

                          elevation:
                              0,

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              16,
                            ),
                          ),
                        ),

                        child:
                            const Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,

                          children: [

                            Text(
                              "このバイクに近づける",

                              style:
                                  TextStyle(
                                fontSize:
                                    16,

                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            SizedBox(
                              width:
                                  8,
                            ),

                            Icon(
                              Icons.arrow_forward,
                              size:
                                  19,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
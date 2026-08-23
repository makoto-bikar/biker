import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/questions.dart';
import '../widgets/chat_input.dart';
import '../widgets/question_card.dart';
import '../services/openai_service.dart';
import '../models/chat_message.dart';
import '../services/firestore_service.dart';
import 'garage_screen.dart';
import '../widgets/ai_typing_indicator.dart';
import 'package:bikar/screens/settings_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController controller =
      TextEditingController();

  final ScrollController scrollController =
      ScrollController();

  final FirestoreService firestoreService =
      FirestoreService();

  bool showScrollToBottom = false;
  bool isLoading = false;

  List<String> questions = [];

  List<ChatMessage> messages = [];

  // =========================================================
  // 各メッセージに紐づく商品
  //
  // messages[0] → messageProducts[0]
  // messages[1] → messageProducts[1]
  // messages[2] → messageProducts[2]
  //
  // ユーザー質問 → []
  // AI回答 → そのAI回答の商品
  // =========================================================

  List<List<ProductRecommendation>> messageProducts = [];

  // 現在の会話ID
  String? conversationId;

  @override
  void initState() {
    super.initState();

    // =======================================================
    // スクロール位置監視
    // =======================================================

    scrollController.addListener(() {
      if (!scrollController.hasClients) return;

      final isNotBottom =
          scrollController.position.maxScrollExtent -
                  scrollController.position.pixels >
              100;

      if (isNotBottom != showScrollToBottom) {
        setState(() {
          showScrollToBottom = isNotBottom;
        });
      }
    });

    loadQuestions();
  }

  // =========================================================
  // おすすめ質問を取得
  // =========================================================

  Future<void> loadQuestions() async {
    final user =
        await firestoreService.getLatestUser();

    if (!mounted) return;

    if (user == null) {
      setState(() {
        questions =
            QuestionRepository.maintenanceQuestions;
      });

      return;
    }

    final newQuestions =
        QuestionRepository.getQuestionsForUser(
      manufacturer:
          user["manufacturer"]?.toString() ?? "不明",

      bike:
          user["bike"]?.toString() ?? "不明",

      year:
          user["year"]?.toString() ?? "不明",

      style:
          user["style"]?.toString() ?? "不明",

      experience:
          user["experience"]?.toString() ?? "不明",
    );

    setState(() {
      questions = newQuestions;
    });
  }

  // =========================================================
  // メッセージ送信
  // =========================================================

  Future<void> onSend() async {
    if (controller.text.trim().isEmpty) {
      return;
    }

    final text = controller.text.trim();

    controller.clear();

    // =======================================================
    // 新しい会話を作成
    // =======================================================

    if (conversationId == null) {
      conversationId =
          await firestoreService.createConversation(
        title: text,
      );
    }

    // =======================================================
    // ユーザー質問を表示
    // =======================================================

    setState(() {
      messages.add(
        ChatMessage(
          text: text,
          isUser: true,
        ),
      );

      // ユーザー質問には商品なし
      messageProducts.add([]);
    });

    // =======================================================
    // 初回質問の場合
    //
    // AnimatedSwitcher が
    //
    // こんにちは！
    // 説明文
    // おすすめ
    // 質問カード
    // 初期AIメッセージ
    //
    // を消している時間
    // =======================================================

    if (messages.length == 1) {
      await Future.delayed(
        const Duration(milliseconds: 450),
      );
    }

    if (!mounted) return;

    _scrollToBottom();

    // =======================================================
    // Firestoreにユーザー質問を保存
    // =======================================================

    await firestoreService.saveConversationMessage(
      conversationId: conversationId!,
      text: text,
      isUser: true,
    );

    // =======================================================
    // AI入力中
    // =======================================================

    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    _scrollToBottom();

    // =======================================================
    // AIに質問
    // =======================================================

    final reply =
        await OpenAIService.sendMessage(
      text,
      conversationId: conversationId,
    );

    if (!mounted) return;

    // =======================================================
    // AI回答を表示
    // =======================================================

    setState(() {
      isLoading = false;

      messages.add(
        ChatMessage(
          text: reply.answer,
          isUser: false,
        ),
      );

      // =====================================================
      // このAI回答専用の商品を保存
      // =====================================================

      messageProducts.add(
        List<ProductRecommendation>.from(
          reply.products,
        ),
      );
    });

    _scrollToBottom();

    // =======================================================
    // AI回答＋商品をFirestoreに保存
    // =======================================================

    await firestoreService.saveConversationMessage(
      conversationId: conversationId!,
      text: reply.answer,
      isUser: false,
      products: reply.products.map(
        (product) {
          return {
            "name": product.name,
            "category": product.category,
            "reason": product.reason,
            "searchQuery":
                product.searchQuery,
          };
        },
      ).toList(),
    );
  }

  // =========================================================
  // Amazon検索
  // =========================================================

  Future<void> searchAmazon(
    String searchQuery,
  ) async {
    if (searchQuery.trim().isEmpty) {
      return;
    }

    final encodedQuery =
        Uri.encodeQueryComponent(
      searchQuery.trim(),
    );

    final uri = Uri.parse(
      "https://www.amazon.co.jp/s?k=$encodedQuery",
    );

    try {
      final launched = await launchUrl(
        uri,
        webOnlyWindowName: '_blank',
      );

      if (!launched && mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              "Amazonを開けませんでした",
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Amazonを開けませんでした",
          ),
        ),
      );
    }
  }

  // =========================================================
  // 商品カード
  // =========================================================

  Widget buildProductCard(
    ProductRecommendation product,
  ) {
    return Container(
      width: double.infinity,

      margin: const EdgeInsets.only(
        bottom: 12,
      ),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white10,

        borderRadius:
            BorderRadius.circular(16),

        border: Border.all(
          color: Colors.white12,
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          // ===================================================
          // 商品名
          // ===================================================

          Text(
            product.name,

            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),

          // ===================================================
          // カテゴリ
          // ===================================================

          if (product.category.isNotEmpty) ...[
            const SizedBox(height: 5),

            Text(
              product.category,

              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ],

          // ===================================================
          // おすすめ理由
          // ===================================================

          if (product.reason.isNotEmpty) ...[
            const SizedBox(height: 10),

            Text(
              product.reason,

              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],

          const SizedBox(height: 14),

          // ===================================================
          // Amazonボタン
          // ===================================================

          SizedBox(
            width: double.infinity,

            child: OutlinedButton(
              onPressed: () {
                searchAmazon(
                  product.searchQuery,
                );
              },

              style:
                  OutlinedButton.styleFrom(
                foregroundColor:
                    Colors.white,

                side: const BorderSide(
                  color: Colors.white24,
                ),

                padding:
                    const EdgeInsets.symmetric(
                  vertical: 13,
                ),

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    10,
                  ),
                ),
              ),

              child: const Text(
                "Amazonで検索",
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // 一番下へ移動
  // =========================================================

  void _scrollToBottom() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      if (!scrollController.hasClients) {
        return;
      }

      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration:
            const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();

    super.dispose();
  }

  // =========================================================
  // 画面
  // =========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      // =======================================================
      // Drawer
      // =======================================================

      drawer: Drawer(
        backgroundColor: Colors.black,

        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.all(24),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                const SizedBox(height: 20),

                const Text(
                  "BIKER",

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 50),

                // =================================================
                // 履歴
                // =================================================

                ListTile(
                  leading: const Icon(
                    Icons.history,
                    color: Colors.white,
                  ),

                  title: const Text(
                    "履歴",

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const HistoryScreen(),
                      ),
                    );
                  },
                ),

                // =================================================
                // 設定
                // =================================================

                ListTile(
                  leading: const Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),

                  title: const Text(
                    "設定",

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const SettingsScreen(),
                      ),
                    );
                  },
                ),

                // =================================================
                // BIKERについて
                // =================================================

                ListTile(
                  leading: const Icon(
                    Icons.info_outline,
                    color: Colors.white,
                  ),

                  title: const Text(
                    "BIKERについて",

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),

                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),

      // =======================================================
      // Body
      // =======================================================

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 22,
                    ),

                    child: ListView(
                      controller:
                          scrollController,

                      children: [
                        const SizedBox(
                          height: 12,
                        ),

                        // =================================================
                        // ヘッダー
                        // =================================================

                        Row(
  children: [
    // ===============================
    // 左：メニューボタン
    // ===============================

    Builder(
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child: const Icon(
            Icons.menu,
            color: Colors.white,
            size: 28,
          ),
        );
      },
    ),

    // ===============================
    // 中央：BIKER AI
    // ===============================

    const Expanded(
      child: Center(
        child: Text(
          "BIKER AI",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),

    // ===============================
    // 右：プロフィール
    // ===============================

    GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const GarageScreen(),
          ),
        );
      },
      child: const CircleAvatar(
        radius: 18,
        backgroundColor: Colors.white12,
        child: Icon(
          Icons.person,
          color: Colors.white,
          size: 20,
        ),
      ),
    ),
  ],
),

                        const SizedBox(
                          height: 5,
                        ),

                        

                        const SizedBox(
                          height: 25,
                        ),

                        // =================================================
                        // 初期ホーム画面
                        //
                        // ここが今回の重要ポイント
                        //
                        // messages.isEmpty
                        //
                        // ↓
                        //
                        // 初期画面を表示
                        //
                        // ↓
                        //
                        // 質問送信
                        //
                        // ↓
                        //
                        // messages.isEmpty == false
                        //
                        // ↓
                        //
                        // AnimatedSwitcherが
                        // 初期画面をアニメーションで消す
                        // =================================================

                        AnimatedSwitcher(
                          duration:
                              const Duration(
                            milliseconds: 450,
                          ),

                          reverseDuration:
                              const Duration(
                            milliseconds: 350,
                          ),

                          transitionBuilder:
                              (
                            child,
                            animation,
                          ) {
                            return FadeTransition(
                              opacity:
                                  animation,

                              child:
                                  SizeTransition(
                                sizeFactor:
                                    animation,

                                axisAlignment:
                                    -1.0,

                                child: child,
                              ),
                            );
                          },

                          child: messages.isEmpty
                              ? Column(
                                  key: const ValueKey(
                                    "welcome",
                                  ),

                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

                                  children: [
                                    // =================================================
                                    // こんにちは
                                    // =================================================

                                    const Text(
                                      "こんにちは！",

                                      style:
                                          TextStyle(
                                        color:
                                            Colors
                                                .white,

                                        fontSize:
                                            30,

                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 10,
                                    ),

                                    // =================================================
                                    // 説明文
                                    // =================================================

                                    const Text(
                                      "初めてのカスタムでも安心。\n\n"
                                      "BIKER AIがあなたに合った\n"
                                      "カスタムを一緒に考えます。",

                                      style:
                                          TextStyle(
                                        color:
                                            Colors
                                                .white70,

                                        fontSize:
                                            18,

                                        height:
                                            1.6,
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 35,
                                    ),

                                    // =================================================
                                    // おすすめ
                                    // =================================================

                                    const Text(
                                      "おすすめ",

                                      style:
                                          TextStyle(
                                        color:
                                            Colors
                                                .white,

                                        fontSize:
                                            18,

                                        fontWeight:
                                            FontWeight
                                                .w600,
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 20,
                                    ),

                                    // =================================================
                                    // おすすめ質問カード
                                    // =================================================

                                    ...questions.map(
                            (q) =>
                                          QuestionCard(
                                        text: q,

                                        onTap:
                                            () async {
                                          controller
                                              .text = q;

                                          await onSend();
                                        },
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 30,
                                    ),

                                    // =================================================
                                    // AI初期メッセージ
                                    // =================================================

                                    Container(
                                      padding:
                                          const EdgeInsets
                                              .all(
                                        18,
                                      ),

                                      decoration:
                                          BoxDecoration(
                                        color:
                                            Colors
                                                .white10,

                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                          18,
                                        ),
                                      ),

                                      child:
                                          const Text(
                                        "🤖 こんにちは！BIKER AIです。\n"
                                        "何でも聞いてください！",

                                        style:
                                            TextStyle(
                                          color:
                                              Colors
                                                  .white,

                                          fontSize:
                                              16,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                )
                              : const SizedBox(
                                  key: ValueKey(
                                    "conversationStarted",
                                  ),
                                ),
                        ),

                        // =================================================
                        // チャット履歴
                        // =================================================

                        ...List.generate(
                          messages.length,
                          (index) {
                            final message =
                                messages[index];

                            // =================================================
                            // このメッセージ専用の商品
                            // =================================================

                            final products =
                                index <
                                        messageProducts
                                            .length
                                    ? messageProducts[
                                        index]
                                    : <ProductRecommendation>[];

                            return Container(
                              margin:
                                  const EdgeInsets
                                      .only(
                                bottom: 12,
                              ),

                              alignment:
                                  message.isUser
                                      ? Alignment
                                          .centerRight
                                      : Alignment
                                          .centerLeft,

                              child:
                                  Container(
                                padding:
                                    const EdgeInsets
                                        .all(
                                  16,
                                ),

                                constraints: BoxConstraints(
                                maxWidth: message.isUser
                                 ? MediaQuery.of(context).size.width * 0.60
                                 : MediaQuery.of(context).size.width * 0.70,
                              ),

                                decoration:
                                    BoxDecoration(
                                  color: message
                                          .isUser
                                      ? Colors.white
                                      : Colors
                                          .white10,

                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                            18,
                                  ),
                                ),

                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

                                  children: [
                                    // =================================================
                                    // メッセージ本文
                                    // ===========

                                    Text(
                                      message.text,

                                      style:
                                          TextStyle(
                                        color: message
                                                .isUser
                                            ? Colors
                                                .black
                                            : Colors
                                                .white,

                                        fontSize: 15,

                                        height: 1.5,
                                      ),
                                    ),

                                    // =================================================
                                    // AI回答専用の商品
                                    // =================================================

                                    if (!message.isUser &&
                                        products
                                            .isNotEmpty) ...[
                                      const SizedBox(
                                        height: 18,
                                      ),

                                      const Text(
                                        "おすすめ商品",

                                        style:
                                            TextStyle(
                                          color:
                                              Colors
                                                  .white,

                                          fontSize:
                                              16,

                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 12,
                                      ),

                                      ...products.map(
                                        (product) =>
                                            buildProductCard(
                                          product,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        // =================================================
                        // AI入力中
                        // =================================================

                        if (isLoading)
                          const AiTypingIndicator(),

                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),

                  // =========================================================
                  // 下まで移動ボタン
                  // =========================================================

                  if (showScrollToBottom)
                    Positioned(
                      right: 20,
                      bottom: 20,

                      child: GestureDetector(
                        onTap:
                            _scrollToBottom,

                        child: Container(
                          width: 44,
                          height: 44,

                          decoration:
                              const BoxDecoration(
                            color:
                                Colors.white12,

                            shape:
                                BoxShape.circle,
                          ),

                          child: const Icon(
                            Icons
                                .keyboard_arrow_down,

                            color:
                                Colors.white,

                            size: 28,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // =======================================================
            // チャット入力欄
            // =======================================================

            ChatInput(
              controller: controller,
              onSend: onSend,
            ),
          ],
        ),
      ),
    );
  }
}
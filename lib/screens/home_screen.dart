import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/questions.dart';
import '../widgets/chat_input.dart';

import '../services/openai_service.dart';
import '../models/chat_message.dart';
import '../services/firestore_service.dart';

import '../widgets/ai_typing_indicator.dart';
import 'settings_screen.dart';
import 'history_screen.dart';
import '../services/custom_plan_service.dart';
import '../widgets/home/home_header.dart';


import '../widgets/home/chat_message_item.dart';
import '../widgets/home/welcome_section.dart';


class HomeScreen extends StatefulWidget {

  final bool startCustomPlan;

  const HomeScreen({
    super.key,
    this.startCustomPlan = false,
  });

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}


class _HomeScreenState
    extends State<HomeScreen> {

  // =========================================================
  // Controllers
  // =========================================================

  final TextEditingController controller =
      TextEditingController();

  final ScrollController scrollController =
      ScrollController();


  // =========================================================
  // Services
  // =========================================================

  final FirestoreService firestoreService =
      FirestoreService();


  // =========================================================
  // State
  // =========================================================

  bool showScrollToBottom = false;

  bool isLoading = false;

  bool customPlanStarted = false;


  List<String> questions = [];

  List<ChatMessage> messages = [];


  // メッセージごとの商品
  List<List<ProductRecommendation>>
      messageProducts = [];


  // メッセージごとのCustom Plan
  List<CustomPlan?>
      messageCustomPlans = [];


  // =========================================================
  // Conversation
  // =========================================================

  String? conversationId;


  // =========================================================
  // Init
  // =========================================================

  @override
  void initState() {

    super.initState();


    // =======================================================
    // Scroll監視
    // =======================================================

    scrollController.addListener(() {

      if (!scrollController.hasClients) {
        return;
      }


      final isNotBottom =
          scrollController.position.maxScrollExtent -
                  scrollController.position.pixels >
              100;


      if (isNotBottom !=
          showScrollToBottom) {

        setState(() {

          showScrollToBottom =
              isNotBottom;

        });
      }
    });


    // =======================================================
    // おすすめ質問
    // =======================================================

    loadQuestions();


    // =======================================================
    // Custom Plan自動開始
    // =======================================================

    if (widget.startCustomPlan) {

      WidgetsBinding.instance
          .addPostFrameCallback((_) {

        _startCustomPlan();

      });
    }
  }


  // =========================================================
  // おすすめ質問取得
  // =========================================================

  Future<void> loadQuestions() async {

    final user =
        await firestoreService
            .getLatestUser();


    if (!mounted) {
      return;
    }


    if (user == null) {

      setState(() {

        questions =
            QuestionRepository
                .maintenanceQuestions;

      });

      return;
    }


    final newQuestions =
        QuestionRepository
            .getQuestionsForUser(

      manufacturer:
          user["manufacturer"]
                  ?.toString() ??
              "不明",

      bike:
          user["bike"]
                  ?.toString() ??
              "不明",

      year:
          user["year"]
                  ?.toString() ??
              "不明",

      style:
          user["style"]
                  ?.toString() ??
              "不明",

      experience:
          user["experience"]
                  ?.toString() ??
              "不明",
    );


    setState(() {

      questions =
          newQuestions;

    });
  }


  // =========================================================
  // Custom Plan開始
  //
  // ここではプロンプトを作らない。
  // CustomPlanServiceに完全に任せる。
  // =========================================================

  Future<void> _startCustomPlan() async {

    // 二重実行防止
    if (customPlanStarted) {
      return;
    }


    customPlanStarted = true;


    if (!mounted) {
      return;
    }


    setState(() {

      isLoading = true;

    });


    try {

      // =====================================================
      // 新しい会話を作成
      // =====================================================

      conversationId =
          await firestoreService
              .createConversation(

        title:
            "理想の一台に近づくカスタム",

      );


      // =====================================================
      // CustomPlanService
      // =====================================================

      final reply =
          await CustomPlanService
              .generatePlan(

        conversationId:
            conversationId,

      );


      if (!mounted) {
        return;
      }


      // =====================================================
      // AI回答を表示
      // =====================================================

      setState(() {

        isLoading = false;


        messages.add(

          ChatMessage(

            text:
                reply.answer,

            isUser:
                false,

          ),

        );


        messageProducts.add(

          List<ProductRecommendation>
              .from(
            reply.products,
          ),

        );


        messageCustomPlans.add(

          reply.customPlan,

        );

      });


      // =====================================================
      // Firestore保存
      // =====================================================

      await firestoreService
          .saveConversationMessage(

        conversationId:
            conversationId!,

        text:
            reply.answer,

        isUser:
            false,

        products:
            reply.products.map(

          (product) {

            return {

              "name":
                  product.name,

              "category":
                  product.category,

              "reason":
                  product.reason,

              "searchQuery":
                  product.searchQuery,

            };

          },

        ).toList(),

      );


      // =====================================================
      // 一番下へ
      // =====================================================

      _scrollToBottom();


    } catch (e) {

      print(
        "Custom Plan error: $e",
      );


      if (!mounted) {
        return;
      }


      setState(() {

        isLoading = false;

      });


      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            "カスタムプランの生成に失敗しました。",
          ),

        ),

      );
    }
  }


  // =========================================================
  // 通常メッセージ送信
  // =========================================================

  Future<void> onSend() async {

    // 空文字
    if (controller.text
        .trim()
        .isEmpty) {

      return;
    }


    final text =
        controller.text.trim();


    // 入力欄クリア
    controller.clear();


    // =======================================================
    // 会話作成
    // =======================================================

    if (conversationId == null) {

      conversationId =
          await firestoreService
              .createConversation(

        title:
            text,

      );
    }


    // =======================================================
    // ユーザー質問を表示
    // =======================================================

    setState(() {

      messages.add(

        ChatMessage(

          text:
              text,

          isUser:
              true,

        ),

      );


      // ユーザー質問には商品なし
      messageProducts.add([]);


      // ユーザー質問にはCustom Planなし
      messageCustomPlans.add(null);

    });


    // =======================================================
    // 初回アニメーション
    // =======================================================

    if (messages.length == 1) {

      await Future.delayed(

        const Duration(
          milliseconds: 450,
        ),

      );
    }


    if (!mounted) {
      return;
    }


    _scrollToBottom();


    // =======================================================
    // Firestore保存
    // =======================================================

    await firestoreService
        .saveConversationMessage(

      conversationId:
          conversationId!,

      text:
          text,

      isUser:
          true,

    );


    if (!mounted) {
      return;
    }


    // =======================================================
    // AI入力中
    // =======================================================

    setState(() {

      isLoading = true;

    });


    _scrollToBottom();


    // =======================================================
    // 通常AI
    // =======================================================

    final reply =
        await OpenAIService
            .sendMessage(

      text,

      conversationId:
          conversationId,

    );


    if (!mounted) {
      return;
    }


    // =======================================================
    // AI回答表示
    // =======================================================

    setState(() {

      isLoading = false;


      messages.add(

        ChatMessage(

          text:
              reply.answer,

          isUser:
              false,

        ),

      );


      messageProducts.add(

        List<ProductRecommendation>
            .from(
          reply.products,
        ),

      );


      // 通常チャットではCustom Planなし
      messageCustomPlans.add(null);

    });


    _scrollToBottom();


    // =======================================================
    // Firestore保存
    // =======================================================

    await firestoreService
        .saveConversationMessage(

      conversationId:
          conversationId!,

      text:
          reply.answer,

      isUser:
          false,

      products:
          reply.products.map(

        (product) {

          return {

            "name":
                product.name,

            "category":
                product.category,

            "reason":
                product.reason,

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

    if (searchQuery
        .trim()
        .isEmpty) {

      return;
    }


    final encodedQuery =
        Uri.encodeQueryComponent(
      searchQuery.trim(),
    );


    final uri =
        Uri.parse(
      "https://www.amazon.co.jp/s?k=$encodedQuery",
    );


    try {

      final launched =
          await launchUrl(

        uri,

        webOnlyWindowName:
            '_blank',

      );


      if (
        !launched &&
        mounted
      ) {

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

      if (!mounted) {
        return;
      }


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
  // Scroll
  // =========================================================

  void _scrollToBottom() {

    WidgetsBinding.instance
        .addPostFrameCallback((_) {

      if (!scrollController.hasClients) {
        return;
      }


      scrollController.animateTo(

        scrollController.position
            .maxScrollExtent,

        duration:
            const Duration(
          milliseconds: 350,
        ),

        curve:
            Curves.easeOut,

      );
    });
  }


  // =========================================================
  // Dispose
  // =========================================================

  @override
  void dispose() {

    controller.dispose();

    scrollController.dispose();

    super.dispose();
  }


  // =========================================================
  // Build
  // =========================================================

  @override
  Widget build(
    BuildContext context,
  ) {

    final bool showWelcome =
        messages.isEmpty &&
        !widget.startCustomPlan;


    return Scaffold(

      backgroundColor:
          Colors.black,


      // =======================================================
      // Drawer
      // =======================================================

      drawer:
          Drawer(

        backgroundColor:
            Colors.black,

        child:
            SafeArea(

          child:
              Padding(

            padding:
                const EdgeInsets.symmetric(
              horizontal: 20,
            ),

            child:
                Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                const SizedBox(
                  height: 20,
                ),


                const Padding(

                  padding:
                      EdgeInsets.symmetric(
                    horizontal: 12,
                  ),

                  child:
                      Text(

                    "BIKER",

                    style:
                        TextStyle(

                      color:
                          Colors.white,

                      fontSize:
                          26,

                      fontWeight:
                          FontWeight.bold,

                    ),
                  ),
                ),


                const SizedBox(
                  height: 40,
                ),


                ListTile(

                  contentPadding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 12,
                  ),

                  leading:
                      const Icon(
                    Icons.history,
                    color: Colors.white,
                  ),

                  title:
                      const Text(

                    "履歴",

                    style:
                        TextStyle(

                      color:
                          Colors.white,

                      fontSize:
                          16,

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


                ListTile(

                  contentPadding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 12,
                  ),

                  leading:
                      const Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),

                  title:
                      const Text(

                    "設定",

                    style:
                        TextStyle(

                      color:
                          Colors.white,

                      fontSize:
                          16,

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


                ListTile(

                  contentPadding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 12,
                  ),

                  leading:
                      const Icon(
                    Icons.info_outline,
                    color: Colors.white,
                  ),

                  title:
                      const Text(

                    "BIKERについて",

                    style:
                        TextStyle(

                      color:
                          Colors.white,

                      fontSize:
                          16,

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

      body:
          SafeArea(

        child:
            Column(

          children: [

            Expanded(

              child:
                  Stack(

                children: [

                  Padding(

                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),

                    child:
                        ListView(

                      controller:
                          scrollController,

                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior
                              .onDrag,

                      children: [

                        const SizedBox(
                          height: 8,
                        ),


                        const HomeHeader(),


                        const SizedBox(
                          height: 80,
                        ),


                        AnimatedSwitcher(
  duration: const Duration(
    milliseconds: 450,
  ),

  reverseDuration: const Duration(
    milliseconds: 350,
  ),

  transitionBuilder: (
    child,
    animation,
  ) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        axisAlignment: -1.0,
        child: child,
      ),
    );
  },

  child: showWelcome
      ? WelcomeSection(
          key: const ValueKey(
            "welcome",
          ),
          questions: questions,
          onQuestionTap: (question) async {
            controller.text = question;
            await onSend();
          },
        )
      : const SizedBox(
          key: ValueKey(
            "conversationStarted",
          ),
        ),
),


                        // =======================================
// Messages
// =======================================

...List.generate(
  messages.length,
  (index) {
    final message = messages[index];

    final products =
        index < messageProducts.length
            ? messageProducts[index]
            : <ProductRecommendation>[];

    final customPlan =
        index < messageCustomPlans.length
            ? messageCustomPlans[index]
            : null;

    return ChatMessageItem(
      message: message,
      products: products,
      customPlan: customPlan,
      onAmazonSearch: searchAmazon,
    );
  },
),


                        // =======================================
                        // AI入力中
                        // =======================================

                        if (isLoading)

                          const AiTypingIndicator(),


                        const SizedBox(
                          height: 24,
                        ),
                      ],
                    ),
                  ),


                  // =============================================
                  // 下まで移動
                  // =============================================

                  if (showScrollToBottom)

                    Positioned(

                      right:
                          12,

                      bottom:
                          16,

                      child:
                          GestureDetector(

                        onTap:
                            _scrollToBottom,

                        child:
                            Container(

                          width:
                              40,

                          height:
                              40,

                          decoration:
                              const BoxDecoration(

                            color:
                                Colors.white12,

                            shape:
                                BoxShape.circle,

                          ),

                          child:
                              const Icon(

                            Icons.keyboard_arrow_down,

                            color:
                                Colors.white,

                            size:
                                24,

                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),


            // ===================================================
            // Chat Input
            // ===================================================

            ChatInput(

              controller:
                  controller,

              onSend:
                  onSend,

            ),
          ],
        ),
      ),
    );
  }
}
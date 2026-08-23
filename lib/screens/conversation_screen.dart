import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/firestore_service.dart';
import '../services/openai_service.dart';
import '../widgets/chat_input.dart';
import '../widgets/ai_typing_indicator.dart';

class ConversationScreen extends StatefulWidget {
  final String conversationId;
  final String title;

  const ConversationScreen({
    super.key,
    required this.conversationId,
    required this.title,
  });

  @override
  State<ConversationScreen> createState() =>
      _ConversationScreenState();
}

class _ConversationScreenState
    extends State<ConversationScreen> {
  final FirestoreService firestoreService =
      FirestoreService();

  final TextEditingController controller =
      TextEditingController();

  final ScrollController scrollController =
      ScrollController();

  List<Map<String, dynamic>> messages = [];

  bool isLoading = true;
  bool isSending = false;

  @override
  void initState() {
    super.initState();
    loadMessages();
  }

  // =========================================================
  // 会話を読み込む
  // =========================================================

  Future<void> loadMessages() async {
    try {
      final data =
          await firestoreService.getConversationMessages(
        widget.conversationId,
      );

      if (!mounted) return;

      setState(() {
        messages = data;
        isLoading = false;
      });

      Future.delayed(
        const Duration(milliseconds: 100),
        _scrollToBottom,
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "会話の読み込みに失敗しました: $e",
          ),
        ),
      );
    }
  }

  // =========================================================
  // メッセージ送信
  // =========================================================

  Future<void> onSend() async {
    if (controller.text.trim().isEmpty) {
      return;
    }

    if (isSending) {
      return;
    }

    final text = controller.text.trim();

    controller.clear();

    // =======================================================
    // ユーザーの質問を画面に追加
    // =======================================================

    setState(() {
      messages.add({
        "text": text,
        "isUser": true,
        "products": [],
      });

      isSending = true;
    });

    _scrollToBottom();

    try {
      // =====================================================
      // AIに質問
      // =====================================================

      final reply =
          await OpenAIService.sendMessage(
        text,
        conversationId: widget.conversationId,
      );

      if (!mounted) return;

      // =====================================================
      // AIの商品情報をMapに変換
      // =====================================================

      final products =
          reply.products.map((product) {
        return {
          "name": product.name,
          "category": product.category,
          "reason": product.reason,
          "searchQuery": product.searchQuery,
        };
      }).toList();

      // =====================================================
      // AIの回答を画面に追加
      // =====================================================

      setState(() {
        messages.add({
          "text": reply.answer,
          "isUser": false,
          "products": products,
        });

        isSending = false;
      });

      _scrollToBottom();

      // =====================================================
      // ユーザーの質問をFirestoreに保存
      // =====================================================

      await firestoreService.saveConversationMessage(
        conversationId: widget.conversationId,
        text: text,
        isUser: true,
        products: [],
      );

      // =====================================================
      // AI回答 + 商品をFirestoreに保存
      // =====================================================

      await firestoreService.saveConversationMessage(
        conversationId: widget.conversationId,
        text: reply.answer,
        isUser: false,
        products: products,
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSending = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "送信に失敗しました: $e",
          ),
        ),
      );
    }
  }

  // =========================================================
  // Amazonを開く
  // =========================================================

  Future<void> _openAmazon(
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
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: "_blank",
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Amazonを開けませんでした: $e",
          ),
        ),
      );
    }
  }

  // =========================================================
  // 一番下へ移動
  // =========================================================

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) {
        return;
      }

      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration:
            const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  // =========================================================
  // 商品カード
  // =========================================================

  Widget _buildProductCard(
    Map<String, dynamic> product,
  ) {
    final name =
        product["name"]?.toString() ?? "";

    final category =
        product["category"]?.toString() ?? "";

    final reason =
        product["reason"]?.toString() ?? "";

    final searchQuery =
        product["searchQuery"]?.toString() ?? "";

    return Container(
      width: double.infinity,

      margin: const EdgeInsets.only(
        top: 10,
      ),

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.white10,

        borderRadius:
            BorderRadius.circular(12),

        border: Border.all(
          color: Colors.white24,
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          // =================================================
          // 商品名
          // =================================================

          Text(
            name,

            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),

          // =================================================
          // カテゴリ
          // =================================================

          if (category.isNotEmpty) ...[
            const SizedBox(height: 4),

            Text(
              category,

              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ],

          // =================================================
          // おすすめ理由
          // =================================================

          if (reason.isNotEmpty) ...[
            const SizedBox(height: 8),

            Text(
              reason,

              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ],

          // =================================================
          // Amazonボタン
          // =================================================

          if (searchQuery.isNotEmpty) ...[
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: () {
                  _openAmazon(searchQuery);
                },

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.white,

                  foregroundColor:
                      Colors.black,

                  elevation: 0,

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
                  style: TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // =========================================================
  // メッセージWidget
  // =========================================================

  Widget _buildMessage(
    Map<String, dynamic> message,
  ) {
    final text =
        message["text"]?.toString() ?? "";

    final isUser =
        message["isUser"] == true;

    // =======================================================
    // 商品データを取得
    // =======================================================

    final productData =
        message["products"];

    List<dynamic> products = [];

    if (productData is List) {
      products = productData;
    }

    return Align(
      alignment: isUser
          ? Alignment.centerRight
          : Alignment.centerLeft,

      child: Container(
        margin:
            const EdgeInsets.only(
          bottom: 12,
        ),

        padding:
            const EdgeInsets.all(16),

        constraints: BoxConstraints(
         maxWidth: isUser
                ? MediaQuery.of(context).size.width * 0.60
                : MediaQuery.of(context).size.width * 0.70,
        ),

        decoration:
            BoxDecoration(
          color: isUser
              ? Colors.white
              : Colors.white10,

          borderRadius:
              BorderRadius.circular(
            18,
          ),
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            // =================================================
            // メッセージ本文
            // =================================================

            Text(
              text,

              style: TextStyle(
                color: isUser
                    ? Colors.black
                    : Colors.white,

                fontSize: 15,

                height: 1.5,
              ),
            ),

            // =================================================
            // おすすめ商品
            // =================================================

            if (!isUser &&
                products.isNotEmpty) ...[
              const SizedBox(
                height: 18,
              ),

              const Text(
                "おすすめ商品",

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 4,
              ),

              ...products.map(
                (product) {
                  if (product
                      is! Map) {
                    return const SizedBox();
                  }

                  final productMap =
                      Map<String, dynamic>.from(
                    product,
                  );

                  return _buildProductCard(
                    productMap,
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  // =========================================================
  // 画面
  // =========================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: Colors.black,

      // =====================================================
      // AppBar
      // =====================================================

      appBar: AppBar(
        backgroundColor:
            Colors.black,

        foregroundColor:
            Colors.white,

        title: Text(
          widget.title,

          maxLines: 1,

          overflow:
              TextOverflow.ellipsis,

          style: const TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      // =====================================================
      // Body
      // =====================================================

      body: SafeArea(
        child: Column(
          children: [
            // =================================================
            // メッセージ一覧
            // =================================================

            Expanded(
              child: isLoading
                  ? const Center(
                      child:
                          CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : ListView.builder(
                      controller:
                          scrollController,

                      padding:
                          const EdgeInsets.all(
                        20,
                      ),

                      itemCount:
                          messages.length +
                              (isSending
                                  ? 1
                                  : 0),

                      itemBuilder:
                          (
                        context,
                        index,
                      ) {
                        // =====================================
                        // AI入力中
                        // =====================================

                        if (isSending &&
                            index ==
                                messages.length) {
                          return const
                              AiTypingIndicator();
                        }

                        // =====================================
                        // メッセージ
                        // =====================================

                        final message =
                            messages[index];

                        return _buildMessage(
                          message,
                        );
                      },
                    ),
            ),

            // =================================================
            // 入力欄
            // =================================================

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

  // =========================================================
  // dispose
  // =========================================================

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();

    super.dispose();
  }
}
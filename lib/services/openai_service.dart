import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'firestore_service.dart';
import '../prompts/system_prompt.dart';

// ============================================================
// 商品 / パーツ / 工具
// ============================================================

class ProductRecommendation {
  final String name;
  final String category;
  final String reason;
  final String searchQuery;

  ProductRecommendation({
    required this.name,
    required this.category,
    required this.reason,
    required this.searchQuery,
  });

  factory ProductRecommendation.fromJson(
    Map<String, dynamic> json,
  ) {
    return ProductRecommendation(
      name: json["name"]?.toString() ?? "",
      category: json["category"]?.toString() ?? "",
      reason: json["reason"]?.toString() ?? "",
      searchQuery: json["searchQuery"]?.toString() ?? "",
    );
  }
}

// ============================================================
// AIレスポンス
//
// 通常チャット専用
// ============================================================

class AIResponse {
  final String answer;
  final List<ProductRecommendation> products;

  AIResponse({
    required this.answer,
    required this.products,
  });
}

// ============================================================
// OpenAI Service
//
// 通常チャット専用
//
// Knowledgeの取得自体は
// SystemPrompt
// ↓
// KnowledgeRouter
// ↓
// KnowledgeService
//
// に任せる。
//
// OpenAIServiceは、
// 「ユーザー質問をSystemPromptへ渡す」
// ところまで担当する。
// ============================================================

class OpenAIService {
  // ==========================================================
  // APIキー
  // ==========================================================

  static String? _getApiKey() {
    final apiKey = dotenv.env["OPENAI_API_KEY"];

    if (apiKey == null || apiKey.isEmpty) {
      return null;
    }

    return apiKey;
  }

  // ==========================================================
  // Garage情報
  // ==========================================================

  static Future<Map<String, String>> _getGarageInfo() async {
    final firestore = FirestoreService();

    final user = await firestore.getLatestUser();

    return {
      "manufacturer":
          user?["manufacturer"]?.toString() ?? "不明",

      "bike":
          user?["bike"]?.toString() ?? "不明",

      "year":
          user?["year"]?.toString() ?? "不明",

      "style":
          user?["style"]?.toString() ?? "不明",

      "experience":
          user?["experience"]?.toString() ?? "不明",
    };
  }

  // ==========================================================
  // 通常チャット
  // ==========================================================

  static Future<AIResponse> sendMessage(
    String message, {
    String? conversationId,
  }) async {
    // ========================================================
    // 質問チェック
    // ========================================================

    final trimmedMessage = message.trim();

    if (trimmedMessage.isEmpty) {
      return AIResponse(
        answer: "質問を入力してください。",
        products: [],
      );
    }

    // ========================================================
    // APIキー
    // ========================================================

    final apiKey = _getApiKey();

    if (apiKey == null) {
      return AIResponse(
        answer: "APIキーが設定されていません。",
        products: [],
      );
    }

    // ========================================================
    // Firestore
    // ========================================================

    final firestore = FirestoreService();

    // ========================================================
    // Garage情報
    // ========================================================

    late Map<String, String> garage;

    try {
      garage = await _getGarageInfo();
    } catch (e) {
      print("Garage info error: $e");

      // Garage取得に失敗しても、
      // AIチャット自体は止めない。
      garage = {
        "manufacturer": "不明",
        "bike": "不明",
        "year": "不明",
        "style": "不明",
        "experience": "不明",
      };
    }

    final manufacturer =
        garage["manufacturer"] ?? "不明";

    final bike =
        garage["bike"] ?? "不明";

    final year =
        garage["year"] ?? "不明";

    final style =
        garage["style"] ?? "不明";

    final experience =
        garage["experience"] ?? "不明";

    // ========================================================
    // Messages
    // ========================================================

    final List<Map<String, String>> messages = [];

    // ========================================================
    // SYSTEM PROMPT
    //
    // ここが今回の重要ポイント。
    //
    // questionをSystemPromptへ渡す。
    //
    // SystemPrompt内部で、
    //
    // question
    // ↓
    // KnowledgeRouter
    // ↓
    // KnowledgeService
    // ↓
    // 必要なKnowledgeだけ取得
    //
    // という処理を行う。
    // ========================================================

    try {
      final systemPrompt = await SystemPrompt.build(
        manufacturer: manufacturer,
        bike: bike,
        year: year,
        style: style,
        experience: experience,
        customPlanMode: false,
        question: trimmedMessage,
      );

      messages.add({
        "role": "system",
        "content": systemPrompt,
      });
    } catch (e) {
      print("SystemPrompt / Knowledge error: $e");

      return AIResponse(
        answer:
            "AIのKnowledgeを読み込めませんでした。\n"
            "Knowledge設定を確認してください。",
        products: [],
      );
    }

    // ========================================================
    // 会話履歴
    // ========================================================

    if (conversationId != null) {
      try {
        final history =
            await firestore.getConversationMessages(
          conversationId,
        );

        // ----------------------------------------------------
        // 最新20件だけ使用
        // ----------------------------------------------------

        final recentHistory =
            history.length > 20
                ? history.sublist(
                    history.length - 20,
                  )
                : history;

        bool skippedCurrentMessage = false;

        // ----------------------------------------------------
        // 古い → 新しい順
        // ----------------------------------------------------

        for (
          int i = 0;
          i < recentHistory.length;
          i++
        ) {
          final chat = recentHistory[i];

          final chatText =
              chat["text"]?.toString() ?? "";

          if (chatText.trim().isEmpty) {
            continue;
          }

          final isUser =
              chat["isUser"] == true;

          // --------------------------------------------------
          // 今回送信した質問が
          // Firestoreにすでに保存されている場合、
          // 二重送信しない。
          // --------------------------------------------------

          if (
            !skippedCurrentMessage &&
            isUser &&
            chatText.trim() ==
                trimmedMessage
          ) {
            skippedCurrentMessage = true;
            continue;
          }

          messages.add({
            "role":
                isUser
                    ? "user"
                    : "assistant",
            "content": chatText,
          });
        }
      } catch (e) {
        print("Conversation history error: $e");

        // 会話履歴の取得に失敗しても、
        // 今回の質問だけでAIに送信する。
      }
    }

    // ========================================================
    // 今回の質問
    // ========================================================

    messages.add({
      "role": "user",
      "content": trimmedMessage,
    });

    // ========================================================
    // OpenAI API
    // ========================================================

    try {
      final response = await http
          .post(
            Uri.parse(
              "https://api.openai.com/v1/chat/completions",
            ),
            headers: {
              "Authorization":
                  "Bearer $apiKey",
              "Content-Type":
                  "application/json",
            },
            body: jsonEncode({
              // ------------------------------------------------
              // モデル
              // ------------------------------------------------

              "model": "gpt-4.1-mini",

              // ------------------------------------------------
              // Messages
              // ------------------------------------------------

              "messages": messages,

              // ------------------------------------------------
              // JSON出力
              // ------------------------------------------------
              //
              // ResponsePromptで
              // JSONだけを返すよう指定している。
              //
              // ------------------------------------------------

              "response_format": {
                "type": "json_object",
              },

              // ------------------------------------------------
              // 温度
              // ------------------------------------------------

              "temperature": 0.7,

              // ------------------------------------------------
              // 最大出力トークン
              // ------------------------------------------------

              "max_tokens": 2500,
            }),
          )
          .timeout(
            const Duration(seconds: 60),
          );

      // ========================================================
      // HTTP成功
      // ========================================================

      if (response.statusCode == 200) {
        final data = jsonDecode(
          response.body,
        );

        // ======================================================
        // APIレスポンスからcontent取得
        // ======================================================

        final content =
            data["choices"]?[0]?["message"]?["content"]
                ?.toString()
                .trim() ??
            "";

        // ======================================================
        // contentが空
        // ======================================================

        if (content.isEmpty) {
          return AIResponse(
            answer:
                "AIから回答を取得できませんでした。",
            products: [],
          );
        }

        // ======================================================
        // JSON解析
        // ======================================================

        try {
          final dynamic decoded =
              jsonDecode(content);

          if (decoded is! Map) {
            return AIResponse(
              answer:
                  "AIの回答形式を確認できませんでした。",
              products: [],
            );
          }

          final json =
              Map<String, dynamic>.from(
            decoded,
          );

          // ====================================================
          // 回答本文
          // ====================================================

          final answer =
              json["answer"]
                  ?.toString()
                  .trim() ??
              "";

          // ====================================================
          // 商品
          // ====================================================

          final List<ProductRecommendation>
              products = [];

          final productData =
              json["products"];

          if (productData is List) {
            for (
              final item in productData
            ) {
              if (item is Map) {
                try {
                  final product =
                      ProductRecommendation
                          .fromJson(
                    Map<String, dynamic>.from(
                      item,
                    ),
                  );

                  if (product.name.isNotEmpty) {
                    products.add(product);
                  }
                } catch (e) {
                  print(
                    "Product parse error: $e",
                  );
                }
              }
            }
          }

          // ====================================================
          // 商品数制限
          // ====================================================
          //
          // ResponsePromptでも
          // 2〜3個程度としているため、
          // アプリ側でも最大3個に制限。
          //
          // ====================================================

          final limitedProducts =
              products.take(3).toList();

          // ====================================================
          // AIResponse
          //
          // 通常チャットなので
          // customPlanは扱わない。
          // ====================================================

          return AIResponse(
            answer:
                answer.isNotEmpty
                    ? answer
                    : "回答を取得できませんでした。",
            products:
                limitedProducts,
          );
        } catch (e) {
          // ====================================================
          // JSON parse error
          // ====================================================

          print(
            "JSON parse error: $e",
          );

          print(
            "Raw AI content: $content",
          );

          // ----------------------------------------------------
          // 念のためcontentをそのまま返す。
          // ----------------------------------------------------

          return AIResponse(
            answer: content,
            products: [],
          );
        }
      }

      // ========================================================
      // APIエラー
      // ========================================================

      String errorMessage =
          "AIとの通信でエラーが発生しました。";

      try {
        final errorData =
            jsonDecode(response.body);

        final apiError =
            errorData["error"]?["message"]
                ?.toString();

        if (
          apiError != null &&
          apiError.isNotEmpty
        ) {
          errorMessage =
              "AIとの通信でエラーが発生しました。\n"
              "$apiError";
        }
      } catch (_) {
        // エラー本文のJSON解析に失敗した場合は
        // デフォルトメッセージを使用。
      }

      print(
        "OpenAI API error: "
        "${response.statusCode}",
      );

      print(
        "OpenAI API body: "
        "${response.body}",
      );

      return AIResponse(
        answer: errorMessage,
        products: [],
      );
    } on FormatException catch (e) {
      // ========================================================
      // JSON / response形式エラー
      // ========================================================

      print(
        "Format exception: $e",
      );

      return AIResponse(
        answer:
            "AIからの回答データを解析できませんでした。",
        products: [],
      );
    } on Exception catch (e) {
      // ========================================================
      // 通信・タイムアウトなど
      // ========================================================

      print(
        "Chat API exception: $e",
      );

      return AIResponse(
        answer:
            "AIとの通信に失敗しました。\n"
            "ネットワーク接続を確認してください。",
        products: [],
      );
    } catch (e) {
      // ========================================================
      // その他の予期しないエラー
      // ========================================================

      print(
        "Unexpected OpenAI error: $e",
      );

      return AIResponse(
        answer:
            "予期しないエラーが発生しました。",
        products: [],
      );
    }
  }
}
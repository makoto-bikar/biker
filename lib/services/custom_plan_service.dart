import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'firestore_service.dart';
import 'openai_service.dart';
import '../prompts/custom_plan_prompt.dart';


// ============================================================
// Custom Plan
// ============================================================

class CustomPlan {
  final String title;
  final String reason;
  final String difficulty;
  final String estimatedTime;

  final List<ProductRecommendation> parts;
  final List<ProductRecommendation> tools;

  final List<String> workSteps;

  final String caution;

  CustomPlan({
    required this.title,
    required this.reason,
    required this.difficulty,
    required this.estimatedTime,
    required this.parts,
    required this.tools,
    required this.workSteps,
    required this.caution,
  });

  factory CustomPlan.fromJson(
    Map<String, dynamic> json,
  ) {
    List<ProductRecommendation> parseProducts(
      dynamic value,
    ) {
      if (value is! List) {
        return [];
      }

      return value
          .whereType<Map>()
          .map(
            (item) => ProductRecommendation.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .where(
            (product) => product.name.isNotEmpty,
          )
          .toList();
    }

    List<String> parseWorkSteps(
      dynamic value,
    ) {
      if (value is! List) {
        return [];
      }

      return value
          .map(
            (item) => item.toString().trim(),
          )
          .where(
            (step) => step.isNotEmpty,
          )
          .toList();
    }

    return CustomPlan(
      title:
          json["title"]?.toString() ?? "",

      reason:
          json["reason"]?.toString() ?? "",

      difficulty:
          json["difficulty"]?.toString() ?? "",

      estimatedTime:
          json["estimatedTime"]?.toString() ?? "",

      parts:
          parseProducts(
        json["parts"],
      ),

      tools:
          parseProducts(
        json["tools"],
      ),

      workSteps:
          parseWorkSteps(
        json["workSteps"],
      ),

      caution:
          json["caution"]?.toString() ?? "",
    );
  }
}


// ============================================================
// Custom Plan Response
// ============================================================

class CustomPlanResponse {
  final String answer;

  final CustomPlan? customPlan;

  final List<ProductRecommendation> products;

  CustomPlanResponse({
    required this.answer,
    this.customPlan,
    this.products = const [],
  });
}


// ============================================================
// Custom Plan Service
// ============================================================

class CustomPlanService {

  // ==========================================================
  // API Key
  // ==========================================================

  static String? _getApiKey() {
    final apiKey =
        dotenv.env["OPENAI_API_KEY"];

    if (apiKey == null ||
        apiKey.isEmpty) {
      return null;
    }

    return apiKey;
  }


  // ==========================================================
  // Garage情報
  // ==========================================================

  static Future<Map<String, String>>
      _getGarageInfo() async {

    final firestore =
        FirestoreService();

    final user =
        await firestore.getLatestUser();

    return {
      "manufacturer":
          user?["manufacturer"]
                  ?.toString() ??
              "不明",

      "bike":
          user?["bike"]
                  ?.toString() ??
              "不明",

      "year":
          user?["year"]
                  ?.toString() ??
              "不明",

      "style":
          user?["style"]
                  ?.toString() ??
              "不明",

      "experience":
          user?["experience"]
                  ?.toString() ??
              "不明",
    };
  }


  // ==========================================================
  // Custom Plan生成
  // ==========================================================

  static Future<CustomPlanResponse>
      generatePlan({
    String? conversationId,
  }) async {

    // ========================================================
    // API Key
    // ========================================================

    final apiKey =
        _getApiKey();

    if (apiKey == null) {
      return CustomPlanResponse(
        answer:
            "APIキーが設定されていません。",
      );
    }


    // ========================================================
    // Garage
    // ========================================================

    final garage =
        await _getGarageInfo();

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
    // Custom Plan Prompt
    // ========================================================

    final systemPrompt =
        CustomPlanPrompt.build(
      manufacturer:
          manufacturer,

      bike:
          bike,

      year:
          year,

      style:
          style,

      experience:
          experience,
    );


    // ========================================================
    // Messages
    // ========================================================

    final List<Map<String, String>>
        messages = [];

    messages.add({
      "role":
          "system",

      "content":
          systemPrompt,
    });


    // ========================================================
    // 会話履歴
    // ========================================================

    if (conversationId != null) {

      final firestore =
          FirestoreService();

      final history =
          await firestore
              .getConversationMessages(
        conversationId,
      );

      final recentHistory =
          history.length > 20
              ? history.sublist(
                  history.length - 20,
                )
              : history;

      for (final chat in recentHistory) {

        final text =
            chat["text"]
                    ?.toString() ??
                "";

        if (text.trim().isEmpty) {
          continue;
        }

        final isUser =
            chat["isUser"] == true;

        messages.add({
          "role":
              isUser
                  ? "user"
                  : "assistant",

          "content":
              text,
        });
      }
    }


    // ========================================================
    // Custom Plan生成指示
    // ========================================================

    messages.add({
      "role":
          "user",

      "content":
          "現在のGarage情報をもとに、"
          "ユーザーが理想のバイクに近づくための"
          "最初のカスタムを1つだけ提案してください。",
    });


    // ========================================================
    // OpenAI API
    // ========================================================

    try {

      final response =
          await http.post(

        Uri.parse(
          "https://api.openai.com/v1/chat/completions",
        ),

        headers: {

          "Authorization":
              "Bearer $apiKey",

          "Content-Type":
              "application/json",
        },

        body:
            jsonEncode({

          "model":
              "gpt-4.1-mini",

          "messages":
              messages,

          "response_format": {
            "type":
                "json_object",
          },

          "temperature":
              0.4,

          "max_tokens":
              2500,
        }),
      );


      // ======================================================
      // API成功
      // ======================================================

      if (response.statusCode == 200) {

        final data =
            jsonDecode(
          response.body,
        );

        final content =
            data["choices"]?[0]?["message"]?["content"]
                ?.toString() ??
            "";

        if (content.isEmpty) {

          return CustomPlanResponse(
            answer:
                "Custom Planを取得できませんでした。",
          );
        }


        // ====================================================
        // JSON解析
        // ====================================================

        try {

          final json =
              jsonDecode(
            content,
          );

          final answer =
              json["answer"]
                      ?.toString() ??
                  "";


          // ==================================================
          // Custom Plan
          // ==================================================

          CustomPlan? customPlan;

          final customPlanData =
              json["customPlan"];

          if (customPlanData is Map) {

            customPlan =
                CustomPlan.fromJson(
              Map<String, dynamic>.from(
                customPlanData,
              ),
            );
          }


          // ==================================================
          // 商品
          //
          // parts + tools
          // ==================================================

          final List<ProductRecommendation>
              products = [];

          if (customPlan != null) {

            products.addAll(
              customPlan.parts,
            );

            products.addAll(
              customPlan.tools,
            );
          }


          // ==================================================
          // Response
          // ==================================================

          return CustomPlanResponse(

            answer:
                answer.isNotEmpty
                    ? answer
                    : "Custom Planを作成しました。",

            customPlan:
                customPlan,

            products:
                products,
          );


        } catch (e) {

          print(
            "Custom Plan JSON parse error: $e",
          );

          return CustomPlanResponse(
            answer:
                "Custom Planの解析に失敗しました。",
          );
        }
      }


      // ======================================================
      // APIエラー
      // ======================================================

      String errorMessage =
          "Custom Planの生成中にエラーが発生しました。";

      try {

        final errorData =
            jsonDecode(
          response.body,
        );

        final apiError =
            errorData["error"]?["message"]
                ?.toString();

        if (
          apiError != null &&
          apiError.isNotEmpty
        ) {

          errorMessage =
              "$errorMessage\n$apiError";
        }

      } catch (_) {}


      return CustomPlanResponse(
        answer:
            errorMessage,
      );


    } catch (e) {

      print(
        "Custom Plan API exception: $e",
      );

      return CustomPlanResponse(
        answer:
            "Custom Planの生成に失敗しました。\n"
            "ネットワーク接続を確認してください。",
      );
    }
  }
}
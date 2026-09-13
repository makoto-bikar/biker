import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../prompts/image_prompt.dart';

class BikeImageService {

  // ==========================================================
  // APIキー
  // ==========================================================

  static String? _getApiKey() {
    final apiKey =
        dotenv.env["OPENAI_API_KEY"];

    if (apiKey == null || apiKey.isEmpty) {
      return null;
    }

    return apiKey;
  }


  // ==========================================================
  // バイク完成イメージ生成
  // ==========================================================

  static Future<Uint8List?> generateBikeImage({
    required String manufacturer,
    required String bike,
    required String year,
    required String style,
  }) async {

    // ========================================================
    // 開始
    // ========================================================

    print("");
    print("========================================");
    print("========== BIKE IMAGE START ============");
    print("========================================");


    // ========================================================
    // APIキー確認
    // ========================================================

    final apiKey = _getApiKey();

    print(
      "API KEY EXISTS: ${apiKey != null}",
    );

    if (apiKey == null) {

      print("❌ API KEY IS NULL");
      print("========================================");

      return null;
    }


    // ========================================================
    // APIキーの中身は表示しない
    // ========================================================

    print("API KEY CHECK: OK");


    try {

      // ======================================================
      // プロンプト作成開始
      // ======================================================

      print("");
      print("---------- PROMPT ----------");
      print("BEFORE PROMPT");


      final prompt =
          ImagePrompt.build(
        manufacturer: manufacturer,
        bike: bike,
        year: year,
        style: style,
      );


      print("PROMPT CREATED");
      print("PROMPT:");
      print(prompt);


      // ======================================================
      // HTTPリクエスト
      // ======================================================

      print("");
      print("---------- HTTP REQUEST ----------");
      print("BEFORE HTTP REQUEST");
      print("URL: https://api.openai.com/v1/images/generations");
      print("MODEL: gpt-image-2");
      print("SIZE: 1024x1024");


      final response =
          await http.post(
        Uri.parse(
          "https://api.openai.com/v1/images/generations",
        ),

        headers: {
          "Authorization":
              "Bearer $apiKey",

          "Content-Type":
              "application/json",
        },

        body: jsonEncode({
          "model":
              "gpt-image-2",

          "prompt":
              prompt,

          "size":
              "1024x1024",
        }),
      );


      // ======================================================
      // HTTPレスポンス
      // ======================================================

      print("");
      print("---------- HTTP RESPONSE ----------");
      print("HTTP RESPONSE RECEIVED");
      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE BODY:");
      print(response.body);


      // ======================================================
      // HTTP成功
      // ======================================================

      if (response.statusCode == 200) {

        print("");
        print("---------- RESPONSE PARSE ----------");
        print("HTTP 200 SUCCESS");


        // ----------------------------------------------------
        // JSON解析
        // ----------------------------------------------------

        final data =
            jsonDecode(
          response.body,
        );


        print("JSON DECODE SUCCESS");


        // ----------------------------------------------------
        // b64_json取得
        // ----------------------------------------------------

        final base64Image =
            data["data"]?[0]?["b64_json"]
                ?.toString();


        print(
          "b64_json EXISTS: "
          "${base64Image != null}",
        );


        // ----------------------------------------------------
        // b64_jsonが空
        // ----------------------------------------------------

        if (base64Image == null ||
            base64Image.isEmpty) {

          print("");
          print("❌ b64_json IS EMPTY");
          print("Image API returned 200,");
          print("but b64_json was empty.");
          print("FULL RESPONSE:");
          print(response.body);
          print("========================================");

          return null;
        }


        // ----------------------------------------------------
        // Base64デコード
        // ----------------------------------------------------

        print("");
        print("---------- BASE64 DECODE ----------");
        print("b64_json RECEIVED");
        print(
          "BASE64 LENGTH: "
          "${base64Image.length}",
        );


        final imageBytes =
            base64Decode(
          base64Image,
        );


        print("BASE64 DECODE SUCCESS");
        print(
          "IMAGE BYTE LENGTH: "
          "${imageBytes.length}",
        );


        // ----------------------------------------------------
        // 完了
        // ----------------------------------------------------

        print("");
        print("========================================");
        print("======= BIKE IMAGE SUCCESS =============");
        print("========================================");
        print("");


        return imageBytes;
      }


      // ======================================================
      // APIエラー
      // ======================================================

      print("");
      print("---------- API ERROR ----------");

      print(
        "❌ IMAGE GENERATION ERROR",
      );

      print(
        "STATUS CODE: "
        "${response.statusCode}",
      );

      print(
        "RESPONSE BODY:",
      );

      print(
        response.body,
      );

      print("========================================");
      print("");


      return null;


    } on FormatException catch (e) {

      // ======================================================
      // JSON / Base64解析エラー
      // ======================================================

      print("");
      print("---------- FORMAT ERROR ----------");

      print(
        "❌ FORMAT EXCEPTION",
      );

      print(e);

      print("========================================");
      print("");


      return null;


    } on Exception catch (e) {

      // ======================================================
      // 通信エラー
      // ======================================================

      print("");
      print("---------- NETWORK ERROR ----------");

      print(
        "❌ IMAGE GENERATION EXCEPTION",
      );

      print(e);

      print("========================================");
      print("");


      return null;


    } catch (e) {

      // ======================================================
      // その他のエラー
      // ======================================================

      print("");
      print("---------- UNKNOWN ERROR ----------");

      print(
        "❌ UNKNOWN ERROR",
      );

      print(e);

      print("========================================");
      print("");


      return null;
    }
  }
}
import 'package:flutter/services.dart';

class KnowledgeService {
  /// Knowledgeファイルを読み込む
  static Future<String> load(String path) async {
    try {
      return await rootBundle.loadString(path);
    } catch (e) {
      print('Knowledge loading error: $path');
      print(e);

      return '';
    }
  }

  /// 複数のKnowledgeをまとめて読み込む
  static Future<String> loadMultiple(List<String> paths) async {
    final List<String> knowledgeList = [];

    for (final path in paths) {
      final knowledge = await load(path);

      if (knowledge.isNotEmpty) {
        knowledgeList.add(
          '''
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
【Knowledge】
━━━━━━━━━━━━━━━━━━━━━━━━━━━━

$knowledge
''',
        );
      }
    }

    return knowledgeList.join('\n');
  }
}
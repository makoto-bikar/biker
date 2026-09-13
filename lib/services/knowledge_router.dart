import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class KnowledgeRouter {
  /// ==========================================================
  /// Knowledge Router
  ///
  /// 役割：
  /// ユーザーの質問・車両情報から
  /// 「今回必要なKnowledgeのファイル」だけを選択する。
  ///
  /// 重要：
  /// このファイルには車種固有情報を書かない。
  ///
  /// 車両の世代・型式・Knowledgeの場所は
  /// knowledge/vehicle_registry.json が管理する。
  /// ==========================================================

  static Future<List<String>> select({
    required String question,
    required String manufacturer,
    required String bike,
    required String year,
  }) async {
    final List<String> knowledge = [];

    final text = [
      question,
      manufacturer,
      bike,
      year,
    ].join(' ').toLowerCase();

    // ==========================================================
    // ① 車両Knowledge
    // ==========================================================

    final vehicleKnowledge = await _selectVehicleKnowledge(
      manufacturer: manufacturer,
      bike: bike,
      year: year,
      question: question,
    );

    knowledge.addAll(vehicleKnowledge);

    // ==========================================================
    // ② Systems
    // ==========================================================

    knowledge.addAll(
      _selectSystemKnowledge(text),
    );

    // ==========================================================
    // ③ Custom
    // ==========================================================

    knowledge.addAll(
      _selectCustomKnowledge(text),
    );

    // ==========================================================
    // ④ Styles
    // ==========================================================

    knowledge.addAll(
      _selectStyleKnowledge(text),
    );

    // ==========================================================
    // ⑤ Regulations
    // ==========================================================

    knowledge.addAll(
      _selectRegulationKnowledge(text),
    );

    // ==========================================================
    // ⑥ Safety
    // ==========================================================

    knowledge.addAll(
      _selectSafetyKnowledge(text),
    );

    // ==========================================================
    // ⑦ Tools
    // ==========================================================

    knowledge.addAll(
      _selectToolKnowledge(text),
    );

    // ==========================================================
// 重複削除
// ==========================================================

final selectedKnowledge =
    knowledge.toSet().toList();

// ==========================================================
// DEBUG
// ==========================================================

if (kDebugMode) {
  debugPrint('');
  debugPrint(
    '========== BIKER KNOWLEDGE ROUTER ==========',
  );

  debugPrint('質問: $question');
  debugPrint('メーカー: $manufacturer');
  debugPrint('車種: $bike');
  debugPrint('年式: $year');

  debugPrint('');
  debugPrint('Selected Knowledge:');

  if (selectedKnowledge.isEmpty) {
    debugPrint(
      '  ⚠️ Knowledgeが選択されていません',
    );
  } else {
    for (final path in selectedKnowledge) {
      debugPrint('  - $path');
    }
  }

  debugPrint(
    '=============================================',
  );

  debugPrint('');
}

return selectedKnowledge;
  }

  // ==========================================================
  // Systems Knowledge
  // ==========================================================

  static List<String> _selectSystemKnowledge(
    String text,
  ) {
    final List<String> result = [];

    // ----------------------------------------------------------
    // Engine
    // ----------------------------------------------------------

    if (_containsAny(text, [
      'エンジン',
      'エンジンオイル',
      'オイル交換',
      'オイル',
      'プラグ',
      'スパークプラグ',
      '始動',
      'アイドリング',
      '圧縮',
      '点火',
      '潤滑',
      '冷却',
      '燃焼',
      'パワー',
      'トルク',
    ])) {
      result.add(
        'knowledge/systems/engine.md',
      );
    }

    // ----------------------------------------------------------
    // Fuel System
    // ----------------------------------------------------------

    if (_containsAny(text, [
      '燃料',
      'ガソリン',
      '燃料タンク',
      'タンク',
      'キャブ',
      'キャブレター',
      'fi',
      'インジェクション',
      'インジェクター',
      '燃料ポンプ',
      '燃料ホース',
      'フロート',
      'ジェット',
    ])) {
      result.add(
        'knowledge/systems/fuel_system.md',
      );
    }

    // ----------------------------------------------------------
    // Intake / Exhaust
    // ----------------------------------------------------------

    if (_containsAny(text, [
      '吸気',
      'エアクリーナー',
      'エアクリ',
      'エアボックス',
      'インテーク',
      'マフラー',
      'エキパイ',
      'エキゾースト',
      '排気',
      '排気系',
      'バッフル',
      '触媒',
      '排気漏れ',
    ])) {
      result.add(
        'knowledge/systems/intake_exhaust.md',
      );
    }

    // ----------------------------------------------------------
    // Braking
    // ----------------------------------------------------------

    if (_containsAny(text, [
      'ブレーキ',
      'ブレーキパッド',
      'キャリパー',
      'マスターシリンダー',
      'ブレーキフルード',
      'ローター',
      'ディスク',
      'ドラムブレーキ',
      '制動',
    ])) {
      result.add(
        'knowledge/systems/braking.md',
      );
    }

    // ----------------------------------------------------------
    // Suspension
    // ----------------------------------------------------------

    if (_containsAny(text, [
      'サスペンション',
      'フォーク',
      'フロントフォーク',
      'リアショック',
      'ショック',
      'バネ',
      'スプリング',
      'プリロード',
      'ダンピング',
      '減衰',
      '車高',
      'ローダウン',
      'ロングフォーク',
    ])) {
      result.add(
        'knowledge/systems/suspension.md',
      );
    }

    // ----------------------------------------------------------
    // Electrical
    // ----------------------------------------------------------

    if (_containsAny(text, [
      '電装',
      '電気',
      '配線',
      'バッテリー',
      '充電',
      'レギュレーター',
      'レクチファイア',
      'ヒューズ',
      'リレー',
      'ヘッドライト',
      'テールランプ',
      'ウインカー',
      'ホーン',
      'スターターモーター',
      'cdi',
      'tci',
      'ecu',
      'led',
      'usb電源',
    ])) {
      result.add(
        'knowledge/systems/electrical.md',
      );
    }

    // ----------------------------------------------------------
    // Drivetrain
    // ----------------------------------------------------------

    if (_containsAny(text, [
      '駆動系',
      'クラッチ',
      'ミッション',
      'ギア',
      'チェーン',
      'チェーン調整',
      'チェーン交換',
      'スプロケット',
      'ドライブベルト',
      'ベルト',
      'シャフトドライブ',
      'チェーンライン',
    ])) {
      result.add(
        'knowledge/systems/drivetrain.md',
      );
    }

    // ----------------------------------------------------------
    // Chassis
    // ----------------------------------------------------------

    if (_containsAny(text, [
      'フレーム',
      '車体',
      'シャシー',
      'シャーシ',
      'スイングアーム',
      'ステム',
      'ステアリング',
      'ステアリングベアリング',
      'ホイール',
      'タイヤ',
      'アクスル',
      '車軸',
      'ホイールベース',
      'トレール',
      'レーキ',
      'ハンドル',
    ])) {
      result.add(
        'knowledge/systems/chassis.md',
      );
    }

    return result;
  }

  // ==========================================================
  // Custom Knowledge
  // ==========================================================

  static List<String> _selectCustomKnowledge(
    String text,
  ) {
    final List<String> result = [];

    // ----------------------------------------------------------
// Chopper Custom
// ----------------------------------------------------------

if (_containsAny(text, [
  'チョッパーにカスタム',
  'チョッパーにしたい',
  'チョッパーにする',
  'チョッパー化',
  'チョッパー仕様',
  'チョッパーカスタム',
  'チョッパーを作りたい',
  'チョッパーを作る',
  'チョッパーっぽく',
  'チョッパー用に',
  'ロングフォーク化',
  'ロングフォークにしたい',
  'ロングフォークを入れたい',
  'フロントフォークを伸ばしたい',
  'フォークを長くしたい',
  'フレームをチョッパー化',
  'チョッパーフレーム',
  'ハードテール化',
  'ハードテールにしたい',
  'chopper custom',
  'chopper build',
  'chopper conversion',
])) {
  result.add(
    'knowledge/custom/chopper.md',
  );
}

    // ----------------------------------------------------------
    // Compatibility
    // ----------------------------------------------------------

    if (_containsAny(text, [
      '適合',
      '互換',
      '付く',
      'つく',
      '取り付けできる',
      '取り付け可能',
      '装着できる',
      '流用',
      'ポン付け',
      'ボルトオン',
      '加工',
      'カスタム',
      '改造',
      '交換',
      '取り付け',
      '使える',
'使えますか',
'合う',
'合いますか',
'いける',
'いけますか',
'対応',
'対応する',
    ])) {
      result.add(
        'knowledge/custom/compatibility.md',
      );
    }

    // ----------------------------------------------------------
    // Handlebars
    // ----------------------------------------------------------

    if (_containsAny(text, [
      'ハンドル',
      'ハンドルバー',
      'ドラッグバー',
      'エイプハンガー',
      'セパハン',
      'クリップオン',
      'ハンドル交換',
      'ハンドル幅',
      'ハンドル高さ',
      'ハンドルクランプ',
      'ハンドルポスト',
    ])) {
      result.add(
        'knowledge/custom/handlebars.md',
      );
    }

        // ----------------------------------------------------------
    // Sissy Bar
    // ----------------------------------------------------------

    if (_containsAny(text, [
      'シーシーバー',
      'シッシーバー',
      'しっしーばー',
      'sissy bar',
      'sissybar',
      'シーシーバーを付けたい',
      'シッシーバーを付けたい',
      'シーシーバーを取り付けたい',
      'シッシーバーを取り付けたい',
      'シーシーバー交換',
      'シッシーバー交換',
      'シーシーバー取り付け',
      'シッシーバー取り付け',
      'シーシーバーの取り付け',
      'シッシーバーの取り付け',
      'シーシーバーの高さ',
      'シッシーバーの高さ',
      'シーシーバーの長さ',
      'シッシーバーの長さ',
      'シーシーバーの選び方',
      'シッシーバーの選び方',
    ])) {
      result.add(
        'knowledge/custom/sissy_bar.md',
      );
    }

    // ----------------------------------------------------------
    // Wheels / Tires
    // ----------------------------------------------------------

    if (_containsAny(text, [
      'ホイール',
      'タイヤ',
      'スポーク',
      'キャストホイール',
      'ワイドタイヤ',
      'タイヤサイズ',
      'リム',
      'ホイールサイズ',
    ])) {
      result.add(
        'knowledge/custom/wheels_tires.md',
      );
    }

    // ----------------------------------------------------------
    // Suspension
    // ----------------------------------------------------------

    if (_containsAny(text, [
      'ローダウン',
      'ロングフォーク',
      'フォーク',
      'スプリンガーフォーク',
      'ジョイント',
      'フォークジョイント',
      'フォーク延長',
      'フォーク交換',
      'リアショック交換',
      'ショック交換',
      '車高を下げる',
      '車高を上げる',
      'サス交換',
      'リアサスペンション',
      'サスペンション交換',
    ])) {
      result.add(
        'knowledge/custom/suspension.md',
      );
    }

    // ----------------------------------------------------------
    // Brakes
    // ----------------------------------------------------------

    if (_containsAny(text, [
      'ブレーキカスタム',
      'ブレーキをカスタム',
      'ブレーキ強化',
      'ブレーキ交換',
      'マスターシリンダー',
      'ブレーキフルード',
      'キャリパー交換',
      'ローター交換',
      'マスター交換',
      'ブレーキホース交換',
      'ブレーキホースを交換',
      'メッシュホース',
      'ドラムからディスク',
      'ディスクからドラム',
    ])) {
      result.add(
        'knowledge/custom/brakes.md',
      );
    }

    // ----------------------------------------------------------
    // Exhaust
    // ----------------------------------------------------------

    if (_containsAny(text, [
      'マフラー交換',
      'マフラー変更',
      'エキパイ交換',
      'エキゾースト交換',
      'ショートマフラー',
      'スリップオン',
      'フルエキ',
      'バッフル外し',
      '排気カスタム',
      'マフラー変えたい',
'マフラーを変えたい',
'マフラーに交換',
'マフラーを交換',
    ])) {
      result.add(
        'knowledge/custom/exhaust.md',
      );
    }

    // ----------------------------------------------------------
    // Lighting
    // ----------------------------------------------------------

    if (_containsAny(text, [
      'ヘッドライト交換',
      'ヘッドライトを交換',
      'ライト交換',
      'ライト移設',
      'ライト小型化',
      'ウインカー交換',
      'ウインカーに',
      'ウインカー移設',
      'テールランプ',
      'テールライト',
      'ナンバー灯',
      '灯火カスタム',
      'led化',
      'ヘッドライトを小さく',
'ライトを小さく',
'ヘッドライト小型化',
'ライトを小型化',
'LED',
'ウインカーを移設',
'ウインカーを小さく',
'ウインカー小型化',
'ウィンカーを交換',
'ウィンカー',
    ])) {
      result.add(
        'knowledge/custom/lighting.md',
      );
    }

    // ----------------------------------------------------------
    // Electrical
    // ----------------------------------------------------------

    if (_containsAny(text, [
      '電装カスタム',
      '配線加工',
      'usb電源',
      'USB',
      '電源取り出し',
      'スイッチ追加',
      'メーター交換',
      'デジタルメーター',
      'バッテリー移設',
      'led化',
      'LED',
      'メーターを交換',
'メーターを変えたい',
'メーター変更',
'メーターを交換',
    ])) {
      result.add(
        'knowledge/custom/electrical.md',
      );
    }

    // ----------------------------------------------------------
    // Fuel
    // ----------------------------------------------------------

    if (_containsAny(text, [
      'タンク交換',
      'タンク変更',
      'タンク加工',
      'ピーナッツタンク',
      'スポーツスタータンク',
      'コフィンタンク',
      'キャブ交換',
      'ジェット交換',
      'ジェッティング',
      'エアクリーナー交換',
      'パワーフィルター',
      'ファンネル',
      '燃料カスタム',
      'キャブを交換',
'キャブを変えたい',
'キャブレターを交換',
    ])) {
      result.add(
        'knowledge/custom/fuel.md',
      );
    }

    return result;
  }

  // ==========================================================
  // Style Knowledge
  // ==========================================================

  static List<String> _selectStyleKnowledge(
    String text,
  ) {
    final List<String> result = [];

    // ----------------------------------------------------------
    // Style Index
    // ----------------------------------------------------------

    if (_containsAny(text, [
      'カスタムスタイル',
      'スタイル',
      '系統',
      'どんなカスタム',
      'カスタムの種類',
      'ジャンル',
    ])) {
      result.add(
        'knowledge/styles/index.md',
      );
    }

    // ----------------------------------------------------------
    // Chopper
    // ----------------------------------------------------------

    if (_containsAny(text, [
      'チョッパー',
      'chopper',
      'チョッパースタイル',
      'ハードテール',
      'ジョッキーシフト',
      'ミッドハイ',
      'ミッドハイステップ',
      'スーサイド',
      'ロングフォーク',
      'エイプハンガー',
      'チョッパーにしたい',
      'チョップ',
    ])) {
      result.add(
        'knowledge/styles/chopper.md',
      );
    }

    // ----------------------------------------------------------
// Bagger
// ----------------------------------------------------------

if (_containsAny(text, [
  'バガー',
  'bagger',
  'バガースタイル',
])) {
  result.add(
    'knowledge/styles/bagger.md',
  );
}

// ----------------------------------------------------------
// Bobber
// ----------------------------------------------------------

if (_containsAny(text, [
  'ボバー',
  'bobber',
  'ボバースタイル',
])) {
  result.add(
    'knowledge/styles/bobber.md',
  );
}

// ----------------------------------------------------------
// Brat Style
// ----------------------------------------------------------

if (_containsAny(text, [
  'ブラットスタイル',
  'bratstyle',
  'brat style',
  'ブラット',
])) {
  result.add(
    'knowledge/styles/bratstyle.md',
  );
}

// ----------------------------------------------------------
// Cafe Racer
// ----------------------------------------------------------

if (_containsAny(text, [
  'カフェレーサー',
  'cafe racer',
  'cafe_racer',
  'カフェレーサースタイル',
])) {
  result.add(
    'knowledge/styles/cafe_racer.md',
  );
}

// ----------------------------------------------------------
// Club Style
// ----------------------------------------------------------

if (_containsAny(text, [
  'クラブスタイル',
  'clubstyle',
  'club style',
  'クラブスタイル系',
])) {
  result.add(
    'knowledge/styles/clubstyle.md',
  );
}

// ----------------------------------------------------------
// Drag
// ----------------------------------------------------------

if (_containsAny(text, [
  'ドラッグスタイル',
  'ドラッグ',
  'drag',
  'ドラッグレーサー',
])) {
  result.add(
    'knowledge/styles/drag.md',
  );
}

// ----------------------------------------------------------
// Rat Bike
// ----------------------------------------------------------

if (_containsAny(text, [
  'ラットバイク',
  'rat bike',
  'rat_bike',
  'ラットスタイル',
])) {
  result.add(
    'knowledge/styles/rat_bike.md',
  );
}

// ----------------------------------------------------------
// Scrambler
// ----------------------------------------------------------

if (_containsAny(text, [
  'スクランブラー',
  'scrambler',
  'スクランブラースタイル',
])) {
  result.add(
    'knowledge/styles/scrambler.md',
  );
}

// ----------------------------------------------------------
// Streetfighter
// ----------------------------------------------------------

if (_containsAny(text, [
  'ストリートファイター',
  'streetfighter',
  'street fighter',
  'ストファイ',
])) {
  result.add(
    'knowledge/styles/streetfighter.md',
  );
}

// ----------------------------------------------------------
// Tracker
// ----------------------------------------------------------

if (_containsAny(text, [
  'トラッカー',
  'tracker',
  'トラッカースタイル',
  'フラットトラック',
])) {
  result.add(
    'knowledge/styles/tracker.md',
  );
}

// ----------------------------------------------------------
// Vintage Custom
// ----------------------------------------------------------

if (_containsAny(text, [
  'ヴィンテージカスタム',
  'ビンテージカスタム',
  'vintage custom',
  'vintage_custom',
  'ヴィンテージ',
  'ビンテージ',
  'vintage',
])) {
  result.add(
    'knowledge/styles/vintage_custom.md',
  );
}

    return result;
  }

  

  // ==========================================================
  // Regulation Knowledge
  // ==========================================================

  static List<String> _selectRegulationKnowledge(
    String text,
  ) {
    final List<String> result = [];

    // ----------------------------------------------------------
    // Vehicle Inspection
    // ----------------------------------------------------------

    if (_containsAny(text, [
      '車検',
      '車検通る',
      '車検に通る',
      '検査',
      '車検証',
      '継続検査',
      '構造変更',
      '改造申請',
      '構造変更検査',
    ])) {
      result.add(
        'knowledge/regulations/vehicle_inspection.json',
      );
    }

    // ----------------------------------------------------------
    // Safety Standards
    // ----------------------------------------------------------

    if (_containsAny(text, [
      '保安基準',
      '安全基準',
      '保安基準適合',
      '基準に適合',
      '大丈夫',
'危ない',
'危険性',
'注意',
'注意点',
'気をつける',
'気を付ける',
'初心者',
'素人',
'自分で',
'diy',
'DIY',
    ])) {
      result.add(
        'knowledge/regulations/safety_standards.json',
      );
    }

    // ----------------------------------------------------------
    // Lighting
    // ----------------------------------------------------------

    if (_containsAny(text, [
      '灯火',
      'ヘッドライト',
      '前照灯',
      '尾灯',
      '制動灯',
      'ウインカー',
      '方向指示器',
      'ナンバー灯',
      '番号灯',
      '反射器',
      'ライトの色',
    ])) {
      result.add(
        'knowledge/regulations/lighting.json',
      );
    }

    // ----------------------------------------------------------
    // Mirrors
    // ----------------------------------------------------------

    if (_containsAny(text, [
      'ミラー',
      'バックミラー',
      '後写鏡',
      'バーエンドミラー',
      'ミラーの向き',
      'ミラーを外す',
    ])) {
      result.add(
        'knowledge/regulations/mirrors.json',
      );
    }

    // ----------------------------------------------------------
    // Dimensions
    // ----------------------------------------------------------

    if (_containsAny(text, [
      '寸法',
      '全長',
      '全幅',
      '全高',
      '車高',
      '化',
      '車検',
      'ホイールベース',
      '長さが変わる',
      '幅が変わる',
      '高さが変わる',
    ])) {
      result.add(
        'knowledge/regulations/dimensions.json',
      );
    }

    // ----------------------------------------------------------
    // Tires / Wheels
    // ----------------------------------------------------------

    if (_containsAny(text, [
      'タイヤサイズ',
      'タイヤ幅',
      'ホイールサイズ',
      'ワイドタイヤ',
      'スポークホイール',
      'キャストホイール',
      'タイヤの車検',
      'ホイールの車検',
    ])) {
      result.add(
        'knowledge/regulations/tires_wheels.json',
      );
    }

    // ----------------------------------------------------------
    // Exhaust
    // ----------------------------------------------------------

    if (_containsAny(text, [
      'マフラー',
      'エキゾースト',
      '排気系',
      '触媒',
      'バッフル',
      '排気ガス',
      '排ガス',
      'マフラーの車検',
    ])) {
      result.add(
        'knowledge/regulations/exhaust.json',
      );
    }

    // ----------------------------------------------------------
    // Noise
    // ----------------------------------------------------------

    if (_containsAny(text, [
      '騒音',
      '音量',
      'うるさい',
      '排気音',
      'マフラー音',
      '音が大きい',
      '騒音規制',
      '音',
    ])) {
      result.add(
        'knowledge/regulations/noise.json',
      );
    }

    // ----------------------------------------------------------
    // Structural Modification
    // ----------------------------------------------------------

    if (_containsAny(text, [
      '構造変更',
      '改造申請',
      'フレーム切る',
      'フレーム切って',
      'フレームを切って',
      'フレーム加工',
      'フレームカット',
      'フレーム延長',
      'フレーム短縮',
      'スイングアーム変更',
      'ホイールベース変更',
      'ステアリング角変更',
      '車体構造',
    ])) {
      result.add(
        'knowledge/regulations/structural_modification.json',
      );
    }

    // ----------------------------------------------------------
    // General legal keywords
    // ----------------------------------------------------------

    if (_containsAny(text, [
      '法規',
      '法律',
      '合法',
      '違法',
      '認証',
      '適法',
      '公道',
    ])) {
      result.add(
        'knowledge/regulations/vehicle_inspection.json',
      );
      result.add(
        'knowledge/regulations/safety_standards.json',
      );
    }

    return result;
  }

  // ==========================================================
  // Safety Knowledge
  // ==========================================================

  static List<String> _selectSafetyKnowledge(
    String text,
  ) {
    final List<String> result = [];

    // ----------------------------------------------------------
    // General Safety
    // ----------------------------------------------------------

    if (_containsAny(text, [
      '安全',
      '危険',
      '作業',
      '整備',
      '交換',
      '取り付け',
      'カスタム',
      '改造',
      '走行',
      '大丈夫',
    ])) {
      result.add(
        'knowledge/safety/general.md',
      );
    }

    // ----------------------------------------------------------
    // Braking Safety
    // ----------------------------------------------------------

    if (_containsAny(text, [
      'ブレーキ',
      'キャリパー',
      'ブレーキパッド',
      'ブレーキフルード',
      'マスターシリンダー',
      'ブレーキホース',
      '制動',
    ])) {
      result.add(
        'knowledge/safety/braking.md',
      );
    }

    // ----------------------------------------------------------
    // Suspension Safety
    // ----------------------------------------------------------

    if (_containsAny(text, [
      'サスペンション',
      'フォーク',
      'フロントフォーク',
      'リアショック',
      'ローダウン',
      'ロングフォーク',
      '車高',
    ])) {
      result.add(
        'knowledge/safety/suspension.md',
      );
    }

    // ----------------------------------------------------------
    // Electrical Safety
    // ----------------------------------------------------------

    if (_containsAny(text, [
      '電装',
      '配線',
      'バッテリー',
      '電気',
      'led',
      'ヒューズ',
      'リレー',
      'usb電源',
      'ウインカー',
      'ヘッドライト',
    ])) {
      result.add(
        'knowledge/safety/electrical.md',
      );
    }

    // ----------------------------------------------------------
    // Fuel Safety
    // ----------------------------------------------------------

    if (_containsAny(text, [
      '燃料',
      'ガソリン',
      '燃料タンク',
      'タンク',
      'キャブ',
      'キャブレター',
      'インジェクション',
      '燃料ホース',
    ])) {
      result.add(
        'knowledge/safety/fuel.md',
      );
    }

    // ----------------------------------------------------------
    // Lifting Safety
    // ----------------------------------------------------------

    if (_containsAny(text, [
      'ジャッキ',
      'リフト',
      '持ち上げ',
      '車体を上げる',
      'スタンド',
      'ホイール脱着',
      'タイヤ交換',
      'フォーク交換',
      'リアショック交換',
    ])) {
      result.add(
        'knowledge/safety/lifting.md',
      );
    }

    // ----------------------------------------------------------
    // Test Ride Safety
    // ----------------------------------------------------------

    if (_containsAny(text, [
      '試運転',
      '試走',
      '走行確認',
      '走って確認',
      'テスト走行',
      '走行チェック',
    ])) {
      result.add(
        'knowledge/safety/test_ride.md',
      );
    }

    return result;
  }

  // ==========================================================
  // Tools Knowledge
  // ==========================================================

  static List<String> _selectToolKnowledge(
    String text,
  ) {
    final List<String> result = [];

    // ----------------------------------------------------------
    // Basic Tools
    // ----------------------------------------------------------

    if (_containsAny(text, [
      '工具',
      'ツール',
      'レンチ',
      'ソケット',
      'スパナ',
      'メガネレンチ',
      'ドライバー',
      '六角レンチ',
      '六角',
      'プライヤー',
      'ニッパー',
      '何が必要',
      '必要な工具',
    '揃える',
  '揃えたい',
  '用意',
  '用意する',
  '準備',
  '準備する',
  '買う',
  '買いたい',
'工具セット',
'工具類',
'整備工具',
'整備用工具',
'メンテナンス工具',
'DIY工具',
'DIY',
'工具を揃える',
'工具をそろえる',
'そろえる',
'買うべき工具',
'おすすめ工具',
'工具おすすめ',
'最低限の工具',
'必要なもの',
'必要な道具',
'道具',
    ])) {
      result.add(
        'knowledge/tools/basic_tools.json',
      );
    }

    // ----------------------------------------------------------
    // Task Tools
    // ----------------------------------------------------------

    if (_containsAny(text, [
      '必要な工具',
      '何の工具',
      '工具は何',
      '工具を教えて',
      '交換に必要',
      '取り付けに必要',
      '作業に必要',
      '作業工具',
      '工具',
      '作業に使う工具',
'作業で使う工具',
'作業工具',
'交換作業',
'取り外し',
'外す',
'外したい',
'取り付け作業',
'装着作業',
'整備する',
'整備したい',
'メンテナンスする',
'自分でやる',
'DIYしたい',
'自分で交換',
'自分で取り付け',
    ])) {
      result.add(
        'knowledge/tools/task_tools.json',
      );
    }

    // ----------------------------------------------------------
    // Torque Tools
    // ----------------------------------------------------------

    if (_containsAny(text, [
      'トルク',
      'トルクレンチ',
      '締付トルク',
      '締め付けトルク',
      '何nm',
      '何n·m',
      '何ニュートン',
      '締め付け',
      '締付',
      '規定トルク',
'締め付ける',
'締める',
'適正トルク',
'トルク値',
'トルク管理',
'ボルトを締めすぎ',
'ボルトの締めすぎ',
'締めすぎ',
'締めすぎる',
'締めすぎた',
'オーバートルク',
'過締付',
    ])) {
      result.add(
        'knowledge/tools/torque_tools.json',
      );
    }

    // ----------------------------------------------------------
    // Electrical Tools
    // ----------------------------------------------------------

    if (_containsAny(text, [
      '電装工具',
      '電装作業',
      '配線工具',
      'マルチメーター',
      'テスター',
      '検電器',
      '圧着工具',
      'ワイヤーストリッパー',
      'はんだごて',
      'ヒートガン',
      '電装系の工具',
'電気系の工具',
'配線をする',
'配線したい',
'配線を直す',
'電気を測る',
'電圧を測る',
'導通チェック',
'電流を測る',
'ギボシ',
'端子',
'圧着',
    ])) {
      result.add(
        'knowledge/tools/electrical_tools.json',
      );
    }

    // ----------------------------------------------------------
    // Specialty Tools
    // ----------------------------------------------------------

    if (_containsAny(text, [
      '特殊工具',
      '専用工具',
      'プーラー',
      'フライホイールプーラー',
      'クラッチホルダー',
      'ベアリングプーラー',
      'ベアリング圧入',
      'フォーク特殊工具',
      'ステム特殊工具',
      'チェーンリベッター',
      'チェーンカッター',
      '診断機',
      '燃圧計',
      '専用工具',
'特殊工具',
'専用工具が必要',
'特殊工具が必要',
'プーラーが必要',
'専用工具を使う',
'特殊工具を使う',
'圧入',
'抜き取り',
'ベアリング交換',
'フライホイール',
'クラッチ交換',
    ])) {
      result.add(
        'knowledge/tools/specialty_tools.json',
      );
    }

    return result;
  }

  // ==========================================================
  // Vehicle Knowledge Selection
  // ==========================================================

  static Future<List<String>> _selectVehicleKnowledge({
    required String manufacturer,
    required String bike,
    required String year,
    required String question,
  }) async {
    final List<String> result = [];

    final registry = await _loadVehicleRegistry();

    final normalizedManufacturer =
        _normalize(manufacturer);

    final normalizedBike =
        _normalize(bike);

    final normalizedQuestion =
        _normalize(question);

    final vehicles =
        registry['vehicles'];

    if (vehicles is! List) {
      return result;
    }

    // ==========================================================
    // メーカー・車種を検索
    // ==========================================================

    Map<String, dynamic>? matchedVehicle;

    for (final item in vehicles) {
      if (item is! Map) {
        continue;
      }

      final vehicle =
          Map<String, dynamic>.from(item);

      if (_matchesVehicle(
        vehicle: vehicle,
        manufacturer: normalizedManufacturer,
        bike: normalizedBike,
        question: normalizedQuestion,
      )) {
        matchedVehicle = vehicle;
        break;
      }
    }

    // ==========================================================
    // 車両がRegistryに存在しない
    // ==========================================================

    if (matchedVehicle == null) {
      return result;
    }

    // ==========================================================
    // 車両共通Index
    // ==========================================================

    final vehicleKnowledge =
        matchedVehicle['knowledge'];

    if (vehicleKnowledge is Map) {
      final knowledgeMap =
          Map<String, dynamic>.from(
        vehicleKnowledge,
      );

      final indexPath =
          knowledgeMap['indexPath'];

      if (indexPath is String &&
          indexPath.isNotEmpty) {
        result.add(indexPath);
      }
    }

    // ==========================================================
    // Generation
    // ==========================================================

    final generations =
        matchedVehicle['generations'];

    if (generations is! List) {
      return result;
    }

    final normalizedYear =
        _normalizeYear(year);

    // ==========================================================
    // まず質問内の明示的なType / 型式を確認
    // ==========================================================

    bool generationMatchedByQuestion =
        false;

    for (final item in generations) {
      if (item is! Map) {
        continue;
      }

      final generation =
          Map<String, dynamic>.from(item);

      final path =
          generation['knowledgePath'];

      if (path is! String ||
          path.isEmpty) {
        continue;
      }

      if (_matchesGenerationKeyword(
        generation: generation,
        question: normalizedQuestion,
      )) {
        result.add(path);

        generationMatchedByQuestion =
            true;
      }
    }

    // ==========================================================
    // 質問から世代が分からなかった場合は年式から判定
    // ==========================================================

    if (!generationMatchedByQuestion) {
      final parsedYear =
          int.tryParse(normalizedYear);

      if (parsedYear != null) {
        for (final item in generations) {
          if (item is! Map) {
            continue;
          }

          final generation =
              Map<String, dynamic>.from(item);

          final path =
              generation['knowledgePath'];

          if (path is! String ||
              path.isEmpty) {
            continue;
          }

          final yearFrom =
              _toInt(
            generation['yearFrom'],
          );

          final yearTo =
              _toInt(
            generation['yearTo'],
          );

          if (yearFrom == null ||
              yearTo == null) {
            continue;
          }

          if (parsedYear >= yearFrom &&
              parsedYear <= yearTo) {
            result.add(path);
            break;
          }
        }
      }
    }

    return result;
  }

  // ==========================================================
  // Vehicle Match
  // ==========================================================

  static bool _matchesVehicle({
    required Map<String, dynamic> vehicle,
    required String manufacturer,
    required String bike,
    required String question,
  }) {
    // ----------------------------------------------------------
    // メーカー
    // ----------------------------------------------------------

    final registryManufacturer =
        _normalize(
      vehicle['manufacturer']
              ?.toString() ??
          '',
    );

    if (registryManufacturer !=
        manufacturer) {
      return false;
    }

    // ----------------------------------------------------------
    // 車種名
    // ----------------------------------------------------------

    final registryModel =
        _normalize(
      vehicle['model']
              ?.toString() ??
          '',
    );

    if (registryModel == bike) {
      return true;
    }

    // ----------------------------------------------------------
    // 車種Alias
    // ----------------------------------------------------------

    final aliases =
        vehicle['aliases'];

    if (aliases is List) {
      for (final alias in aliases) {
        final normalizedAlias =
            _normalize(
          alias.toString(),
        );

        if (normalizedAlias == bike) {
          return true;
        }
      }
    }

    // ----------------------------------------------------------
    // 質問内に車種名がある場合
    // ----------------------------------------------------------

    if (registryModel.isNotEmpty &&
        question.contains(
          registryModel,
        )) {
      return true;
    }

    if (aliases is List) {
      for (final alias in aliases) {
        final normalizedAlias =
            _normalize(
          alias.toString(),
        );

        if (normalizedAlias.isNotEmpty &&
            question.contains(
              normalizedAlias,
            )) {
          return true;
        }
      }
    }

    return false;
  }

  // ==========================================================
  // Generation Match
  // ==========================================================

  static bool _matchesGenerationKeyword({
    required Map<String, dynamic> generation,
    required String question,
  }) {
    // ----------------------------------------------------------
    // aliases
    // ----------------------------------------------------------

    final aliases =
        generation['aliases'];

    if (aliases is List) {
      for (final alias in aliases) {
        final normalizedAlias =
            _normalize(
          alias.toString(),
        );

        if (normalizedAlias.isNotEmpty &&
            question.contains(
              normalizedAlias,
            )) {
          return true;
        }
      }
    }

    // ----------------------------------------------------------
    // modelCodes
    // ----------------------------------------------------------

    final modelCodes =
        generation['modelCodes'];

    if (modelCodes is List) {
      for (final modelCode in modelCodes) {
        final normalizedModelCode =
            _normalize(
          modelCode.toString(),
        );

        if (normalizedModelCode.isNotEmpty &&
            question.contains(
              normalizedModelCode,
            )) {
          return true;
        }
      }
    }

    return false;
  }

  // ==========================================================
  // vehicle_registry.json 読み込み
  // ==========================================================

  static Future<Map<String, dynamic>>
      _loadVehicleRegistry() async {
    try {
      final jsonString =
          await rootBundle.loadString(
        'knowledge/vehicle_registry.json',
      );

      final decoded =
          jsonDecode(jsonString);

      if (decoded
          is Map<String, dynamic>) {
        return decoded;
      }

      return {};
    } catch (e) {
      return {};
    }
  }

  // ==========================================================
  // キーワード判定
  // ==========================================================

  static bool _containsAny(
    String text,
    List<String> keywords,
  ) {
    for (final keyword in keywords) {
      if (text.contains(
        keyword.toLowerCase(),
      )) {
        return true;
      }
    }

    return false;
  }

  // ==========================================================
  // 正規化
  // ==========================================================

  static String _normalize(
    String value,
  ) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(' ', '')
        .replaceAll(' ', '')
        .replaceAll('-', '')
        .replaceAll('_', '');
  }

  // ==========================================================
  // 年式正規化
  // ==========================================================

  static String _normalizeYear(
    String value,
  ) {
    return value
        .replaceAll('年式', '')
        .replaceAll('年', '')
        .trim();
  }

  // ==========================================================
  // 数値変換
  // ==========================================================

  static int? _toInt(
    dynamic value,
  ) {
    if (value is int) {
      return value;
    }

    return int.tryParse(
      value?.toString() ?? '',
    );
  }
}
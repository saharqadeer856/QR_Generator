import '../constants/app_strings.dart';
import '../utils/input_detector.dart';

/// One saved QR code.
class QrItem {
  const QrItem({
    required this.text,
    required this.errorLevel,
    required this.createdAt,
  });

  final String text;
  final int errorLevel;
  final DateTime createdAt;

  /// Whether the content is a link, a number or plain text.
  QrContentType get contentType => InputDetector.detect(text);

  String get typeLabel => AppStrings.typeLabel(contentType);

  Map<String, dynamic> toJson() => {
        'text': text,
        'level': errorLevel,
        'createdAt': createdAt.millisecondsSinceEpoch,
      };

  factory QrItem.fromJson(Map<String, dynamic> json) => QrItem(
        text: json['text'] as String,
        errorLevel: json['level'] as int,
        createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      );

  @override
  bool operator ==(Object other) =>
      other is QrItem && other.text == text && other.createdAt == createdAt;

  @override
  int get hashCode => Object.hash(text, createdAt);
}

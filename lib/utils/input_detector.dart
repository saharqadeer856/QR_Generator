enum QrContentType { empty, link, number, text }

/// Works out what the user typed so the UI can label it.
/// The QR code always encodes the exact text, whatever the type.
class InputDetector {
  InputDetector._();

  static final RegExp _linkPattern =
      RegExp(r'^(https?://|www\.)\S+$', caseSensitive: false);
  static final RegExp _domainPattern =
      RegExp(r'^[a-z0-9-]+(\.[a-z0-9-]+)+(/\S*)?$', caseSensitive: false);
  static final RegExp _numberPattern = RegExp(r'^[+-]?\d+(\.\d+)?$');

  static QrContentType detect(String input) {
    final text = input.trim();
    if (text.isEmpty) return QrContentType.empty;
    // Numbers first, so "3.14" is not mistaken for a domain.
    if (_numberPattern.hasMatch(text)) return QrContentType.number;
    if (_linkPattern.hasMatch(text) || _domainPattern.hasMatch(text)) {
      return QrContentType.link;
    }
    return QrContentType.text;
  }
}

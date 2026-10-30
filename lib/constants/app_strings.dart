import '../utils/input_detector.dart';

class AppStrings {
  AppStrings._();

  static const String appName = 'QR Generator';
  static const String tagline = 'Create QR codes in seconds.';

  // Generator
  static const String inputLabel = 'Your content';
  static const String inputHint = 'Type text, a number or a link';
  static const String clear = 'Clear';
  static const String typeLink = 'Link';
  static const String typeNumber = 'Number';
  static const String typeText = 'Text';
  static const String errorLevelLabel = 'Error correction';
  static const String levelLow = 'Low';
  static const String levelMedium = 'Medium';
  static const String levelQuartile = 'Quartile';
  static const String levelHigh = 'High';
  static const String emptyTitle = 'Your QR code appears here';
  static const String emptyMessage = 'Start typing to create one.';
  static const String tooLongTitle = 'Too much content';
  static const String tooLongMessage =
      'Shorten your text to create this QR code.';
  static const String scanHint = 'Point any QR reader at this code.';
  static const String saveToGallery = 'Save to Gallery';
  static const String saved = 'QR code saved to your gallery.';
  static const String saveFailed =
      'Could not save the QR code. Please try again.';
  static const String permissionDenied =
      'Allow photo access to save QR codes.';

  // Navigation tooltips
  static const String historyTooltip = 'Saved codes';
  static const String settingsTooltip = 'Settings';

  // Saved codes
  static const String historyTitle = 'Saved codes';
  static const String historyEmptyTitle = 'No saved codes yet';
  static const String historyEmptyMessage =
      'QR codes you save to your gallery appear here.';
  static String savedCount(int count) =>
      count == 1 ? '1 saved code' : '$count saved codes';

  // Detail
  static const String detailTitle = 'QR Code';
  static const String copyText = 'Copy text';
  static const String copied = 'Text copied to clipboard.';
  static const String delete = 'Delete';
  static const String deleted = 'Removed from saved codes.';

  // Settings
  static const String settingsTitle = 'Settings';
  static const String defaultLevelSection = 'Default error correction';
  static const String defaultLevelHint = 'Used for new QR codes.';
  static const String savedCodesSection = 'Saved codes';
  static const String clearSaved = 'Clear saved codes';
  static const String clearConfirmTitle = 'Clear saved codes?';
  static const String clearConfirmMessage =
      'This removes all saved QR codes from this device.';
  static const String cancel = 'Cancel';
  static const String clearAll = 'Clear all';
  static const String cleared = 'Saved codes cleared.';
  static const String aboutSection = 'About';
  static const String appVersion = 'Version 1.0.0';
  static const String aboutMessage =
      'Create and save QR codes offline. Your codes stay on this device.';

  /// Label for a content type, e.g. "Link".
  static String typeLabel(QrContentType type) {
    switch (type) {
      case QrContentType.link:
        return typeLink;
      case QrContentType.number:
        return typeNumber;
      default:
        return typeText;
    }
  }
}

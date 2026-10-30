class AppStrings {
  AppStrings._();

  static const String appName = 'QR Generator';
  static const String tagline = 'Create QR codes in seconds.';

  // Input
  static const String inputLabel = 'Your content';
  static const String inputHint = 'Type text, a number or a link';
  static const String clear = 'Clear';
  static const String typeLink = 'Link';
  static const String typeNumber = 'Number';
  static const String typeText = 'Text';

  // Error correction
  static const String errorLevelLabel = 'Error correction';
  static const String levelLow = 'Low';
  static const String levelMedium = 'Medium';
  static const String levelQuartile = 'Quartile';
  static const String levelHigh = 'High';

  // Preview
  static const String emptyTitle = 'Your QR code appears here';
  static const String emptyMessage = 'Start typing to create one.';
  static const String tooLongTitle = 'Too much content';
  static const String tooLongMessage =
      'Shorten your text to create this QR code.';
  static const String scanHint = 'Point any QR reader at this code.';

  // Save
  static const String saveToGallery = 'Save to Gallery';
  static const String saved = 'QR code saved to your gallery.';
  static const String saveFailed = 'Could not save the QR code. Please try again.';
  static const String permissionDenied =
      'Allow photo access to save QR codes.';
}

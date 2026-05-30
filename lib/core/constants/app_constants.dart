class AppConstants {
  AppConstants._();
  // API
  static const String geminiModel = 'gemini-3.5-flash';
  static const int maxOutputTokens = 2048;
  static const double temperature = 0.7;
  static const double topP = 0.95;
  static const int topK = 64;

  // UI
  static const double borderRadius = 16.0;
  static const double cardRadius = 20.0;
  static const double bubbleRadius = 18.0;
  static const double inputRadius = 28.0;
  static const double padding = 16.0;
  static const double paddingLg = 24.0;
  static const double paddingXl = 32.0;

  // Animation durations
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 350);
  static const Duration slowAnimation = Duration(milliseconds: 600);
  static const Duration splashDuration = Duration(milliseconds: 2500);

  // Splash
  static const Duration splashNavigationDelay = Duration(milliseconds: 2800);

  // Chat
  static const int maxMessageLength = 4000;
  static const String systemPrompt =
      'You are a helpful, harmless, and honest AI assistant powered by Google Gemini. '
      'Provide clear, accurate, and thoughtful responses. '
      'Format your responses using markdown when appropriate for better readability.';
}

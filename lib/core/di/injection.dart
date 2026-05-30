import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/chat/data/datasources/gemini_datasource.dart';
import '../../features/chat/data/repositories/chat_repository_impl.dart';
import '../../features/chat/domain/repositories/chat_repository.dart';
import '../constants/app_constants.dart';

// SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});

// Override this in main.dart after initialization
final sharedPreferencesInitProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});
final geminiApiKeyProvider = Provider<String>((ref) {
  return dotenv.env['GEMINI_API_KEY']!; // hardcode just to test
});


// GenerativeModel
final generativeModelProvider = Provider<GenerativeModel>((ref) {
  final apiKey = ref.watch(geminiApiKeyProvider);
  return GenerativeModel(
    model: AppConstants.geminiModel,
    apiKey: apiKey,
    generationConfig: GenerationConfig(
      temperature: AppConstants.temperature,
      topP: AppConstants.topP,
      topK: AppConstants.topK,
      maxOutputTokens: AppConstants.maxOutputTokens,
    ),
  );
});

// Data Source
final geminiDataSourceProvider = Provider<GeminiDataSource>((ref) {
  final model = ref.watch(generativeModelProvider);
  return GeminiDataSourceImpl(model: model);
});

// Repository
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final dataSource = ref.watch(geminiDataSourceProvider);
  return ChatRepositoryImpl(dataSource: dataSource);
});

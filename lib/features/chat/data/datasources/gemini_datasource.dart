import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/message_entity.dart';
import '../models/message_model.dart';

abstract class GeminiDataSource {
  Future<MessageModel> sendMessage({
    required String message,
    required List<MessageEntity> history,
  });

  Stream<String> sendMessageStream({
    required String message,
    required List<MessageEntity> history,
  });
}

class GeminiDataSourceImpl implements GeminiDataSource {
  final GenerativeModel _model;
  final _uuid = const Uuid();

  GeminiDataSourceImpl({required GenerativeModel model}) : _model = model;

  List<Content> _buildHistory(List<MessageEntity> history) {
    return history.map((msg) {
      final role = msg.isUser ? 'user' : 'model';
      return Content(role, [TextPart(msg.content)]);
    }).toList();
  }

  @override
  Future<MessageModel> sendMessage({
    required String message,
    required List<MessageEntity> history,
  }) async {
    try {
      final chat = _model.startChat(
        history: _buildHistory(history),
        safetySettings: _safetySettings,
      );

      final response = await chat.sendMessage(Content.text(message));
      final responseText = response.text ?? '';

      return MessageModel(
        id: _uuid.v4(),
        content: responseText.isEmpty ? 'I apologize, I could not generate a response.' : responseText,
        role: MessageRole.assistant,
        timestamp: DateTime.now(),
        status: MessageStatus.sent,
      );
    } on GenerativeAIException catch (e) {
      print("FULL ERROR: $e");
      throw Exception('Gemini API Error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  @override
  Stream<String> sendMessageStream({
    required String message,
    required List<MessageEntity> history,
  }) async* {
    try {
      final chat = _model.startChat(
        history: _buildHistory(history),
        safetySettings: _safetySettings,
      );

      final stream = chat.sendMessageStream(Content.text(message));

      await for (final chunk in stream) {
        final text = chunk.text;
        if (text != null && text.isNotEmpty) {
          yield text;
        }
      }
    } on GenerativeAIException catch (e) {
      print("FULL ERROR: $e");
      throw Exception('Gemini API Error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to stream message: $e');
    }
  }

  List<SafetySetting> get _safetySettings => [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.medium),
      ];
}

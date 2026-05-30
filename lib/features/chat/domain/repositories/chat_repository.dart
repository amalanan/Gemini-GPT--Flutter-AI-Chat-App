import '../entities/message_entity.dart';

abstract class ChatRepository {
  /// Send a message and get AI response
  Future<MessageEntity> sendMessage({
    required String message,
    required List<MessageEntity> history,
  });

  /// Stream AI response token by token
  Stream<String> sendMessageStream({
    required String message,
    required List<MessageEntity> history,
  });
}

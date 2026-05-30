import '../entities/message_entity.dart';
import '../repositories/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository _repository;

  const SendMessageUseCase(this._repository);

  Future<MessageEntity> call({
    required String message,
    required List<MessageEntity> history,
  }) async {
    if (message.trim().isEmpty) {
      throw ArgumentError('Message cannot be empty');
    }
    return _repository.sendMessage(
      message: message.trim(),
      history: history,
    );
  }
}

import '../entities/message_entity.dart';
import '../repositories/chat_repository.dart';

class SendMessageStreamUseCase {
  final ChatRepository _repository;

  const SendMessageStreamUseCase(this._repository);

  Stream<String> call({
    required String message,
    required List<MessageEntity> history,
  }) {
    if (message.trim().isEmpty) {
      throw ArgumentError('Message cannot be empty');
    }
    return _repository.sendMessageStream(
      message: message.trim(),
      history: history,
    );
  }
}

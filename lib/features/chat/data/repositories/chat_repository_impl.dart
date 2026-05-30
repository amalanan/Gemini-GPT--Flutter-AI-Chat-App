import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/gemini_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final GeminiDataSource _dataSource;

  const ChatRepositoryImpl({required GeminiDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<MessageEntity> sendMessage({
    required String message,
    required List<MessageEntity> history,
  }) async {
    return _dataSource.sendMessage(
      message: message,
      history: history,
    );
  }

  @override
  Stream<String> sendMessageStream({
    required String message,
    required List<MessageEntity> history,
  }) {
    return _dataSource.sendMessageStream(
      message: message,
      history: history,
    );
  }
}

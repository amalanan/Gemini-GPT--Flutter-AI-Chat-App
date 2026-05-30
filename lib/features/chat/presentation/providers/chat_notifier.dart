import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/usecases/send_message_stream_usecase.dart';
import '../../domain/usecases/send_message_usecase.dart';
import 'chat_state.dart';

final chatNotifierProvider =
    StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return ChatNotifier(
    sendMessageUseCase: SendMessageUseCase(repository),
    sendMessageStreamUseCase: SendMessageStreamUseCase(repository),
  );
});

class ChatNotifier extends StateNotifier<ChatState> {
  final SendMessageUseCase _sendMessageUseCase;
  final SendMessageStreamUseCase _sendMessageStreamUseCase;
  final _uuid = const Uuid();

  ChatNotifier({
    required SendMessageUseCase sendMessageUseCase,
    required SendMessageStreamUseCase sendMessageStreamUseCase,
  })  : _sendMessageUseCase = sendMessageUseCase,
        _sendMessageStreamUseCase = sendMessageStreamUseCase,
        super(const ChatState());

  /// Send message with streaming response
  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;
    if (state.isLoading || state.isStreaming) return;

    final userMessage = MessageEntity(
      id: _uuid.v4(),
      content: message.trim(),
      role: MessageRole.user,
      timestamp: DateTime.now(),
      status: MessageStatus.sent,
    );

    // Add user message
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      status: ChatStatus.loading,
      errorMessage: null,
      streamingContent: '',
    );

    try {
      String accumulatedContent = '';

      final stream = _sendMessageStreamUseCase(
        message: message,
        history: _getHistoryForApi(),
      );

      // Switch to streaming state
      state = state.copyWith(status: ChatStatus.streaming);

      await for (final chunk in stream) {
        accumulatedContent += chunk;
        state = state.copyWith(
          status: ChatStatus.streaming,
          streamingContent: accumulatedContent,
        );
      }

      // Finalize AI message
      final aiMessage = MessageEntity(
        id: _uuid.v4(),
        content: accumulatedContent.isEmpty
            ? 'I apologize, I could not generate a response.'
            : accumulatedContent,
        role: MessageRole.assistant,
        timestamp: DateTime.now(),
        status: MessageStatus.sent,
      );

      state = state.copyWith(
        messages: [...state.messages, aiMessage],
        status: ChatStatus.idle,
        streamingContent: '',
      );
    } catch (e) {
      final errorMessage = _parseError(e.toString());
      state = state.copyWith(
        status: ChatStatus.error,
        errorMessage: errorMessage,
        streamingContent: '',
      );
    }
  }

  /// Clear all messages
  void clearChat() {
    state = const ChatState();
  }

  /// Dismiss error
  void dismissError() {
    state = state.copyWith(
      status: ChatStatus.idle,
      errorMessage: null,
    );
  }

  /// Retry last failed message
  Future<void> retryLastMessage() async {
    final lastUserMessage = state.messages.lastWhere(
      (m) => m.isUser,
      orElse: () => throw Exception('No user message to retry'),
    );

    // Remove error state messages if any
    final cleanMessages = state.messages.where((m) => !m.isError).toList();
    state = state.copyWith(
      messages: cleanMessages,
      status: ChatStatus.idle,
      errorMessage: null,
    );

    await sendMessage(lastUserMessage.content);
  }

  List<MessageEntity> _getHistoryForApi() {
    // Return all messages except the last user message (which we're about to send)
    final messages = state.messages;
    if (messages.isEmpty) return [];
    return messages.sublist(0, messages.length - 1);
  }

  String _parseError(String error) {
    if (error.contains('network') || error.contains('SocketException')) {
      return AppStrings.errorNetwork;
    } else if (error.contains('API') || error.contains('apiKey')) {
      return AppStrings.errorApi;
    }
    return AppStrings.errorGeneric;
  }
}

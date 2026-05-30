import 'package:flutter/foundation.dart';

import '../../domain/entities/message_entity.dart';

enum ChatStatus { idle, loading, streaming, error }

@immutable
class ChatState {
  final List<MessageEntity> messages;
  final ChatStatus status;
  final String? errorMessage;
  final String streamingContent;

  const ChatState({
    this.messages = const [],
    this.status = ChatStatus.idle,
    this.errorMessage,
    this.streamingContent = '',
  });

  bool get isLoading => status == ChatStatus.loading;
  bool get isStreaming => status == ChatStatus.streaming;
  bool get isIdle => status == ChatStatus.idle;
  bool get hasError => status == ChatStatus.error;
  bool get isEmpty => messages.isEmpty;

  ChatState copyWith({
    List<MessageEntity>? messages,
    ChatStatus? status,
    String? errorMessage,
    String? streamingContent,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      status: status ?? this.status,
      errorMessage: errorMessage,
      streamingContent: streamingContent ?? this.streamingContent,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatState &&
          runtimeType == other.runtimeType &&
          listEquals(messages, other.messages) &&
          status == other.status &&
          errorMessage == other.errorMessage &&
          streamingContent == other.streamingContent;

  @override
  int get hashCode =>
      messages.hashCode ^
      status.hashCode ^
      errorMessage.hashCode ^
      streamingContent.hashCode;
}

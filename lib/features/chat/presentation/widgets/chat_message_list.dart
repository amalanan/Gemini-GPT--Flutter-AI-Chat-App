import 'package:flutter/material.dart';

import '../../domain/entities/message_entity.dart';
import 'message_bubble.dart';
import 'streaming_bubble.dart';
import 'typing_indicator.dart';

class ChatMessageList extends StatelessWidget {
  final List<MessageEntity> messages;
  final ScrollController scrollController;
  final bool isLoading;
  final bool isStreaming;
  final String streamingContent;

  const ChatMessageList({
    super.key,
    required this.messages,
    required this.scrollController,
    required this.isLoading,
    required this.isStreaming,
    required this.streamingContent,
  });

  @override
  Widget build(BuildContext context) {
    final itemCount = messages.length +
        (isLoading ? 1 : 0) +
        (isStreaming && streamingContent.isNotEmpty ? 1 : 0);

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      physics: const BouncingScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        // Loading indicator (typing dots)
        if (isLoading && index == messages.length) {
          return const TypingIndicator();
        }

        // Streaming bubble
        if (isStreaming && streamingContent.isNotEmpty) {
          if (index == messages.length) {
            return StreamingBubble(content: streamingContent);
          }
        }

        // Regular messages
        if (index < messages.length) {
          final message = messages[index];
          final isFirst = index == 0 ||
              messages[index - 1].role != message.role;
          final isLast = index == messages.length - 1 ||
              messages[index + 1].role != message.role;

          return MessageBubble(
            message: message,
            isFirst: isFirst,
            isLast: isLast,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

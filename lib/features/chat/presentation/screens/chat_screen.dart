import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_router.dart';
import '../providers/chat_notifier.dart';
import '../providers/chat_state.dart';
import '../widgets/chat_app_bar.dart';
import '../widgets/chat_empty_state.dart';
import '../widgets/chat_input_field.dart';
import '../widgets/chat_message_list.dart';
import '../widgets/error_banner.dart';
import '../widgets/streaming_bubble.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _inputFocusNode = FocusNode();

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom({bool animated = true}) {
    if (!_scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      if (animated) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Future<void> _sendMessage() async {
    final message = _inputController.text.trim();
    if (message.isEmpty) return;

    _inputController.clear();
    _inputFocusNode.unfocus();

    await ref.read(chatNotifierProvider.notifier).sendMessage(message);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatNotifierProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Auto-scroll when new messages arrive or streaming
    ref.listen(chatNotifierProvider, (prev, next) {
      if (prev?.messages.length != next.messages.length || next.isStreaming) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: ChatAppBar(
        onSettingsTap: () => context.go(AppRoutes.settings),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Error Banner
            if (chatState.hasError && chatState.errorMessage != null)
              ErrorBanner(
                message: chatState.errorMessage!,
                onDismiss: () =>
                    ref.read(chatNotifierProvider.notifier).dismissError(),
                onRetry: () =>
                    ref.read(chatNotifierProvider.notifier).retryLastMessage(),
              ).animate().slideY(begin: -1, end: 0, duration: 300.ms),

            // Message List
            Expanded(
              child: chatState.isEmpty && !chatState.isLoading && !chatState.isStreaming
                  ? const ChatEmptyState()
                  : ChatMessageList(
                      messages: chatState.messages,
                      scrollController: _scrollController,
                      isLoading: chatState.isLoading,
                      streamingContent: chatState.streamingContent,
                      isStreaming: chatState.isStreaming,
                    ),
            ),

            // Divider
            Container(
              height: 1,
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),

            // Input Field
            ChatInputField(
              controller: _inputController,
              focusNode: _inputFocusNode,
              onSend: _sendMessage,
              isLoading: chatState.isLoading || chatState.isStreaming,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/ai_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../theme/app_theme.dart';
import '../../constants/app_constants.dart';
import '../../model/ai_chat_models.dart';

/// AI Assistant View
/// Chat interface for Claude AI with HUD styling
class AIAssistantView extends StatelessWidget {
  const AIAssistantView({super.key});

  @override
  Widget build(BuildContext context) {
    final aiController = Get.put(AIController());
    final themeController = Get.find<ThemeController>();
    final messageController = TextEditingController();
    final scrollController = ScrollController();

    // Auto-scroll to bottom when new messages arrive
    void scrollToBottom() {
      if (scrollController.hasClients) {
        Future.delayed(const Duration(milliseconds: 100), () {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      }
    }

    return Obx(() {
      final theme = themeController.currentTheme.value;

      return Scaffold(
        backgroundColor: kHudBackground,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              _AIHeader(
                theme: theme,
                aiController: aiController,
              ),

              // Messages List
              Expanded(
                child: Obx(() {
                  // Trigger auto-scroll when messages change
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    scrollToBottom();
                  });

                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          kHudBackground,
                          theme.primary.withValues(alpha:0.05),
                        ],
                      ),
                    ),
                    child: ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16.0),
                      itemCount: aiController.messages.length,
                      itemBuilder: (context, index) {
                        final message = aiController.messages[index];
                        return _ChatBubble(
                          message: message,
                          theme: theme,
                        );
                      },
                    ),
                  );
                }),
              ),

              // Loading Indicator
              Obx(() {
                if (aiController.isLoading.value) {
                  return _LoadingIndicator(theme: theme);
                }
                return const SizedBox.shrink();
              }),

              // Quick Actions (Context-Aware Suggestions)
              _QuickActions(
                theme: theme,
                aiController: aiController,
              ),

              // Input Area
              _InputArea(
                theme: theme,
                messageController: messageController,
                aiController: aiController,
                onMessageSent: scrollToBottom,
              ),
            ],
          ),
        ),
      );
    });
  }
}

/// AI Header Widget
class _AIHeader extends StatelessWidget {
  final ColorTheme theme;
  final AIController aiController;

  const _AIHeader({
    required this.theme,
    required this.aiController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.primary.withValues(alpha:0.5),
          ),
        ),
        gradient: LinearGradient(
          colors: [
            kHudBackground,
            theme.primary.withValues(alpha:0.1),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: theme.primary.withValues(alpha:0.2),
            blurRadius: 10.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Row(
        children: [
          // AI Icon with animation
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: theme.primary.withValues(alpha:0.2),
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: theme.primary, width: 2),
              boxShadow: [
                BoxShadow(
                  color: theme.primary.withValues(alpha:0.5),
                  blurRadius: 15.0,
                  spreadRadius: 2.0,
                ),
              ],
            ),
            child: Icon(Icons.psychology, color: theme.primary, size: 30),
          ),
          const SizedBox(width: 12),

          // Title and Status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NEO-HUD AI ASSISTANT',
                  style: AppTheme.getHudTextStyle(
                    color: theme.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.greenAccent.withValues(alpha:0.6),
                            blurRadius: 8.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'ONLINE',
                      style: AppTheme.getHudTextStyle(
                        color: Colors.greenAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '• ${aiController.messages.length} MESSAGES',
                      style: AppTheme.getHudTextStyle(
                        color: theme.accent.withValues(alpha:0.7),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Actions
          IconButton(
            icon: Icon(Icons.info_outline, color: theme.accent),
            onPressed: () => _showInfoDialog(context),
            tooltip: 'About AI Assistant',
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: theme.alert),
            onPressed: () => _showClearDialog(context),
            tooltip: 'Clear Chat',
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: kHudBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(color: theme.primary.withValues(alpha:0.5)),
        ),
        title: Text(
          'AI ASSISTANT INFO',
          style: AppTheme.getHudTextStyle(
            color: theme.primary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoRow('Provider:', 'OpenRouter', theme),
            _InfoRow('Model:', 'Claude 3.5 Sonnet', theme),
            _InfoRow('Status:', 'Active', theme),
            _InfoRow('Mode:', kOpenRouterApiKey == 'YOUR_OPENROUTER_API_KEY' ? 'Demo' : 'Live API', theme),
            const SizedBox(height: 16),
            Text(
              'CAPABILITIES:',
              style: AppTheme.getHudTextStyle(
                color: theme.accent,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            _CapabilityChip('Weather Analysis', theme),
            _CapabilityChip('News Insights', theme),
            _CapabilityChip('System Info', theme),
            _CapabilityChip('General Q&A', theme),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('CLOSE', style: TextStyle(color: theme.primary)),
          ),
        ],
      ),
    );
  }

  void _showClearDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: kHudBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(color: theme.alert.withValues(alpha:0.5)),
        ),
        title: Text(
          'CLEAR CHAT?',
          style: AppTheme.getHudTextStyle(
            color: theme.alert,
            fontSize: 18,
          ),
        ),
        content: Text(
          'This will delete all conversation history.',
          style: AppTheme.getHudTextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('CANCEL', style: TextStyle(color: theme.accent)),
          ),
          TextButton(
            onPressed: () {
              aiController.clearChat();
              Get.back();
              Get.snackbar(
                'Chat Cleared',
                'Conversation history deleted',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: theme.primary.withValues(alpha:0.2),
                colorText: Colors.white,
              );
            },
            child: Text('CLEAR', style: TextStyle(color: theme.alert)),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final ColorTheme theme;

  const _InfoRow(this.label, this.value, this.theme);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.getHudTextStyle(color: Colors.grey, fontSize: 12),
          ),
          Text(
            value,
            style: AppTheme.getHudTextStyle(
              color: theme.primary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CapabilityChip extends StatelessWidget {
  final String label;
  final ColorTheme theme;

  const _CapabilityChip(this.label, this.theme);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: theme.primary.withValues(alpha:0.1),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: theme.primary.withValues(alpha:0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: theme.primary, size: 12),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTheme.getHudTextStyle(
              color: Colors.white,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

/// Chat Bubble Widget
class _ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final ColorTheme theme;

  const _ChatBubble({
    required this.message,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment:
        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            _buildAvatar(false),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14.0),
              decoration: BoxDecoration(
                color: isUser
                    ? theme.accent.withValues(alpha:0.2)
                    : kHudBackground.withValues(alpha:0.8),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: isUser
                      ? theme.accent.withValues(alpha:0.7)
                      : theme.primary.withValues(alpha:0.7),
                  width: 2.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isUser ? theme.accent : theme.primary)
                        .withValues(alpha:0.3),
                    blurRadius: 10.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isUser ? Icons.person : Icons.psychology,
                        color: isUser ? theme.accent : theme.primary,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isUser ? 'USER' : 'NEO-AI',
                        style: AppTheme.getHudTextStyle(
                          color: isUser ? theme.accent : theme.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Message content
                  Text(
                    message.content,
                    style: AppTheme.getHudTextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Timestamp
                  Text(
                    DateFormat('HH:mm:ss').format(message.timestamp),
                    style: AppTheme.getHudTextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 12),
            _buildAvatar(true),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar(bool isUser) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: (isUser ? theme.accent : theme.primary).withValues(alpha:0.2),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: isUser ? theme.accent : theme.primary,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (isUser ? theme.accent : theme.primary).withValues(alpha:0.4),
            blurRadius: 8.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: Icon(
        isUser ? Icons.person : Icons.psychology,
        color: isUser ? theme.accent : theme.primary,
        size: 20,
      ),
    );
  }
}

/// Loading Indicator Widget
class _LoadingIndicator extends StatelessWidget {
  final ColorTheme theme;

  const _LoadingIndicator({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: theme.primary,
              strokeWidth: 2,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'PROCESSING QUERY...',
            style: AppTheme.getHudTextStyle(
              color: theme.accent,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// Quick Actions Widget (Context-Aware Suggestions)
class _QuickActions extends StatelessWidget {
  final ColorTheme theme;
  final AIController aiController;

  const _QuickActions({
    required this.theme,
    required this.aiController,
  });

  @override
  Widget build(BuildContext context) {
    // Only show if no messages or only welcome message
    if (aiController.messages.length > 1) {
      return const SizedBox.shrink();
    }

    final suggestions = [
      {'icon': Icons.wb_sunny, 'text': 'Weather status', 'query': 'What is the current weather?'},
      {'icon': Icons.feed, 'text': 'Latest news', 'query': 'Summarize today\'s news'},
      {'icon': Icons.computer, 'text': 'System info', 'query': 'Show system status'},
      {'icon': Icons.help, 'text': 'Help', 'query': 'What can you help me with?'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'QUICK ACTIONS:',
            style: AppTheme.getHudTextStyle(
              color: theme.accent.withValues(alpha:0.7),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: suggestions.map((suggestion) {
              return InkWell(
                onTap: () => aiController.sendMessage(suggestion['query'] as String),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
                  decoration: BoxDecoration(
                    color: theme.primary.withValues(alpha:0.1),
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: theme.primary.withValues(alpha:0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        suggestion['icon'] as IconData,
                        color: theme.primary,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        suggestion['text'] as String,
                        style: AppTheme.getHudTextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

/// Input Area Widget
class _InputArea extends StatelessWidget {
  final ColorTheme theme;
  final TextEditingController messageController;
  final AIController aiController;
  final VoidCallback onMessageSent;

  const _InputArea({
    required this.theme,
    required this.messageController,
    required this.aiController,
    required this.onMessageSent,
  });

  void _sendMessage() {
    final message = messageController.text.trim();
    if (message.isNotEmpty) {
      aiController.sendMessage(message);
      messageController.clear();
      onMessageSent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: theme.primary.withValues(alpha:0.5),
          ),
        ),
        gradient: LinearGradient(
          colors: [
            theme.primary.withValues(alpha:0.1),
            kHudBackground,
          ],
        ),
      ),
      child: Row(
        children: [
          // Text Input
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: AppTheme.getHudBoxDecoration(
                borderColor: theme.primary,
                shadowColor: theme.primary,
              ),
              child: TextField(
                controller: messageController,
                style: AppTheme.getHudTextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'ENTER QUERY...',
                  hintStyle: AppTheme.getHudTextStyle(
                    color: Colors.grey.withValues(alpha:0.6),
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.chat_bubble_outline,
                    color: theme.primary,
                    size: 20,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Send Button
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.primary,
                  theme.primary.withValues(alpha:0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: theme.primary.withValues(alpha:0.5),
                  blurRadius: 10.0,
                  spreadRadius: 2.0,
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.black),
              onPressed: _sendMessage,
              tooltip: 'Send Message',
            ),
          ),
        ],
      ),
    );
  }
}
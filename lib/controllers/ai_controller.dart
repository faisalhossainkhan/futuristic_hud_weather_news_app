import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../model/ai_chat_models.dart';

/// AI Controller with OpenRouter Integration
/// Manages AI chat using OpenRouter API (Claude 3.5 Sonnet)
class AIController extends GetxController {

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Add welcome message
    messages.add(ChatMessage(
      content: 'NEO-HUD AI ASSISTANT ONLINE. How may I assist you today?',
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  Future<void> sendMessage(String userMessage) async {
    if (userMessage.trim().isEmpty) return;

    // Add user message
    messages.add(ChatMessage(
      content: userMessage,
      isUser: true,
      timestamp: DateTime.now(),
    ));

    // Check if API key is configured
    if (kOpenRouterApiKey == 'YOUR_OPENROUTER_API_KEY') {
      _addMockResponse(userMessage);
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Build conversation history for context
      final conversationHistory = _buildConversationHistory();

      final response = await http.post(
        Uri.parse(kOpenRouterApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $kOpenRouterApiKey',
          'HTTP-Referer': 'https://neohud.app', // Optional: your app URL
          'X-Title': 'NEO-HUD System', // Optional: your app name
        },
        body: json.encode({
          'model': kOpenRouterModel,
          'messages': conversationHistory,
          'max_tokens': 1024,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final aiResponse = jsonResponse['choices'][0]['message']['content'];

        messages.add(ChatMessage(
          content: aiResponse,
          isUser: false,
          timestamp: DateTime.now(),
        ));
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key');
      } else if (response.statusCode == 429) {
        throw Exception('Rate limit exceeded');
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage.value = 'AI service temporarily unavailable';
      _addMockResponse(userMessage);
      print('OpenRouter API Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Build conversation history for OpenRouter API
  List<Map<String, String>> _buildConversationHistory() {
    // Get last 10 messages for context (excluding welcome message)
    final recentMessages = messages.skip(1).take(10).toList();

    return recentMessages.map((msg) {
      return {
        'role': msg.isUser ? 'user' : 'assistant',
        'content': msg.content,
      };
    }).toList();
  }

  void _addMockResponse(String userMessage) {
    // Mock AI responses for demo mode
    String response = 'PROCESSING QUERY...';

    final lowerMessage = userMessage.toLowerCase();

    if (lowerMessage.contains('weather')) {
      response = 'WEATHER SYSTEMS OPERATIONAL. Current conditions show nominal parameters. All sensors reporting accurate data. Forecast prediction algorithms functioning within expected parameters. Temperature readings stable. Atmospheric pressure normal. Recommend checking the weather panel for detailed metrics.';
    } else if (lowerMessage.contains('news')) {
      response = 'NEWS FEED AGGREGATION ACTIVE. Multiple sources synchronized. Real-time updates streaming from global networks. All channels operational. Categories include: Technology, Business, Sports, Politics, and General news. Information flow is continuous and validated.';
    } else if (lowerMessage.contains('system') || lowerMessage.contains('performance')) {
      response = 'SYSTEM DIAGNOSTICS: All core modules functioning at optimal capacity. CPU usage within normal parameters. Memory allocation stable. Network connectivity excellent. All subsystems reporting green status. Performance metrics indicate smooth operation across all interfaces.';
    } else if (lowerMessage.contains('help')) {
      response = 'NEO-HUD SYSTEM CAPABILITIES:\n\n• WEATHER MONITORING: Real-time atmospheric data and forecasts\n• NEWS AGGREGATION: Multi-source information streams from global outlets\n• SYSTEM DIAGNOSTICS: Performance monitoring and resource tracking\n• THEME CUSTOMIZATION: Visual interface configuration options\n• AI ASSISTANCE: Natural language query processing\n\nINQUIRY PROTOCOLS AVAILABLE. How may I assist you further?';
    } else if (lowerMessage.contains('hello') || lowerMessage.contains('hi') || lowerMessage.contains('hey')) {
      response = 'GREETINGS ACKNOWLEDGED. NEO-HUD SYSTEMS ONLINE AND READY. All modules functioning at optimal capacity. Standing by for your commands. How can I assist you today?';
    } else if (lowerMessage.contains('thank')) {
      response = 'ACKNOWLEDGMENT RECEIVED. Happy to assist. NEO-HUD systems remain at your service. Feel free to query any time.';
    } else if (lowerMessage.contains('status')) {
      response = 'SYSTEM STATUS CHECK:\n\n✓ Weather Module: OPERATIONAL\n✓ News Feed: ACTIVE\n✓ AI Assistant: ONLINE\n✓ Theme System: FUNCTIONAL\n✓ Data Sync: CONNECTED\n\nAll systems nominal. Ready for operation.';
    } else {
      response = 'QUERY ACKNOWLEDGED. Based on your input, I recommend checking the relevant system modules. All NEO-HUD features are accessible through the interface:\n\n• Weather data is available on the main dashboard\n• Global news feeds are continuously updated\n• System performance metrics are monitored in real-time\n\nWould you like specific information about weather, news, or system configuration?';
    }

    messages.add(ChatMessage(
      content: response,
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  void clearChat() {
    messages.clear();
    messages.add(ChatMessage(
      content: 'NEO-HUD AI ASSISTANT ONLINE. How may I assist you today?',
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }


  int get messageCount => messages.length;

  bool get hasMessages => messages.length > 1; // Excluding welcome message
}
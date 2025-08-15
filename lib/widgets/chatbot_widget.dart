import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../core/app_export.dart';
import '../services/openai_client.dart';
import '../services/openai_service.dart';
import '../theme/app_theme.dart';
import '../widgets/glassmorphic_container_widget.dart';

class ChatbotWidget extends StatefulWidget {
  const ChatbotWidget({super.key});

  @override
  State<ChatbotWidget> createState() => _ChatbotWidgetState();
}

class _ChatbotWidgetState extends State<ChatbotWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late OpenAIClient _openAIClient;

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isChatOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    try {
      final openAIService = OpenAIService();
      _openAIClient = OpenAIClient(openAIService.dio);
      _initializeChat();
    } catch (e) {
      debugPrint('OpenAI initialization error: $e');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeChat() {
    final welcomeMessage = ChatMessage(
      text:
          "Hi! I'm your HomeSnap Pro assistant! 👋\n\nI can help you with:\n• Service selection and pricing\n• Photo editing tips\n• Property staging advice\n• Technical support\n\nHow can I assist you today?",
      isUser: false,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(welcomeMessage);
    });
  }

  void _toggleChat() {
    setState(() {
      _isChatOpen = !_isChatOpen;
    });

    if (_isChatOpen) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    final userMessage = ChatMessage(
      text: messageText,
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _messageController.clear();
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      // Create context-aware system message
      final systemMessage = Message(
        role: 'system',
        content:
            '''You are a helpful AI assistant for HomeSnap Pro, a real estate photography service app. 
You should be friendly, professional, and knowledgeable about:

SERVICES & PRICING:
- Photo Editing: \$1.50 per photo
- Twilight Photos: \$15 per image  
- Virtual Staging: \$20 per image
- Small Item Removal (up to 3 items): \$5 per photo
- Large Item Removal (4+ items/furniture): \$12 per photo
- 2D Floorplan Creation: \$25 per floorplan
- White-Label Floorplans: +\$5 per floorplan
- Photo Branding: \$3 per job
- Branded Gallery Delivery: \$9 per delivery
- Monthly subscription: \$15/month for unlimited whitelabeling

HELP TOPICS:
- Guide users through service selection
- Explain pricing and delivery times
- Provide photography tips
- Troubleshoot technical issues
- Answer questions about the app features

Keep responses concise but helpful. Use a friendly, professional tone with occasional emojis.''',
      );

      final userMessageObj = Message(
        role: 'user',
        content: messageText,
      );

      final response = await _openAIClient.createChatCompletion(
        messages: [systemMessage, userMessageObj],
        model: 'gpt-4o-mini',
        options: {
          'max_tokens': 300,
          'temperature': 0.7,
        },
      );

      final botMessage = ChatMessage(
        text: response.text,
        isUser: false,
        timestamp: DateTime.now(),
      );

      setState(() {
        _messages.add(botMessage);
        _isLoading = false;
      });
    } catch (e) {
      final errorMessage = ChatMessage(
        text:
            "I apologize, but I'm having trouble connecting right now. Here are some quick answers:\n\n📸 Photo editing starts at \$1.50/photo\n🌅 Twilight photos are \$15/image\n🏠 Virtual staging is \$20/image\n📋 2D floorplans are \$25 each\n\nPlease try again or contact support!",
        isUser: false,
        timestamp: DateTime.now(),
      );

      setState(() {
        _messages.add(errorMessage);
        _isLoading = false;
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Chat interface
        if (_isChatOpen)
          Positioned(
            bottom: 16.h,
            right: 4.w,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: GlassmorphicContainer(
                opacity: 0.95,
                borderRadius: BorderRadius.circular(20),
                padding: EdgeInsets.zero,
                child: Container(
                  width: 85.w,
                  height: 60.h,
                  child: Column(
                    children: [
                      // Header
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: AppTheme.yellow,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 10.w,
                              height: 10.w,
                              decoration: BoxDecoration(
                                color: AppTheme.black,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Icon(
                                Icons.smart_toy,
                                color: AppTheme.yellow,
                                size: 6.w,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'HomeSnap Assistant',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: AppTheme.black,
                                    ),
                                  ),
                                  Text(
                                    'Your AI Journey Guide',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: AppTheme.black.withAlpha(179),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: _toggleChat,
                              icon: Icon(
                                Icons.close,
                                color: AppTheme.black,
                                size: 5.w,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Messages
                      Expanded(
                        child: Container(
                          color: AppTheme.white,
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.all(3.w),
                            itemCount: _messages.length + (_isLoading ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == _messages.length && _isLoading) {
                                return _buildTypingIndicator();
                              }
                              return _buildMessageBubble(_messages[index]);
                            },
                          ),
                        ),
                      ),

                      // Input
                      Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          border: Border(
                            top:
                                BorderSide(color: AppTheme.black.withAlpha(26)),
                          ),
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(20)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _messageController,
                                decoration: InputDecoration(
                                  hintText: 'Ask about services, pricing...',
                                  hintStyle: TextStyle(fontSize: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: AppTheme.black.withAlpha(51)),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 4.w, vertical: 2.w),
                                ),
                                onSubmitted: (_) => _sendMessage(),
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Container(
                              decoration: BoxDecoration(
                                color: AppTheme.yellow,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: IconButton(
                                onPressed: _isLoading ? null : _sendMessage,
                                icon: Icon(
                                  Icons.send,
                                  color: AppTheme.black,
                                  size: 5.w,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        // Chat button
        Positioned(
          bottom: 8.h,
          right: 4.w,
          child: GestureDetector(
            onTap: _toggleChat,
            child: Container(
              width: 14.w,
              height: 14.w,
              decoration: BoxDecoration(
                color: AppTheme.yellow,
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.yellow.withAlpha(102),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                _isChatOpen ? Icons.close : Icons.smart_toy,
                color: AppTheme.black,
                size: 7.w,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 2.w),
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.w),
        constraints: BoxConstraints(maxWidth: 70.w),
        decoration: BoxDecoration(
          color:
              message.isUser ? AppTheme.yellow : AppTheme.black.withAlpha(26),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message.text,
          style: GoogleFonts.poppins(
            color: message.isUser ? AppTheme.black : AppTheme.black,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 2.w),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.w),
        decoration: BoxDecoration(
          color: AppTheme.black.withAlpha(26),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 4.w,
              height: 4.w,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.black),
              ),
            ),
            SizedBox(width: 2.w),
            Text(
              'Thinking...',
              style: GoogleFonts.poppins(
                color: AppTheme.black,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

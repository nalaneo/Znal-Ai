import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => VoiceProvider()),
      ],
      child: const ZNALAIApp(),
    ),
  );
}

class ZNALAIApp extends StatelessWidget {
  const ZNALAIApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZNAL AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFFF00FF),
        scaffoldBackgroundColor: const Color(0xFF0A0D1A),
        useMaterial3: true,
      ),
      home: const ChatScreen(),
    );
  }
}

// ==================== PROVIDERS ====================

class ChatProvider extends ChangeNotifier {
  final List<ChatMessage> messages = [];
  int dailyLimit = 100;
  int chatCount = 0;
  bool isLoading = false;
  bool isThinking = false;
  String thinkingProcess = '';
  String selectedText = '';
  final String cioraApiKey = 'YOUR_CIORA_API_KEY'; // Ganti dengan API key lo
  final String cioraBaseUrl = 'https://api.ciora.my.id/v1/chat/completions';
  
  final uuid = const Uuid();

  ChatProvider() {
    _loadChatHistory();
    _checkDailyReset();
  }

  Future<void> _loadChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('chat_history') ?? [];
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final lastDate = prefs.getString('last_chat_date') ?? '';
    
    chatCount = prefs.getInt('chat_count') ?? 0;
    
    if (lastDate != today) {
      chatCount = 0;
      prefs.setString('last_chat_date', today);
    }
  }

  Future<void> _checkDailyReset() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final lastDate = prefs.getString('last_chat_date') ?? '';
    
    if (lastDate != today) {
      chatCount = 0;
      await prefs.setString('last_chat_date', today);
    }
  }

  Future<void> sendMessage(String text) async {
    if (chatCount >= dailyLimit) {
      _addMessage(ChatMessage(
        id: uuid.v4(),
        text: '❌ Limit chat harian ($dailyLimit) sudah habis. Coba besok!',
        isUser: false,
        timestamp: DateTime.now(),
      ));
      return;
    }

    _addMessage(ChatMessage(
      id: uuid.v4(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    ));

    chatCount++;
    isLoading = true;
    isThinking = true;
    notifyListeners();

    try {
      thinkingProcess = _generateThinkingProcess(text);
      notifyListeners();

      await Future.delayed(const Duration(seconds: 2));

      final response = await http.post(
        Uri.parse(cioraBaseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $cioraApiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o',
          'messages': [
            {'role': 'user', 'content': text}
          ],
          'max_tokens': 2000,
        }),
      ).timeout(const Duration(seconds: 30));

      isThinking = false;
      notifyListeners();

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final aiResponse = data['choices'][0]['message']['content'];
        
        _addMessage(ChatMessage(
          id: uuid.v4(),
          text: aiResponse,
          isUser: false,
          timestamp: DateTime.now(),
          thinkingProcess: thinkingProcess,
        ));
      } else {
        _addMessage(ChatMessage(
          id: uuid.v4(),
          text: '❌ Error: ${response.statusCode} - Ciora API tidak merespons',
          isUser: false,
          timestamp: DateTime.now(),
        ));
      }
    } catch (e) {
      _addMessage(ChatMessage(
        id: uuid.v4(),
        text: '❌ Error: $e',
        isUser: false,
        timestamp: DateTime.now(),
      ));
    } finally {
      isLoading = false;
      isThinking = false;
      notifyListeners();
    }
  }

  String _generateThinkingProcess(String prompt) {
    return '''
🧠 Thinking Process:

1. Parsing input: "${prompt.substring(0, 30)}..."
2. Analyzing context & intent
3. Retrieving relevant information
4. Generating response structure
5. Refining output quality
6. Checking for accuracy
7. Final response ready!
    '''.trim();
  }

  void _addMessage(ChatMessage message) {
    messages.add(message);
    notifyListeners();
  }

  void retryMessage(int index) {
    if (index > 0) {
      final lastUserMessage = messages[index - 1];
      if (lastUserMessage.isUser) {
        messages.removeAt(index);
        sendMessage(lastUserMessage.text);
      }
    }
  }

  void deleteMessage(int index) {
    messages.removeAt(index);
    notifyListeners();
  }
}

class VoiceProvider extends ChangeNotifier {
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool isListening = false;
  String recognizedText = '';

  Future<void> initSpeech() async {
    try {
      await _speechToText.initialize();
    } catch (e) {
      print('Error initializing speech: $e');
    }
  }

  Future<void> startListening() async {
    if (!isListening && _speechToText.isAvailable) {
      isListening = true;
      recognizedText = '';
      notifyListeners();

      await _speechToText.listen(
        onResult: (result) {
          recognizedText = result.recognizedWords;
          notifyListeners();
        },
        localeId: 'id_ID',
      );
    }
  }

  Future<void> stopListening() async {
    if (isListening) {
      isListening = false;
      await _speechToText.stop();
      notifyListeners();
    }
  }
}

// ==================== MODELS ====================

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  String? codeLanguage;
  String? thinkingProcess;
  bool showThinking = false;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.codeLanguage,
    this.thinkingProcess,
  });
}

// ==================== SCREENS ====================

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController _messageController;
  late ScrollController _scrollController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _scrollController = ScrollController();
    _focusNode = FocusNode();
    
    context.read<VoiceProvider>().initSpeech();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
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
    return Scaffold(
      backgroundColor: const Color(0xFF0A0D1A),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0A0D1A).withOpacity(0.8),
        title: const Text('ZNAL AI'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _showMenu(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettings(context),
          ),
        ],
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, _) {
          return Column(
            children: [
              // Chat Display
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: chatProvider.messages.length,
                  itemBuilder: (context, index) {
                    final message = chatProvider.messages[index];
                    return ChatBubble(
                      message: message,
                      onRetry: () => chatProvider.retryMessage(index),
                      onDelete: () => chatProvider.deleteMessage(index),
                      onShowThinking: () {
                        setState(() {
                          message.showThinking = !message.showThinking;
                        });
                      },
                    );
                  },
                ),
              ),

              // Loading Indicator
              if (chatProvider.isLoading)
                Container(
                  padding: const EdgeInsets.all(16),
                  child: const Column(
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Color(0xFFFF00FF)),
                      ),
                      SizedBox(height: 8),
                      Text('Thinking...', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),

              // Input Area
              _buildInputArea(context, chatProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInputArea(BuildContext context, ChatProvider chatProvider) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: const Color(0xFFFF00FF).withOpacity(0.2),
          ),
        ),
      ),
      child: Consumer<VoiceProvider>(
        builder: (context, voiceProvider, _) {
          return Row(
            children: [
              // Plus Button Menu
              CircleAvatar(
                backgroundColor: const Color(0xFF1A1D2E),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Color(0xFFFF00FF)),
                  onPressed: () => _showPlusMenu(context, chatProvider),
                ),
              ),
              const SizedBox(width: 8),

              // Input Field
              Expanded(
                child: TextField(
                  controller: _messageController,
                  focusNode: _focusNode,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      chatProvider.sendMessage(value);
                      _messageController.clear();
                      _scrollToBottom();
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Tanya ZNAL AI...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: const Color(0xFFFF00FF).withOpacity(0.2),
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Voice Button
              CircleAvatar(
                backgroundColor: voiceProvider.isListening
                    ? const Color(0xFFFF0099)
                    : const Color(0xFF1A1D2E),
                child: IconButton(
                  icon: Icon(
                    voiceProvider.isListening ? Icons.mic : Icons.mic_none,
                    color: const Color(0xFFFF00FF),
                  ),
                  onPressed: () async {
                    if (voiceProvider.isListening) {
                      await voiceProvider.stopListening();
                      if (voiceProvider.recognizedText.isNotEmpty) {
                        chatProvider.sendMessage(voiceProvider.recognizedText);
                        _scrollToBottom();
                      }
                    } else {
                      await voiceProvider.startListening();
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),

              // Send Button
              CircleAvatar(
                backgroundColor: const Color(0xFFFF00FF),
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      chatProvider.sendMessage(_messageController.text);
                      _messageController.clear();
                      _scrollToBottom();
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showPlusMenu(BuildContext context, ChatProvider chatProvider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1D2E),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          const Text('Tambahkan ke Chat', style: TextStyle(fontSize: 16)),
          const Divider(color: Color(0xFFFF00FF)),
          ListTile(
            leading: const Icon(Icons.camera_alt, color: Color(0xFFFF00FF)),
            title: const Text('Kamera'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.image, color: Color(0xFFFF00FF)),
            title: const Text('Foto'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.attach_file, color: Color(0xFFFF00FF)),
            title: const Text('File'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.language, color: Color(0xFFFF00FF)),
            title: const Text('Pencarian Web'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.storage, color: Color(0xFFFF00FF)),
            title: const Text('Memori'),
            subtitle: const Text('Tidak dapat diubah untuk obrolan ini'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.build, color: Color(0xFFFF00FF)),
            title: const Text('Akses Alat'),
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1D2E),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Riwayat Chat'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            title: const Text('Pengaturan'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pengaturan'),
        backgroundColor: const Color(0xFF1A1D2E),
        content: const Text('Settings coming soon...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

// ==================== WIDGETS ====================

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final VoidCallback onRetry;
  final VoidCallback onDelete;
  final VoidCallback onShowThinking;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.onRetry,
    required this.onDelete,
    required this.onShowThinking,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        // Thinking Process
        if (message.thinkingProcess != null && message.showThinking)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFF00FF).withOpacity(0.1),
              border: Border.all(
                color: const Color(0xFFFF00FF).withOpacity(0.3),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message.thinkingProcess!,
              style: const TextStyle(fontSize: 11, color: Color(0xFF00CCFF)),
            ),
          ),

        // Main Bubble
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: message.isUser
                ? const Color(0xFFFF00FF)
                : const Color(0xFF1A1D2E),
            borderRadius: BorderRadius.circular(12),
            border: !message.isUser
                ? Border.all(
                    color: const Color(0xFFFF00FF).withOpacity(0.2),
                  )
                : null,
          ),
          child: SelectableText(
            message.text,
            style: TextStyle(
              color: message.isUser ? Colors.white : Colors.white,
              fontSize: 14,
            ),
          ),
        ),

        // Action Buttons
        if (!message.isUser)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (message.thinkingProcess != null)
                GestureDetector(
                  onTap: onShowThinking,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      '🧠 Proses',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF00CCFF),
                      ),
                    ),
                  ),
                ),
              GestureDetector(
                onTap: onRetry,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    '🔄 Ulangi',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFFF00FF),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: onDelete,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    '🗑️ Hapus',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFFF0099),
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

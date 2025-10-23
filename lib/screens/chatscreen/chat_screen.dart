// lib/screens/chat_screen.dart

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapplication/hive/chat_message_model.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final Gemini gemini = Gemini.instance;

  ChatUser currentUser = ChatUser(id: "0");
  ChatUser geminiUser = ChatUser(id: "1");

  List<ChatMessage> messages = [];
  late Box<ChatMessageModel> chatBox;

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  // เปิด Hive และโหลดประวัติ
  Future<void> _initHive() async {
    chatBox = await Hive.openBox<ChatMessageModel>('chat_history');
    _loadMessages();
  }

  // โหลดข้อความจาก Hive
  void _loadMessages() {
    List<ChatMessage> loadedMessages = [];
    
    for (var chatModel in chatBox.values.toList().reversed) {
      loadedMessages.add(
        ChatMessage(
          user: chatModel.isUser ? currentUser : geminiUser, // ตรวจสอบว่าเป็น คน หรือ บอท 
          createdAt: chatModel.createdAt,
          text: chatModel.text,
        ),
      );
    }

    setState(() {
      messages = loadedMessages;
    });
  }

  // บันทึกข้อความลง Hive
  Future<void> _saveMessage(ChatMessage message, bool isUser) async {
    final chatModel = ChatMessageModel(
      userId: message.user.id,
      text: message.text,
      createdAt: message.createdAt,
      isUser: isUser,
    );
    await chatBox.add(chatModel);
  }

  // ลบประวัติ
  Future<void> _clearChatHistory() async {
    await chatBox.clear();
    setState(() {
      messages = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 21, 20, 95),
        title: Text(
          "แชทบอท",
          style: GoogleFonts.kanit(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    'ลบประวัติการแชท',
                    style: GoogleFonts.kanit(),
                  ),
                  content: Text(
                    'คุณต้องการลบประวัติการแชททั้งหมดหรือไม่?',
                    style: GoogleFonts.kanit(),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('ยกเลิก', style: GoogleFonts.kanit()),
                    ),
                    TextButton(
                      onPressed: () {
                        _clearChatHistory();
                        Navigator.pop(context);
                      },
                      child: Text('ลบ', style: GoogleFonts.kanit()),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return DashChat(
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
      messageOptions: MessageOptions(
        currentUserContainerColor: Color.fromARGB(255, 21, 20, 95),
        containerColor: Colors.grey[300]!,
        textColor: Colors.black,
        currentUserTextColor: Colors.white,
      ),
      inputOptions: InputOptions(
        inputDecoration: InputDecoration(
          hintText: 'พิมพ์ข้อความ...',
          hintStyle: GoogleFonts.kanit(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        sendButtonBuilder: (onSend) {
          return IconButton(
            icon: Icon(Icons.send, color: Color.fromARGB(255, 21, 20, 95)),
            onPressed: onSend,
          );
        },
      ),
    );
  }

  void _sendMessage(ChatMessage chatMessage) async {
    setState(() {
      messages = [chatMessage, ...messages];
    });

    // บันทึกข้อความของผู้ใช้
    await _saveMessage(chatMessage, true);

    try {
      String question = chatMessage.text;
      
      // สร้างกล่องข้อความของ bot
      ChatMessage botMessage = ChatMessage(
        user: geminiUser,
        createdAt: DateTime.now(),
        text: "",
      );
      
      setState(() {
        messages = [botMessage, ...messages];
      });

      String fullBotResponse = "";
      
      // ส่งข้อความที่ผู้ใช้พิมพ์ ให้ gemini api
      gemini.streamGenerateContent(question).listen(
        (event) {
          // ต่อคำที่ gemini ส่งมาให้เป็นประโยค
          String newText = event.content?.parts?.fold(
                  "", (previous, current) => "$previous${(current as TextPart).text}") ??
              "";
          
          fullBotResponse += newText;
          
          // update ui ข้อความของบอท
          setState(() {
            botMessage.text = fullBotResponse;
            messages = [botMessage, ...messages.where((m) => m != botMessage)];
          });
        },
        onDone: () async {
          // บันทึกข้อความของบอท
          await _saveMessage(botMessage, false);
        },
        onError: (error) {
          print('Error: $error');
        },
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    // ไม่ต้องปิด box เพราะจะใช้ต่อในแอพ
    super.dispose();
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myapplication/blank.dart';
import 'package:myapplication/hive/chat_message_model.dart';
import 'package:myapplication/noti_service.dart';
import 'package:myapplication/screens/menu%20screen/menu_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:myapplication/urls.dart';


//import 'package:myapplication/screens/signup_screen.dart';

void main() async{
 
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initialize();
  await initializeDateFormatting('th', null);
  await Hive.initFlutter();//
  Hive.registerAdapter(ChatMessageModelAdapter());
  Gemini.init(apiKey: GEMENI_API_KEY);
  runApp(const MyApp());
  
}

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:MenuScreen(),
    );
  }
}

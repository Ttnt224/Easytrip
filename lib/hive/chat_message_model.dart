// 1. สร้าง Model สำหรับเก็บข้อมูลข้อความ
import 'package:hive/hive.dart';

part 'chat_message_model.g.dart';

@HiveType(typeId: 0)
class ChatMessageModel extends HiveObject {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String text;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  final bool isUser;

  ChatMessageModel({
    required this.userId,
    required this.text,
    required this.createdAt,
    required this.isUser,
  });
}
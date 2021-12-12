import 'package:halo/models/models.dart';

class ConversationData {
  static List<Conversation> conversationList = [
    Conversation(
      id: '1',
      partner: User('1', 'Phạm Văn Hạnh', '0328665320', 'img1.jpeg'),
      message: Message(
          id: '1',
          message: 'Cố gắng lên nào!',
          created: DateTime(2021, 11, 1),
          unread: false),
      isMuted: false,
      isPined: false,
    ),
    Conversation(
      id: '2',
      partner: User('2', 'phientrandeptrai', '0327865320', 'img2.jpeg'),
      message: Message(
          id: '2',
          message: 'Ngày mai đi học không nhỉ',
          created: DateTime(2020, 10, 26),
          unread: true),
      isMuted: false,
      isPined: false,
    ),
    Conversation(
      id: '3',
      partner: User('3', 'hai trung', '0987865320', 'img3.jpeg'),
      message: Message(
          id: '3',
          message: 'Covid19 rồi',
          created: DateTime(2021, 9, 10),
          unread: false),
      isMuted: false,
      isPined: false,
    ),
    Conversation(
      id: '4',
      partner: User('4', 'Hương Mẫn', '0987865320', 'img3.jpeg'),
      message: Message(
          id: '4',
          message: 'Covid19 rồi',
          created: DateTime(2021, 9, 10),
          unread: false),
      isMuted: false,
      isPined: false,
    ),
    Conversation(
      id: '5',
      partner: User('5', 'haitrung2k', '0987865320', 'img3.jpeg'),
      message: Message(
          id: '5',
          message: 'Covid19 rồi',
          created: DateTime(2021, 9, 10),
          unread: false),
      isMuted: false,
      isPined: false,
    ),
    Conversation(
      id: '6',
      partner: User('6', 'haitrung2k', '0987865320', 'img3.jpeg'),
      message: Message(
          id: '6',
          message: 'Covid19 rồi',
          created: DateTime(2021, 9, 10),
          unread: false),
      isMuted: false,
      isPined: false,
    ),
    Conversation(
      id: '7',
      partner: User('7', 'haitrung2k', '0987865320', 'img3.jpeg'),
      message: Message(
          id: '7',
          message: 'Covid19 rồi',
          created: DateTime(2021, 9, 10),
          unread: false),
      isMuted: false,
      isPined: false,
    ),
    Conversation(
      id: '8',
      partner: User('8', 'haitrung2k', '0987865320', 'img3.jpeg'),
      message: Message(
          id: '8',
          message: 'Covid19 rồi',
          created: DateTime(2021, 9, 10),
          unread: false),
      isMuted: false,
      isPined: false,
    ),
    Conversation(
      id: '9',
      partner: User('9', 'haitrung2k', '0987865320', 'img3.jpeg'),
      message: Message(
          id: '9',
          message: 'Covid19 rồi',
          created: DateTime(2021, 9, 10),
          unread: false),
      isMuted: false,
      isPined: false,
    ),
    Conversation(
      id: '10',
      partner: User('10', 'haitrung2k', '0987865320', 'img3.jpeg'),
      message: Message(
          id: '10',
          message: 'Covid19 rồi',
          created: DateTime(2021, 9, 10),
          unread: false),
      isMuted: false,
      isPined: false,
    ),
  ];
}

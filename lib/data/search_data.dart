import 'package:halo/data/data.dart';
import 'package:halo/models/models.dart';

class SearchData {
  // 5 từ khoá tìm kiếm gần đây
  static List<String> searched_word = [
    'phien tran',
    'Minh Hai',
    'Hai trung',
    'Đình Lâm',
    'Minh Khôi'
  ];

  // 10 cuộc hội thoại tìm kiếm gần đây
  static List<Map<String, dynamic>> searched_chat = [];

  static List<Map<String, dynamic>> groupChatList = [];

  static List<Map<String, dynamic>> friendList = [];

  static List<Chat> cached_chat = [];
}

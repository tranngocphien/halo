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
  // Lưu lại id, ánh xạ qua cached_chat để load cho dễ
  static List<Chat> searched_chat = [];

  static List<Map<String, dynamic>> groupChatList = [];

  static List<Map<String, dynamic>> friendList = [];

  // Mình sẽ lưu lại chats, khi load ra tuỳ vào chỗ
  // Màn hình chính chỉ load các thứ có chứa tin nhắn
  // Tìm kiếm thì có nhiều thứ hơn
  static List<Chat> cached_chat = [];
}

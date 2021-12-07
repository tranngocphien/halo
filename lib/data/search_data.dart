import 'package:zalo/data/data.dart';
import 'package:zalo/models/models.dart';

class SearchData {
  // 5 từ khoá tìm kiếm gần đây
  static List<String> searchKeyword = [
    'phien tran',
    'Minh Hai',
    'Hai trung',
    'Đình Lâm',
    'Minh Khôi'
  ];

  // 10 cuộc hội thoại tìm kiếm gần đây
  static List<Conversation> recentSearchConversation =
      ConversationData.conversationList;
}

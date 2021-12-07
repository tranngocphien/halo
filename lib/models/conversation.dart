import 'message.dart';
import 'user.dart';

class Conversation {
  late String id;
  late User partner;
  late Message message;
  late bool isMuted;
  late DateTime mutedTo;
  late bool isPined;

  Conversation(
      {required this.id,
      required this.partner,
      required this.message,
      required this.isMuted,
      required this.isPined});
}

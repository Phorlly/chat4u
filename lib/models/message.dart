enum Type { text, image }

class MessageModel {
  var fromId, read, toId, message, sent;
  late Type type;

  MessageModel({
    required this.fromId,
    required this.read,
    required this.toId,
    required this.message,
    required this.type,
    required this.sent,
  });

  MessageModel.fromJson(Map<String, dynamic> get) {
    fromId = get['from_id'].toString();
    read = get['read'].toString();
    toId = get['to_id'].toString();
    message = get['message'].toString();
    // Convert the string to the enum value
    type = get['type'] == Type.image.name ? Type.image : Type.text;
    sent = get['sent'].toString();
  }

  Map<String, dynamic> toJson() {
    var post = <String, dynamic>{};
    post['from_id'] = fromId;
    post['read'] = read;
    post['to_id'] = toId;
    post['message'] = message;
    // Store the string representation of the enum value
    post['type'] = type.name;
    post['sent'] = sent;
    
    return post;
  }
}

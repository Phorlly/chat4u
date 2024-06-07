class UserModel {
  var id,
      image,
      created,
      about,
      name,
      lastActive,
      pushToken = '',
      email,
      isOnline = false;

  UserModel({
    required this.image,
    required this.created,
    required this.about,
    required this.name,
    required this.lastActive,
    required this.isOnline,
    required this.id,
    required this.pushToken,
    required this.email,
  });

  UserModel.fromJson(Map<String, dynamic> get) {
    image = get['image'] ?? "";
    created = get['created'] ?? "";
    about = get['about'] ?? "";
    name = get['name'] ?? "";
    lastActive = get['last_active'] ?? "";
    isOnline = get['is_online'] ?? "";
    id = get['id'] ?? "";
    pushToken = get['push_token'] ?? "";
    email = get['email'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final post = <String, dynamic>{};
    post['image'] = image;
    post['created'] = created;
    post['about'] = about;
    post['name'] = name;
    post['last_active'] = lastActive;
    post['is_online'] = isOnline;
    post['id'] = id;
    post['push_token'] = pushToken;
    post['email'] = email;

    return post;
  }
}

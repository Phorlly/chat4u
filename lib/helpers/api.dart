import 'dart:io';
import 'package:chat4u/firebase_options.dart';
import 'package:chat4u/models/message.dart';
import 'package:chat4u/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class Api {
  //for authentication
  static var auth = FirebaseAuth.instance;

  //for accessing cloud_firestore database
  static final firestore = FirebaseFirestore.instance;

  //for accessing cloud storage file
  static final storage = FirebaseStorage.instance;

  //to return current user
  static User get user => auth.currentUser!;

  //for storing set information
  static late UserModel me;

  //for upload image files
  static final picker = new ImagePicker();

  static var imagePath = "";

  static final userDoc = firestore.collection('users').doc(user.uid);
  static final time = DateTime.now().millisecondsSinceEpoch.toString();

  //for accessing firebase messaging (push notification dialog)
  static final messaging = FirebaseMessaging.instance;

  //for get getting firebase messaging token
  static Future<void> getMessageToken() async {
    await messaging.requestPermission();

    await messaging.getToken().then((token) {
      if (token != null) {
        me.pushToken = token;
        print("Your token: $token");
      }
    });
  }

  //for checking if user exists or not?
  static Future<bool> isExist() async {
    return (await userDoc.get()).exists;
  }

  //for adding an chat user for our conversation
  static Future<bool> addNew({required String email}) async {
    final req = await firestore
        .collection('users')
        .where("email", isEqualTo: email)
        .get();

    if (req.docs.isNotEmpty && req.docs.first.id != user.uid) {
      //user is existing
      await userDoc.collection('friends').doc(req.docs.first.id).set({});

      return true;
    } else {
      //user not exist
      return false;
    }
  }

  //for initial app in firebase
  static Future<void> initFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  //for getting current user information
  static Future<void> getCurrentUser() async {
    await userDoc.get().then((value) async {
      if (value.exists) {
        me = UserModel.fromJson(value.data()!);
        await getMessageToken();

        //for setting user status to active
        Api.updateActiveStatus(true);
      } else {
        await createNew().whenComplete(() => getCurrentUser());
      }
    });
  }

  //for creating a new user
  static Future<void> createNew() async {
    final model = new UserModel(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      about: "Hey, I'm using Chat 4U!",
      image: user.photoURL.toString(),
      created: time,
      isOnline: false,
      lastActive: time,
      pushToken: '',
    );

    await userDoc.set(model.toJson());
  }

  //for getting id's of know users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getFriendsId() {
    return userDoc.collection("friends").snapshots();
  }

  //for getting all datas from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUsers(
      {required List<String> friends}) {
    print("Your Friend Id : $friends");
    return firestore
        .collection("users")
        .where("id", whereIn: friends)
        // .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  //for getting current user information
  static Future<void> updateUser() async {
    await userDoc.update({"name": me.name, "about": me.about});
  }

  //for choosing the files from gallery to upload
  static Future<String> fromGallery(context) async {
    // Pick an image.
    final image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (image != null) {
      // print("Image path: ${image.path} --MimeType: ${image.mimeType}");
      imagePath = image.path;
      // LinkPage.linkBack(context);
    }

    return imagePath;
  }

  //for choosing the files from camera to upload
  static Future<String> fromCamera(context) async {
    // Capture a photo.
    final photo =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 70);

    if (photo != null) {
      // print("Image path: ${photo.path} --MimeType: ${photo.mimeType}");
      imagePath = photo.path;
      // LinkPage.linkBack(context);
    }

    return imagePath;
  }

  //get getting specific user info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      UserModel model) {
    return firestore
        .collection("users")
        .where("id", isEqualTo: model.id)
        .snapshots();
  }

  //update online or last active status of user
  static Future<void> updateActiveStatus(bool isOnline) async {
    await firestore.collection("users").doc(user.uid).update({
      "is_online": isOnline,
      "last_active": DateTime.now().millisecondsSinceEpoch.toString(),
      "push_token": me.pushToken
    });
  }

  //for picture profile
  static Future<void> updateProfile(File file) async {
    //for get extension of file
    final ext = file.path.split('.').last;

    //storage file ref with path
    final ref = storage.ref().child('uploads/${user.uid}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((val) {
      print("Data Transfered => ${val.bytesTransferred / 1000} kb");
    });

    //uploading image in  firebase database
    me.image = await ref.getDownloadURL();
    // print("This image Url is => ${me.image}");
    await userDoc.update({"image": me.image});
  }

  //=================Chat Page Related API =================
  //chats (collection) ==> conversation_id(doc) ==> messages(collection) ==> messages(doc)
  static String getConversationId(String id) {
    return user.uid.hashCode <= id.hashCode
        ? '${user.uid}_$id'
        : '${id}_${user.uid}';
  }

  //for getting all datas from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(
      {required UserModel model}) {
    return firestore
        .collection("chats/${getConversationId(model.id)}/messages/")
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<void> sendMessage(
      {required UserModel model,
      required String message,
      required Type type}) async {
    final req = new MessageModel(
        fromId: user.uid,
        read: '',
        toId: model.id,
        message: message,
        type: type,
        sent: time);

    final res =
        firestore.collection("chats/${getConversationId(model.id)}/messages/");
    await res.doc(time).set(req.toJson());
  }

  static Future<void> updateStatus({required MessageModel model}) async {
    final res = firestore
        .collection("chats/${getConversationId(model.fromId)}/messages/");
    await res.doc(model.sent).update({'read': time});
  }

  //get only last message of a specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      {required UserModel model}) {
    return firestore
        .collection("chats/${getConversationId(model.id)}/messages/")
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  //send image chat
  static Future<void> sendImage(
      {required UserModel model, required File file}) async {
    //for get extension of file
    final ext = file.path.split('.').last;

    //storage file ref with path
    final ref = storage.ref().child(
        'images/${getConversationId(model.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((val) {
      print("Data Transfered => ${val.bytesTransferred / 1000} kb");
    });

    //uploading image in  firebase database
    final imageUrl = await ref.getDownloadURL();

    await sendMessage(model: model, message: imageUrl, type: Type.image);
  }

  static Future<void> deleteMessage({required MessageModel model}) async {
    await firestore
        .collection("chats/${getConversationId(model.toId)}/messages/")
        .doc(model.sent)
        .delete();

    if (model.type == Type.image)
      await storage.refFromURL(model.message).delete();
  }

  static Future<void> updateMessage(
      {required MessageModel model, required String message}) async {
    await firestore
        .collection("chats/${getConversationId(model.toId)}/messages/")
        .doc(model.sent)
        .update({"message": message});
  }
}

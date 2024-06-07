import 'dart:io';
import 'package:chat4u/firebase_options.dart';
import 'package:chat4u/helpers/link.dart';
import 'package:chat4u/models/message.dart';
import 'package:chat4u/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class Api {
  //for authentication
  static final auth = FirebaseAuth.instance;

  //for accessing cloud_firestore database
  static final firestore = FirebaseFirestore.instance;

  //for accessing cloud storage file
  static final storage = FirebaseStorage.instance;

  //to return current user
  static User get user => auth.currentUser!;

  //for storing selt information
  static late UserModel me;

  //for upload image files
  static final picker = ImagePicker();

  static var imagePath = "";

  static final userDoc = firestore.collection('users').doc(user.uid);
  static final time = DateTime.now().millisecondsSinceEpoch.toString();

  //for checking if user exists or not?
  static Future<bool> isExist() async {
    return (await userDoc.get()).exists;
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

  //for getting all datas from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUsers() {
    return firestore
        .collection("users")
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  //for getting current user information
  static Future<void> updateUser() async {
    await userDoc.update({"name": me.name, "about": me.about});
  }

  //for choosing the files from gallery to upload
  static Future<String> fromGallery(context) async {
    // Pick an image.
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // print("Image path: ${image.path} --MimeType: ${image.mimeType}");
      imagePath = image.path;
      LinkPage.linkBack(context);
    }

    return imagePath;
  }

  //for choosing the files from camera to upload
  static Future<String> fromCamera(context) async {
    // Capture a photo.
    final photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      // print("Image path: ${photo.path} --MimeType: ${photo.mimeType}");
      imagePath = photo.path;
      LinkPage.linkBack(context);
    }

    return imagePath;
  }

  //for picture profile
  static Future<void> updateProfile(File file) async {
    //for get extension of file
    final ext = file.path.split('.').last;
    // print("Extension: " + ext);

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
        .snapshots();
  }

  static Future<void> sendMessage(
      {required UserModel model, required String message}) async {
    final req = new MessageModel(
        fromId: user.uid,
        read: '',
        toId: model.id,
        message: message,
        type: Type.text,
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
}

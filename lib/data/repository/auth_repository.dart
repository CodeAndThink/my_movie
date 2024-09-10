import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_movie/data/models/comment.dart';
import 'package:my_movie/data/models/notification_model.dart';
import 'dart:convert';
import 'dart:io';
import 'package:my_movie/data/models/user.dart' as my_user;
import 'package:my_movie/data/models/user_display_info.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final _secureStorage = const FlutterSecureStorage();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  AuthRepository(this._firebaseAuth);

  Future<UserCredential> signIn(String email, String password) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<UserCredential> signUp(String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<String> createUserDocument(my_user.User newUser) async {
    String userId = _firestore.collection('users').doc().id;

    await _firestore.collection('users').doc(userId).set({
      'email': newUser.email,
      'displayName': newUser.displayName,
      'dob': newUser.dob,
      'gender': newUser.gender,
      'phone': newUser.phone,
      'address': newUser.address,
      'password': newUser.password,
      'avatarPath': newUser.avatarPath,
      'createDate': newUser.createDate,
      'favoritesList': newUser.favoritesList,
      'commentIds': newUser.commentIds
    });

    return userId;
  }

  Future<String> createUserComment(Comment comment) async {
    String commentId = _firestore.collection('comments').doc().id;

    await _firestore.collection('comments').doc(commentId).set({
      'userId': comment.userId,
      'url': comment.url,
      'author': comment.author,
      'movieId': comment.movieId,
      'content': comment.content,
      'createdAt': comment.createdAt,
      'updatedAt': comment.updatedAt,
      'favoriteLevel': comment.favoriteLevel
    });

    return commentId;
  }

  Future<List<Comment>> getMymovieCommentsByMovieId(int movieId) async {
    try {
      final querySnapshot = await _firestore
          .collection('comments')
          .where('movieId', isEqualTo: movieId)
          .get();

      final comments = querySnapshot.docs.map((doc) {
        return doc.data();
      }).toList();

      final List<Map<String, dynamic>> listCommentsJson = comments;
      final List<Comment> listComments =
          listCommentsJson.map((json) => Comment.fromJson(json)).toList();

      return listComments;
    } catch (e) {
      throw Exception('Failed to get comments: $e');
    }
  }

  Future<List<Comment>> getMymovieCommentsByUserId(String userDocId) async {
    try {
      final querySnapshot = await _firestore
          .collection('comments')
          .where('userId', isEqualTo: userDocId)
          .get();

      final comments = querySnapshot.docs.map((doc) {
        return doc.data();
      }).toList();
      final List<Map<String, dynamic>> listCommentsJson = comments;
      final List<Comment> listComments =
          listCommentsJson.map((json) => Comment.fromJson(json)).toList();
      return listComments;
    } catch (e) {
      throw Exception('Failed to get comments: $e');
    }
  }

  Future<void> createUserMetadata(String uid, String docId) async {
    await _firestore.collection('user_metadata').doc(uid).set({
      'docId': docId,
    });
  }

  Future<Map<String, dynamic>> fetchUserData(String userId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    if (userDoc.exists) {
      return userDoc.data()!;
    } else {
      throw Exception("User not found");
    }
  }

  Future<Map<String, dynamic>> fetchDocId(String docId) async {
    final userDoc =
        await _firestore.collection('user_metadata').doc(docId).get();
    if (userDoc.exists) {
      return userDoc.data()!;
    } else {
      throw Exception("Doc Id not found");
    }
  }

  Future<void> createUserData(Map<String, dynamic> userData) async {
    await _firestore.collection('users').add(userData);
  }

  Future<void> updateUserData(
      String userId, Map<String, dynamic> updatedData) async {
    await _firestore.collection('users').doc(userId).update(updatedData);
  }

  Future<void> updateUserDocumentId(String userDocId, String docId) async {
    await _firestore.collection('users').doc(userDocId).update({
      'commentIds': FieldValue.arrayUnion([docId])
    });
  }

  Future<void> deleteUserData(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
  }

  Future<void> updateFavorite(String userId, List<int> updatedData) async {
    await _firestore.collection('users').doc(userId).update({
      'favoritesList': updatedData,
    });
  }

  Future<String> uploadImage(String filePath) async {
    final File file = File(filePath);
    final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final Reference storageRef = _storage.ref().child('avatars/$fileName');
    final UploadTask uploadTask = storageRef.putFile(file);
    final TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> storeEmailIfNotExists(String email) async {
    final storedEmailsString =
        await _secureStorage.read(key: 'lastLoggedInEmail');
    List<String> storedEmails = storedEmailsString != null
        ? List<String>.from(jsonDecode(storedEmailsString))
        : [];

    if (!storedEmails.contains(email)) {
      storedEmails.add(email);

      await _secureStorage.write(
        key: 'lastLoggedInEmail',
        value: jsonEncode(storedEmails),
      );
    }
  }

  Future<String> getDeviceToken() async {
    return await _firebaseMessaging.getToken() ?? '';
  }

/////////////////////////////////////////////////////////
  ///
///////////Subcribe to topic of message//////////////////

  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  List<Map<String, dynamic>> notificationsToJson(
      List<NotificationModel> notifications) {
    return notifications.map((notification) => notification.toJson()).toList();
  }

  Future<void> storeNotifications(List<NotificationModel> notifications) async {
    final List<Map<String, dynamic>> notificationsJson =
        notifications.map((n) => n.toJson()).toList();
    final String notificationsString = jsonEncode(notificationsJson);
    await _secureStorage.write(
        key: 'notifications', value: notificationsString);
  }

  Future<List<NotificationModel>> loadNotifications() async {
    final String? notificationsString =
        await _secureStorage.read(key: 'notifications');
    if (notificationsString != null) {
      final List<dynamic> decodedList =
          jsonDecode(notificationsString) as List<dynamic>;
      return decodedList
          .map((json) =>
              NotificationModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      return [];
    }
  }

/////////////////////////////////////////////////////////
  ///
///////////Fetch comment by user id//////////////////////

  Future<List<UserDisplayInfo>> fetchListUserCommentData(
      List<String> userIds) async {
    List<UserDisplayInfo> usersData = [];

    for (String userId in userIds) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        UserDisplayInfo userData = UserDisplayInfo(
          userDoc['displayName'] as String,
          userDoc['avatarPath'] as String,
        );

        usersData.add(userData);
      }
    }

    return usersData;
  }
}

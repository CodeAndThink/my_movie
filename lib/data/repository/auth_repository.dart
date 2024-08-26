import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'dart:io';

import 'package:my_movie/data/models/user.dart' as my_user;

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final _secureStorage = const FlutterSecureStorage();

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
      'id': newUser.id,
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
    });

    return userId;
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
}

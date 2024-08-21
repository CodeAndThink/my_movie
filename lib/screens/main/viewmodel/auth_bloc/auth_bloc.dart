import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:my_movie/data/models/user.dart' as MyUser;

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final _secureStorage = const FlutterSecureStorage();

  AuthBloc(this._firebaseAuth) : super(AuthInitial()) {
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<FetchUserData>(_onFetchUserData);
    on<CreateUserData>(_onCreateUserData);
    on<UpdateUserData>(_onUpdateUserData);
    on<DeleteUserData>(_onDeleteUserData);
    // on<AuthUpdateProfilePicture>(_onUpdateProfilePicture);
  }

  Future<void> _onSignInRequested(
      AuthSignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthInProgress());
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      final docIdSnapshot = await _firestore
          .collection('user_metadata')
          .doc(userCredential.user!.uid)
          .get();
      final docId = docIdSnapshot.data()?['docId'] as String? ?? '';

      await _secureStorage.write(key: 'lastLoggedInEmail', value: event.email);
      await _secureStorage.write(
          key: 'lastLoggedInPassword', value: event.password);

      emit(AuthAuthenticated(userCredential.user!, docId));
      print("This is user: ${userCredential.user!}");
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onSignOutRequested(
      AuthSignOutRequested event, Emitter<AuthState> emit) async {
    emit(AuthInProgress());
    try {
      await _firebaseAuth.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onSignUpRequested(
      AuthSignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthInProgress());
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      String userId = _firestore.collection('users').doc().id;

      MyUser.User newUser = MyUser.User(
        id: userId,
        email: event.email,
        displayName: 'User $userId',
        dob: '01/01/2000',
        gender: 1,
        phone: '0123456789',
        address: 'Địa chỉ',
        password: event.password,
        avatarPath:
            'https://firebasestorage.googleapis.com/v0/b/flutter-movie-app-9eb63.appspot.com/o/man.png?alt=media&token=b62057de-25bb-4271-b578-0dbccd15506f',
        createDate: DateTime.now().toIso8601String(),
        favoritesList: [],
      );

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
        'favoritesList':
            newUser.favoritesList.map((movie) => movie.toJson()).toList(),
      });

      await _firestore
          .collection('user_metadata')
          .doc(userCredential.user!.uid)
          .set({
        'docId': userId,
      });

      emit(AuthAuthenticated(userCredential.user!, userId));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onFetchUserData(
      FetchUserData event, Emitter<AuthState> emit) async {
    try {
      emit(UserDataLoading());
      final userDoc =
          await _firestore.collection('users').doc(event.userId).get();
      if (userDoc.exists) {
        emit(UserDataLoaded(userDoc.data()!));
      } else {
        emit(AuthFailure("User not found"));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onCreateUserData(
      CreateUserData event, Emitter<AuthState> emit) async {
    try {
      await _firestore.collection('users').add(event.userData);
      emit(UserDataCreated());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onUpdateUserData(
      UpdateUserData event, Emitter<AuthState> emit) async {
    try {
      await _firestore
          .collection('users')
          .doc(event.userId)
          .update(event.updatedData);
      emit(UserDataUpdated());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onDeleteUserData(
      DeleteUserData event, Emitter<AuthState> emit) async {
    try {
      await _firestore.collection('users').doc(event.userId).delete();
      emit(UserDataDeleted());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

//   Future<void> _onUpdateProfilePicture(
//     AuthUpdateProfilePicture event, Emitter<AuthState> emit) async {
//   emit(AuthInProgress());
//   try {
//     final String downloadUrl = await _uploadImage(event.imagePath);
//     final currentUser = (state as AuthAuthenticated).user;

//     final updatedUser = MyUser.User(
//       id: currentUser.uid,
//       email: currentUser.email,
//       displayName: currentUser.displayName,
//       dob: currentUser.,
//       gender: currentUser.gender,
//       phone: currentUser.phone,
//       address: currentUser.address,
//       password: currentUser.password,
//       avatarPath: downloadUrl,
//       createDate: currentUser.createDate,
//       favoritesList: currentUser.favoritesList,
//     );

//     await _firestore.collection('users').doc(currentUser.id).update({
//       'avatarPath': downloadUrl,
//     });

//     emit(AuthProfilePictureUpdated(downloadUrl));
//     emit(AuthAuthenticated(updatedUser));
//   } catch (e) {
//     emit(AuthFailure(e.toString()));
//   }
// }

  Future<String> _uploadImage(String filePath) async {
    final File file = File(filePath);
    final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final Reference storageRef = _storage.ref().child('avatars/$fileName');
    final UploadTask uploadTask = storageRef.putFile(file);
    final TaskSnapshot snapshot = await uploadTask;
    final String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}

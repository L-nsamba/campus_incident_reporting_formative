import 'package:campus_reporting_app/enum/user_role_enum.dart';
import 'package:campus_reporting_app/models/app_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Current Firebase Authentication user
  User? get currentFirebaseUser => _auth.currentUser;

  // Listening for login/logout changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Registering a students account
  Future<AppUser> registerStudent({
    required String name,
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email
        .trim()
        .toLowerCase(); // Trimming white space and conversion to lower case

    if (!normalizedEmail.endsWith('@alustudent.com')) {
      throw Exception(
        'Please user your ALU student email address',
      ); // Students only register with ALU email
    }

    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final firebaseUser = credential.user!;

    try {
      await firebaseUser.updateDisplayName(name.trim());

      final appUser = AppUser(
        uid: firebaseUser.uid,
        name: name,
        email: email,
        role: UserRoleEnum.student,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(firebaseUser.uid).set({
        ...appUser.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      await firebaseUser.sendEmailVerification();

      return appUser;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Logging into existing account
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user!;

    if (!user.emailVerified) {
      await _auth.signOut();
      throw Exception('Please verify your email before logging in.');
    }

    return credential;
  }

  // Sending of verification email
  Future<void> resendVerificationEmail() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('No account is currently signed in.');
    }

    if (!user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  // Signing out
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Loading a user's profile from Firestone
  Future<AppUser?> getUserProfile(String uid) async {
    final document = await _firestore.collection('users').doc(uid).get();

    if (!document.exists || document.data() == null) {
      return null;
    }

    return AppUser.fromMap(document.data()!, document.id);
  }
}

import 'package:campus_reporting_app/models/app_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<AppUser?> getUserById(String uid) async {
    try {
      final document = await _firestore.collection('users').doc(uid).get();

      if (!document.exists || document.data() == null) {
        return null;
      }

      return AppUser.fromMap(document.data()!, document.id);
    } catch (e) {
      throw Exception('Failed to retrieve user profile: $e');
    }
  }
}

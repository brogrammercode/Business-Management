import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gas/core/utils/location.dart';
import 'package:gas/features/auth/domain/repo/auth_repo.dart';
import 'package:gas/features/employee/data/models/employee_model.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRemoteDs implements AuthRepo {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _addUser({required EmployeeModel employee}) async {
    try {
      final employeeCollection = _firestore.collection('employees');
      await employeeCollection.doc(employee.id).set(employee.toJson());
    } catch (e) {
      throw Exception('Failed to add employee: $e');
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google sign-in was cancelled');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);

      final user = userCredential.user;
      if (user != null) {
        final userSnapshot = await _firestore
            .collection('employees')
            .doc(user.uid)
            .get();
        if (!userSnapshot.exists) {
          final newUser = EmployeeModel(
            id: user.uid,
            email: user.email ?? "",
            name: user.displayName ?? "",
            avatar: user.photoURL ?? "",
            bio: "",
            address: UserLocationModel(),
            dob: Timestamp.now(),
            aadharNo: "",
            phoneNo: user.phoneNumber ?? "",
            bankAccountNo: "",
            upiID: "",
            drivingLicenseURL: "",
            panCardURL: "",
            businessID: "",
            creationTD: Timestamp.now(),
            createdBy: user.uid,
            deactivate: false,
          );
          await _addUser(employee: newUser);
        }
      }
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }
}

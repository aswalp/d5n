import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthServices {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<User?> get authStateChange => auth.authStateChanges();
  Future<UserCredential> createAccount(String email, String password) {
    return auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<UserCredential> login(String email, String password) {
    return auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logout() {
    return auth.signOut();
  }
}

final authServicesProvider = Provider<AuthServices>((ref) {
  return AuthServices();
});
final authProvider = StreamProvider((ref) {
  return ref.read(authServicesProvider).authStateChange;
});

import 'package:firebase_auth/firebase_auth.dart';
import 'package:money_tracker/models/exception_login.dart';
import '../firebase_options.dart';

class LoginRepository {
  LoginRepository({required this.firebase});
  final FirebaseAuth firebase;

  Future<void> signIn({required String email, required String password}) async {
    try {
      await firebase.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw ExceptionLogin('Такой пользователь не зарегистрирован!');
      } else if (e.code == 'wrong-password') {
        throw ExceptionLogin('Неправильный пароль!');
      }
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    try {
      await firebase.createUserWithEmailAndPassword(
          email: email, password: password);
      throw 'Новый пользователь зарегистрирован!';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw ExceptionLogin('Такой e-mail уже зарегистрирован!');
      } else if (e.code == 'weak-password') {
        throw ExceptionLogin('Пароль должен быть не менее 6 символов!');
      }
    }
  }

  Future<void> signOut() async {
    await firebase.signOut();
  }
}

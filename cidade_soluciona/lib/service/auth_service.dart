import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/services_db.dart';
import 'notify_user.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? usuario;
  bool isLoading = true;
  bool updating = false;

  AuthService() {
    _authCheck();
  }

  _authCheck() {
    _auth.authStateChanges().listen(
      (User? user) {
        usuario = (user == null) ? null : user;
        isLoading = false;
        notifyListeners();
      },
    );
  }

  _getUser() {
    usuario = _auth.currentUser;
    notifyListeners();
  }

  login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      isLoading = false;
      _getUser();
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'user-not-found') {
        throw AuthException(message: 'Usuario não encontrado. Cadastre-se');
      } else if (e.code == 'wrong-password') {
        throw AuthException(message: 'Senha incorreta. Tente novamente');
      } else if (e.code == 'too-many-requests') {
        throw AuthException(
            message: 'Acesso bloqueado, tente novamente mais tarde');
      }
    }
  }

  register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      isLoading = false;
      _getUser();
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'weak-password') {
        throw AuthException(message: 'Senha fraca');
      } else if (e.code == 'email-already-in-use') {
        throw AuthException(message: 'Email já cadastrado');
      } else {
        throw AuthException(message: e.code);
      }
    }
  }

  Future<void> recover(String email, context) async {
    await _auth
        .sendPasswordResetEmail(email: email)
        .then((value) => {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.green,
                content: const Text('Email enviado para resetar senha'),
                duration: const Duration(seconds: 5),
                action: SnackBarAction(
                  label: 'DISMISS',
                  textColor: Colors.white,
                  onPressed: () {},
                ),
              )),
            })
        .catchError((onError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: const Text('Erro ao enviar codigo de recuperação'),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'DISMISS',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ));
    });
  }

  logOut() async {
    await _auth.signOut();
    isLoading = true;
    _getUser();
  }

  updateEmail(String newEmail, String password, context) async {
    try {
      final db = ServicesDB();
      await _auth.signInWithEmailAndPassword(
        email: usuario!.email!,
        password: password,
      );
      db.getMakers(context);
      await _auth.currentUser!.updateEmail(newEmail).whenComplete(
          () => NotifyUser.showScackbar(context, 'Atualizado com sucesso'));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw AuthException(message: 'Antes faça login novamente');
      }
    }
  }

  updatePassword(String newPassword, String password, context) async {
    try {
      final db = ServicesDB();
      await _auth.signInWithEmailAndPassword(
        email: usuario!.email!,
        password: password,
      );
      await _auth.currentUser!.updatePassword(newPassword).whenComplete(
          () => NotifyUser.showScackbar(context, 'Atualizado com sucesso'));
      db.getMakers(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw AuthException(message: 'Antes faça login novamente');
      }
    }
  }
}

class AuthException implements Exception {
  String message;
  AuthException({required this.message});
}

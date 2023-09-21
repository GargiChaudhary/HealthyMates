import 'package:flutter/material.dart';
import 'package:healthy_mates/models/user.dart' as model;
import 'package:healthy_mates/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  model.User? _user;
  final AuthMethods _authMethods = AuthMethods();
  model.User get getUser => _user!;
  Future<void> refreshUser() async {
    model.User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}

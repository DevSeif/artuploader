import 'package:artupload/repository/auth_service.dart';
import 'package:flutter/cupertino.dart';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  UserData? _user;
  bool _loading = false;

  bool get loading => _loading;
  UserData? get user => _user;

  signOut() async {
    await AuthService().authSignout();
    UserData myUser = UserData(username: 'Anonymous', uid: '', email: '');
    _user = myUser;
  }

  Future signUp(String username, String email, String password) async{
    String res = await AuthService().authSignup(username, email, password);
    if(res == 'success'){
      UserData myUser = await AuthService().getUsername();
      _user = myUser;
    }
  }

  Future signIn(String email, String password)async{
    String res = await AuthService().authLogin(email, password);
    if(res == 'success'){
     UserData myUser = await AuthService().getUsername();
     _user = myUser;
    }
  }

  refreshUser() async {
    String? userEmail = await AuthService().getCurrentUser();
    notifyListeners();
  }

  setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }
}

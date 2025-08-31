import '../../models/login_emp__model.dart';
import '../../models/login_user_model.dart';

abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class LoadingState extends AuthStates {}

class LoginSuccessState extends AuthStates {
  final Login_emp_Model loginModel;

  LoginSuccessState(this.loginModel);

}

class Login_UserSuccessState extends AuthStates {
  final LoginResponse loginModel;

  Login_UserSuccessState(this.loginModel);

}
class LoginErrorState extends AuthStates {}

class LogoutSuccessState extends AuthStates {}
class LogoutErrorState extends AuthStates {}

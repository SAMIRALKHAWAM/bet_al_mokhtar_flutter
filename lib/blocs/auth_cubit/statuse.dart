import '../../models/login_model.dart';

abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

class LoadingState extends AuthStates {}

class LoginSuccessState extends AuthStates {
  final LoginModel loginModel;

  LoginSuccessState(this.loginModel);

}
class LoginErrorState extends AuthStates {}

class LogoutSuccessState extends AuthStates {}
class LogoutErrorState extends AuthStates {}

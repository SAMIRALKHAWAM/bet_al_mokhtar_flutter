


part of 'password_visibility_cubit.dart';

abstract class PasswordVisibilityState {
  final bool isObscure;

  const PasswordVisibilityState(this.isObscure);
}

class PasswordVisibilityInitial extends PasswordVisibilityState {
  PasswordVisibilityInitial() : super(true);
}

class PasswordVisibilityChanged extends PasswordVisibilityState {
  const PasswordVisibilityChanged(bool isObscure) : super(isObscure);
}

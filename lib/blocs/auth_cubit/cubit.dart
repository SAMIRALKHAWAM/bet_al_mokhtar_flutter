import 'package:almoktar/blocs/auth_cubit/statuse.dart';
import 'package:almoktar/network/cash_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/login_emp__model.dart';
import '../../models/login_user_model.dart';
import '../../network/dio_helper.dart';
import '../../network/end_point.dart';
import '../../network/cash_helper.dart';


class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitialState());

  static AuthCubit get(context) => BlocProvider.of(context);

  ///////////////////////////////////////////////  change_internal_order_status
  Login_emp_Model? loginModel;

  void Login_emp({required user_name, required password}) {
    emit(LoadingState());

    DioHelper.postData(
      url: baseurl + "employee_login",
      data: {"password": password, "user_name": user_name},
    ).then((value) {
      loginModel = Login_emp_Model.fromJson(value.data);

      emit(LoginSuccessState(loginModel!));


      // print(value.data);
    })
      ..catchError((error) {
        if (error is DioError) {
          // طبع الخطأ الأساسي
          print("Dio error message: ${error.message}");

          // طبع استجابة السيرفر لو موجودة
          if (error.response != null) {
            print("Status code: ${error.response?.statusCode}");
            print("Response data: ${error.response?.data}");
          }
        } else {
          // لو الخطأ مش DioError اطبع النص عادي
          print("Error: ${error.toString()}");
        }

        emit(LoginErrorState());
      });
  }

  //////////////////////////////////////////////////////////  Logout_emp


  void Logout_emp() {
    emit(LoadingState());

    DioHelper.postData(
      url: baseurl + "employee_logout",
    ).then((value) {

    CachHelper.removeData(key: "token");

      emit(LogoutSuccessState());


      // print(value.data);
    })
      ..catchError((error) {
        if (error is DioError) {
          // طبع الخطأ الأساسي
          print("Dio error message: ${error.message}");

          // طبع استجابة السيرفر لو موجودة
          if (error.response != null) {
            print("Status code: ${error.response?.statusCode}");
            print("Response data: ${error.response?.data}");
          }
        } else {
          // لو الخطأ مش DioError اطبع النص عادي
          print("Error: ${error.toString()}");
        }

        emit(LogoutErrorState());
      });
  }

  ///////////////////////////////////////////////////////////////////////////////////


  LoginResponse? loginResponse;

  void Login_user({required user_name, required password}) {
    emit(LoadingState());

    DioHelper.postData(
      url: baseurl + "user_login",
      data: {"password": password, "user_name": user_name},
    ).then((value) {
      loginResponse = LoginResponse.fromJson(value.data);

      emit(Login_UserSuccessState(loginResponse!));


      // print(value.data);
    })
      ..catchError((error) {
        if (error is DioError) {
          // طبع الخطأ الأساسي
          print("Dio error message: ${error.message}");

          // طبع استجابة السيرفر لو موجودة
          if (error.response != null) {
            print("Status code: ${error.response?.statusCode}");
            print("Response data: ${error.response?.data}");
          }
        } else {
          // لو الخطأ مش DioError اطبع النص عادي
          print("Error: ${error.toString()}");
        }

        emit(LoginErrorState());
      });
  }




}

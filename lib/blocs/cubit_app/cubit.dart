
import 'dart:convert';

import 'package:almoktar/blocs/cubit_app/statues.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/category_models.dart';
import '../../network/dio_helper.dart';
import '../../network/end_point.dart';


class AppCubit extends Cubit<AppSates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);


  ///////////////////////Get category
  Map<dynamic,dynamic>? cat_map;
  CategoryModel?  categoryModel;
  void category() {

    emit(LoadingState());
    DioHelper.getData(
      url: baseurl + "admin/get_items?categoryId=1",
    ).then((value) {
      emit(categorySuccessState());
      categoryModel = CategoryModel.fromJson(value.data);

      cat_map?.clear(); // تفريغ القديم إذا في
      for (var item in categoryModel!.data) {
        cat_map?[item.id] = item.name; // أو item إذا بدك تخزن الكائن كامل
      }




    }).catchError((error) {
      print(error.toString());
      emit((categoryErrorState()));
    });
  }

}

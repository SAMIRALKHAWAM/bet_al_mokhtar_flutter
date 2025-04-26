
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
  dynamic selectedCategory ;

  Map<dynamic, dynamic> cat_map = {};
  CategoryModel?  categoryModel;
  void category() {

    emit(LoadingState());
    DioHelper.getData(
      url: baseurl + "admin/get_categories",
    ).then((value) {
      emit(categorySuccessState());
      categoryModel = CategoryModel.fromJson(value.data);
      print(value.toString());

      cat_map?.clear();
      for (var item in categoryModel!.data) {
        cat_map?[item.id] = item.name;
      }
      print(cat_map);


      // حدد أول عنصر تلقائي
      if (cat_map!.isNotEmpty) {
        selectedCategory = cat_map!.entries.first.value;
      }



    }





  ).catchError((error) {
      print(error.toString());
      emit((categoryErrorState()));
    });
  }

}

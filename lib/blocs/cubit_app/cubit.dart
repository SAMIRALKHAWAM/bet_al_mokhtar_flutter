import 'dart:convert';

import 'package:almoktar/blocs/cubit_app/statues.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/category_models.dart';
import '../../models/mealModels.dart';
import '../../models/get_one_itemModel.dart';
import '../../network/dio_helper.dart';
import '../../network/end_point.dart';

class AppCubit extends Cubit<AppSates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  ///////////////////////Get category
  dynamic selectedCategory;

  Map<dynamic, dynamic> cat_map =  {
    // '1': 'Hamburger',
    // '2': 'Pizza',
    // '3': 'Drinks',
  };
  CategoryModel? categoryModel;
  void category() {
    emit(LoadingState());
    DioHelper.getData(url: baseurl + "get_categories")
        .then((value) {
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
          // cat_map = {
          //   '1': 'Hamburger',
          //   '2': 'Pizza',
          //   '3': 'Drinks',
          // };

        })
        .catchError((error) {
          print(error.toString());
          emit((categoryErrorState()));
        });
  }


   MealModel? mealAllModel;
  void MealAll() {
    emit(LoadingState());
    DioHelper.getData(url: baseurl + "get_items")
        .then((value) {
      emit(MealSuccessState());
      mealAllModel = MealModel.fromJson(value.data);

      print(value.data.toString());

        })
        .catchError((error) {
      print(error.toString());
      emit((MealErrorState()));
    });
  }


  MealModel? mealModel;
  void Meal(cat_Id
      ) {
    print(cat_Id);
    emit(LoadingState());
    DioHelper.getData(url: baseurl + "get_items?categoryId=$cat_Id")
        .then((value) {
      emit(MealSuccessState());

      mealAllModel = MealModel.fromJson(value.data);

      print(value.data.toString());

    })
        .catchError((error) {
      print(error.toString());
      emit((MealErrorState()));
    });
  }



  Get_one_itemModel? get_one_item_model;
  void get_one_item(item) {

    emit(LoadingState());
    DioHelper.getData(url: baseurl + "get_one_item/$item")
        .then((value) {
      emit(MealSuccessState());

      get_one_item_model = Get_one_itemModel.fromJson(value.data);

      print(value.data.toString());

    })
        .catchError((error) {
      print(error.toString());
      emit((MealErrorState()));
    });
  }


}

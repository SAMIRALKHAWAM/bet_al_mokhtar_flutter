import 'dart:convert';

import 'package:almoktar/blocs/cubit_app/statues.dart';
import 'package:almoktar/models/FavModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/category_models.dart';
import '../../models/get_offers_model.dart';
import '../../models/mealModels.dart';
import '../../models/get_one_itemModel.dart';
import '../../models/table_model.dart';
import '../../network/dio_helper.dart';
import '../../network/end_point.dart';

class AppCubit extends Cubit<AppSates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);

  ///////////////////////Get category
  dynamic selectedCategory;

  Map<dynamic, dynamic> cat_map = {
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
  void Meal(cat_Id) {
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
  get favoriteItems => null;
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


  // 🟥 1. قائمة تخزين العناصر المفضلة
  final List<Datumm> _favoriteMeals = [];

  // 🟩 2. Getter للوصول إلى العناصر المفضلة من الخارج
  List<Datumm> get favoriteMeals => _favoriteMeals;

  // 🟨 3. دالة إضافة أو إزالة عنصر من المفضلة
  void toggleFavorite(Datumm meal) {
    if (_favoriteMeals.contains(meal)) {
      _favoriteMeals.remove(meal);
    } else {
      _favoriteMeals.add(meal);
    }
    emit(FavoritesUpdatedState(_favoriteMeals));
  }

  // 🟦 4. دالة فحص هل العنصر مفضّل أم لا
  bool isFavorite(Datumm meal) {
    return _favoriteMeals.contains(meal);
  }

  // // ✅ 1. قائمة المفضلة
  // List<Datum> favoriteItems = [];

  // // ✅ 2. دالة للتحقق من وجود عنصر في المفضلة
  // bool isFavorite(int id) {
  //   return favoriteItems.any((element) => element.id == id);
  // }

  // // ✅ 3. دالة لإضافة/إزالة عنصر من المفضلة
  // void toggleFavorite(Datum item) {
  //   final isFav = isFavorite(item.id);
  //   if (isFav) {
  //     favoriteItems.removeWhere((element) => element.id == item.id);
  //   } else {
  //     favoriteItems.add(item);
  //   }

  //   emit(FavoritesUpdatedState(favoriteItems)); // تحديث الواجهة
  // }

  // FavModel? favModel;
  // void addToFavorite(FavModel model) {
  //   emit(LoadingState());

  //   Dio().post(
  //     "https://676bde06bc36a202bb85fc11.mockapi.io/favorite",
  //     data: model.toMap(),
  //   ).then((response) {
  //     favModel = FavModel.fromMap(response.data);
  //     emit(FavoritesSuccess());
  //     print("تمت الإضافة: ${response.data}");
  //   }).catchError((error) {
  //     print("خطأ أثناء الإضافة: $error");
  //     emit(FavoritesError());
  //   });



  void setPreparing() => emit(OrderPreparing());
  void setOnTheWay() => emit(OrderOnTheWay());
  void setDelivered() => emit(OrderDelivered());


  //////////////////////////////////////////// Table

  TableResponse ? Table_model;
  void Table_get() {
    emit(LoadingState());
    DioHelper.getData(url: baseurl + "get_tables?branchId=1&available=1")
        .then((value) {
      emit(tableSuccessState());
      Table_model = TableResponse.fromJson(value.data);

      print(value.data.toString());
    })
        .catchError((error) {
      print(error.toString());
      emit((tableErrorState()));
    });
  }

  /////////////////////////////////////////////  OFFER


  OfferResponse? Offer_response;
  void OfferAll() {
    emit(LoadingState());
    DioHelper.getData(url: baseurl + "get_offers?branchId=1&active=1")
        .then((value) {
      emit(offerSuccessState());
      Offer_response = OfferResponse.fromJson(value.data);

      print(value.data.toString());
    })
        .catchError((error) {
      print(error.toString());
      emit((offerErrorState()));
    });
  }

///////////////////////////////////////////////  add cart
  void create_internal_order({
    required  table_id,
    required  branch_id,
    required  waiter_id,
    required  items,
    required  offers,
  }) {
    emit(LoadingState());

    DioHelper.postData(
      url: baseurl + "create_internal_order",
      data: {
        "table_id": table_id,
        "branch_id": branch_id,
        "waiter_id": waiter_id,
        "items": items,
        "offers": offers,
      },
    ).then((value) {
      emit(addcartSuccessState());
      print(value.data);
    }).catchError((error) {
      print(error);
      emit(addcartErrorState());
    });
  }



}



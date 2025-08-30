import 'dart:convert';

import 'package:almoktar/blocs/cubit_app/statues.dart';
import 'package:almoktar/models/FavModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

import '../../models/add_order_user.dart';
import '../../models/category_models.dart';
import '../../models/dd_order_offer_user.dart';
import '../../models/get_branch.dart';
import '../../models/get_deliveryman.dart';
import '../../models/get_discounts.dart';
import '../../models/get_internal_order_items.dart';
import '../../models/get_internal_orders.dart';
import '../../models/get_offers_model.dart';
import '../../models/get_order_delivery.dart';
import '../../models/invoice_model.dart';
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
          // print(value.toString());

          cat_map?.clear();
          for (var item in categoryModel!.data) {
            cat_map?[item.id] = item.name;
          }
          print(cat_map);

          // حدد أول عنصر تلقائي
          if (cat_map!.isNotEmpty) {
            selectedCategory = cat_map!.entries.first.value;
          }
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

          // print(value.data.toString());
        })
        .catchError((error) {
          print(error.toString());
          emit((MealErrorState()));
        });
  }

  Get_one_itemModel? get_one_item_model;


  void get_one_item(item) {
    get_one_item_model == null;
    emit(LoadingState());
    DioHelper.getData(url: baseurl + "get_one_item/$item")
        .then((value) {
          emit(MealSuccessState());

          get_one_item_model = Get_one_itemModel.fromJson(value.data);

          // print(value.data.toString());
        })
        .catchError((error) {
          print(error.toString());
          emit((MealErrorState()));
        });
  }

  /////////////////////////////////////////////  OFFER

  OfferResponse? Offer_response;

  void OfferAll() {
    emit(LoadingState());
    DioHelper.getData(url: baseurl + "get_offers?active=1")
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


  //////////////////////////////////////////// get_internal_order_items

  InternalOrderResponse? internalorderResponse_D;

  void get_internal_order_items_For_D({required id}) {
    emit(LoadingState());
    DioHelper.getData(url: baseurl + "get_internal_order_items/${id}")
        .then((value) {
      emit(get_internal_order_itemsSuccessState());
      internalorderResponse_D = InternalOrderResponse.fromJson(value.data);

      print(value.data.toString());
    })
        .catchError((error) {
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
      emit((get_internal_order_itemsErrorState()));
    });
  }





  //////////////////////////////////////////// get_internal_order_items

  InternalOrderResponse? internalorderResponse;

  void get_internal_order_items({required id}) {
    emit(LoadingState());
    DioHelper.getData(url: baseurl_Captain + "get_internal_order_items/${id}")
        .then((value) {
          emit(get_internal_order_itemsSuccessState());
          internalorderResponse= InternalOrderResponse.fromJson(value.data);

          // print(value.data.toString());
        })
        .catchError((error) {
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
          emit((get_internal_order_itemsErrorState()));
        });
  }

  //////////////////////////////////////////// get_internal_orders_pending

  OrderResponse? orders_finshing_response;

  Future<bool> get_internal_orders_finshing({int page = 1}) async {
    emit(LoadingState());
    try {
      final response = await DioHelper.getData(
        url:
            "${baseurl_Captain}get_internal_orders?status=finishing&page=$page",
      );

      final result = OrderResponse.fromJson(response.data);

      if (page == 1) {
        orders_finshing_response = result;
      } else {
        orders_finshing_response?.data.addAll(result.data);
      }

      emit(get_order_SuccessState());

      return result.data.length >=
          result.perPage; // ترجع true إذا ممكن توجد صفحة أخرى
    } catch (error) {
      emit(get_order_ErrorState());
      print("Error loading orders: $error");
      return false;
    }
  }

  //////////////////////////////////////////// get_internal_orders_waiting

  OrderResponse? orders_waiting_response;

  Future<bool> get_internal_orders_waiting({int page = 1}) async {
    emit(LoadingState());
    try {
      final response = await DioHelper.getData(
        url: "${baseurl_Captain}get_internal_orders?status=waiting&page=$page",
      );

      final result = OrderResponse.fromJson(response.data);

      if (page == 1) {
        orders_waiting_response = result;
      } else {
        orders_waiting_response?.data.addAll(result.data);
      }

      emit(get_order_SuccessState());

      return result.data.length >= result.perPage;
    } catch (error) {
      emit(get_order_ErrorState());
      print("Error loading orders: $error");
      return false;
    }
  }

  //////////////////////////////////////////// get_internal_orders_preparing

  OrderResponse? orders_preparing_response;

  Future<bool> get_internal_orders_preparing({int page = 1}) async {
    emit(LoadingState());
    try {
      final response = await DioHelper.getData(
        url:
            "${baseurl_Captain}get_internal_orders?status=preparing&page=$page",
      );

      final result = OrderResponse.fromJson(response.data);

      if (page == 1) {
        orders_preparing_response = result;
      } else {
        orders_preparing_response?.data.addAll(result.data);
      }

      emit(get_order_SuccessState());

      return result.data.length >= result.perPage;
    } catch (error) {
      emit(get_order_ErrorState());
      print("Error loading preparing orders: $error");
      return false;
    }
  }

  ///////////////////////////////////////////////  change_internal_order_status
  void change_internal_order_status({
    table_id,
    required status,
    required order_id,
  }) {
    print(table_id);
    print(status);
    print(order_id);

    emit(LoadingState());

    DioHelper.postData(
      url: baseurl_Captain + "change_internal_order_status/${order_id}",
      data: {"table_id": table_id, "status": status},
    ).then((value) {
      emit(orderchangeSuccessState());
      print(value.data);
    })..catchError((error) {
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

      emit(orderchangeErrorState());
    });
  }

  ///////////////////////////////////////////////  change_internal_order_status
  void change_external_order_status({
    required status,
    required order_id,
    required delivery_man_id,
  }) {
    print(status);
    print(order_id);

    emit(LoadingState());

    DioHelper.postData(
      url: baseurl_Captain + "change_external_order_status/${order_id}",
      data: {"status": status, "deliveryman_id": delivery_man_id},
    ).then((value) {
      emit(orderchangeSuccessState());
      print(value.data);
    })..catchError((error) {
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

      emit(orderchangeErrorState());
    });
  }




  ///////////////////////////////////////////////  change_ext_order_status
  void change_ext_order_status({required status, required order_id}) {
    print(status);
    print(order_id);

    emit(LoadingState());

    DioHelper.postData(
      url: baseurl_Captain + "change_external_order_status/${order_id}",
      data: {"status": status},
    ).then((value) {
      emit(orderchangeSuccessState());
      print(value.data);
    })..catchError((error) {
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

      emit(orderchangeErrorState());
    });
  }

  ///////////////////////////////////////////////

  DeliveryManResponse? deliveryman_model;

  Future<void> Delivery_Man() async {
    emit(LoadingState());
    try {
      final value = await DioHelper.getData(
        url: baseurl + "get_employees?branchId=${branch_id}&type=deliveryman",
      );

      deliveryman_model = DeliveryManResponse.fromJson(value.data);
      print("موظفين التوصيل: ${deliveryman_model?.data}");
      emit(BranchSuccessState());
    } catch (error) {
      print("خطأ أثناء جلب موظفين التوصيل: $error");
      emit(BranchErrorState());
    }
  }
  //////////////////////////////////////////////  add_table_reservation

  void add_table_reservation({
    required date,
    required from_time,
    required to_time,
    required branch_id,
    required chairs,
  }) {
    emit(LoadingState());

    DioHelper.postData(
      url: baseurl + "add_table_reservation",
      data: {
        "to_time": to_time,
        "from_time": from_time,
        "date": date,
        "branch_id": branch_id,
        "chairs": chairs,
      },
    ).then((value) {
      emit(reservationSuccessState());
      print(value.data);
    })..catchError((error) {
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

      emit(reservationErrorState());
    });
  }

  /////////////////////////////////////////////  Branch

  BranchesResponse? branch_model;

  void Branch() {
    emit(LoadingState());
    DioHelper.getData(url: baseurl + "get_branches")
        .then((value) {
          emit(BranchSuccessState());
          branch_model = BranchesResponse.fromJson(value.data);

          // print(value.data.toString());
        })
        .catchError((error) {
          print(error.toString());
          emit((BranchErrorState()));
        });
  }

  /////////////////////////////////////////////////////  discounts
  bool isConfirmEnabled = false; // لتفعيل زر التأكيد
  DiscountsResponse? discountsResponse;

  void getDiscounts({required String discountCode}) {
    // تحقق من طول الكود قبل الإرسال
    if (discountCode.length != 6) {
      isConfirmEnabled = false;
      emit(DiscountErrorState("كود الخصم يجب أن يكون 6 أحرف"));
      return;
    }

    emit(DiscountLoadingState());

    DioHelper.getData(url: baseurl + "get_discounts?search=$discountCode")
        .then((value) {
          discountsResponse = DiscountsResponse.fromJson(value.data);

          if (discountsResponse != null &&
              discountsResponse!.success &&
              discountsResponse!.data.isNotEmpty) {
            isConfirmEnabled = true; // فعل زر التاكيد
            emit(DiscountSuccessState(discountsResponse!));
          } else {
            isConfirmEnabled = false;
            emit(DiscountErrorState("كود الخصم غير صالح أو منتهي"));
          }
        })
        .catchError((error) {
          isConfirmEnabled = false;
          emit(DiscountErrorState(error.toString()));
        });
  }

  //////////////////////////////////////////// get_internal_orders_pending

  DeliveryResponse? orders_delivering_response;

  void get_internal_orders_delivering() {
    emit(LoadingState());
    DioHelper.getData(url: baseurl + "get_internal_orders?status=delivering")
        .then((value) {
          emit(get_order_SuccessState());
          orders_delivering_response = DeliveryResponse.fromJson(value.data);

          // print(value.data.toString());
        })
        .catchError((error) {
          print(error.toString());
          emit((get_order_ErrorState()));
        });
  }

  ///////////////////////////////////////////////  create_external_order

  void create_external_order({
    required int branch_id,
    required String location,
    required String phone,
    required String discount_code,
  }) {
    emit(LoadingState());

    // تحويل العناصر إلى مصفوفة من id و quantity فقط
    List<Map<String, dynamic>> items =
        orderItems
            .map((item) => {"item_id": item.id, "quantity": item.quantity})
            .toList();

    // تحويل العروض إلى نفس الصيغة
    List<Map<String, dynamic>> offers =
        orderOffers
            .map((offer) => {"offer_id": offer.id, "quantity": offer.quantity})
            .toList();

    DioHelper.postData(
          url: baseurl + "create_external_order",
          data: {
            "branch_id": branch_id,
            "user_id": 1,
            "items": items,
            "offers": offers,
            "location": location,
            "phone": phone,
            "discount_code": discount_code,
          },
        )
        .then((value) {
          emit(addcartSuccessState());
          print(value.data);
        })
        .catchError((error) {
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

          emit(orderchangeErrorState());
        });
  }

  ///////////////////////////////////////////////  accept_external_order
  void accept_external_order({required code}) {
    emit(LoadingState());

    DioHelper.postData(
          url: baseurl + "accept_external_order/${code}",
          data: {"user_id": id},
        )
        .then((value) {
          emit(accept_external_orderSuccessState());
          print(value.data);
        })
        .catchError((error) {
          print(error);
          emit(accept_external_orderErrorState());
        });
  }

  ////////////////////////////////////////////////////

  List<AddOrderItem> orderItems = [];

  void addItemToOrder({
    required int id,
    required String name,
    required int quantity,
    required num price,
  }) {
    final index = orderItems.indexWhere((item) => item.id == id);

    if (index != -1) {
      // العنصر موجود، نزيد الكمية فقط
      final existingItem = orderItems[index];
      orderItems[index] = AddOrderItem(
        id: existingItem.id,
        name: existingItem.name,
        quantity: existingItem.quantity + quantity,
        price: existingItem.price,
      );
    } else {
      // عنصر جديد
      orderItems.add(
        AddOrderItem(id: id, name: name, quantity: quantity, price: price),
      );
    }

    print(orderItems);
    emit(addcartSuccessState());
  }

  List<AddOrderOffer> orderOffers = [];

  void addOfferToOrder({
    required int id,
    required String name,
    required int quantity,
    required num price,
  }) {
    final index = orderOffers.indexWhere((offer) => offer.id == id);

    if (index != -1) {
      // العرض موجود، نزيد الكمية
      final existingOffer = orderOffers[index];
      orderOffers[index] = AddOrderOffer(
        id: existingOffer.id,
        name: existingOffer.name,
        quantity: existingOffer.quantity + quantity,
        price: existingOffer.price,
      );
    } else {
      // عرض جديد
      orderOffers.add(
        AddOrderOffer(id: id, name: name, quantity: quantity, price: price),
      );
    }

    print(orderOffers);
    emit(addcartSuccessState());
  }

  void increaseItemQuantity(int id, bool isOffer) {
    if (isOffer) {
      final index = orderOffers.indexWhere((offer) => offer.id == id);
      if (index != -1) {
        final offer = orderOffers[index];
        orderOffers[index] = AddOrderOffer(
          id: offer.id,
          name: offer.name,
          quantity: offer.quantity + 1,
          price: offer.price,
        );
        emit(addcartSuccessState());
      }
    } else {
      final index = orderItems.indexWhere((item) => item.id == id);
      if (index != -1) {
        final item = orderItems[index];
        orderItems[index] = AddOrderItem(
          id: item.id,
          name: item.name,
          quantity: item.quantity + 1,
          price: item.price,
        );
        emit(addcartSuccessState());
      }
    }
  }

  void decreaseItemQuantity(int id, bool isOffer) {
    if (isOffer) {
      final index = orderOffers.indexWhere((offer) => offer.id == id);
      if (index != -1) {
        final offer = orderOffers[index];
        if (offer.quantity > 1) {
          orderOffers[index] = AddOrderOffer(
            id: offer.id,
            name: offer.name,
            quantity: offer.quantity - 1,
            price: offer.price,
          );
        } else {
          orderOffers.removeAt(index);
        }
        emit(addcartSuccessState());
      }
    } else {
      final index = orderItems.indexWhere((item) => item.id == id);
      if (index != -1) {
        final item = orderItems[index];
        if (item.quantity > 1) {
          orderItems[index] = AddOrderItem(
            id: item.id,
            name: item.name,
            quantity: item.quantity - 1,
            price: item.price,
          );
        } else {
          orderItems.removeAt(index);
        }
        emit(addcartSuccessState());
      }
    }
  }

  /////////////

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////   WAITER

  /////////////////////////////////////////////  category_emp

  dynamic selectedCategory_emp;

  Map<dynamic, dynamic> cat_map_emp = {};
  CategoryModel? categoryModel_emp;

  void category_emp() {
    emit(LoadingState());
    DioHelper.getData(url: baseurl_Waiter + "get_categories")
        .then((value) {
          emit(categorySuccessState());
          categoryModel_emp = CategoryModel.fromJson(value.data);
          // print(value.toString());

          cat_map_emp?.clear();
          for (var item in categoryModel_emp!.data) {
            cat_map_emp?[item.id] = item.name;
          }
          print(cat_map);

          // حدد أول عنصر تلقائي
          if (cat_map_emp!.isNotEmpty) {
            selectedCategory_emp = cat_map_emp!.entries.first.value;
          }
        })
        .catchError((error) {
          print(error.toString());
          emit((categoryErrorState()));
        });
  }

  /////////////////////////////////////////////  MealAll_emp

  MealModel? mealAllModel_emp;

  void MealAll_emp() {
    emit(LoadingState());
    DioHelper.getData(url: baseurl_Waiter + "get_items")
        .then((value) {
          emit(MealSuccessState());
          mealAllModel_emp = MealModel.fromJson(value.data);

          // print(value.data.toString());
        })
        .catchError((error) {
          print(error.toString());
          emit((MealErrorState()));
        });
  }

  /////////////////////////////////////////////  OFFER

  OfferResponse? Offer_response_emp;

  void OfferAll_emp() {
    emit(LoadingState());
    DioHelper.getData(
          url: baseurl_Waiter + "get_offers?branchId=${branch_id}&active=1",
        )
        .then((value) {
          emit(offerSuccessState());
          Offer_response_emp = OfferResponse.fromJson(value.data);

          // print(value.data.toString());
        })
        .catchError((error) {
          print(error.toString());
          emit((offerErrorState()));
        });
  }

  //////////////////////////////////////////// Table

  TableResponse? Table_model;

  void Table_get() {
    emit(LoadingState());
    DioHelper.getData(url: baseurl_Waiter + "get_tables?branchId=${branch_id}")
        .then((value) {
          emit(tableSuccessState());
          Table_model = TableResponse.fromJson(value.data);

          // print(value.data.toString());
        })
        .catchError((error) {
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

          emit(tableErrorState());
        });
  }

  ///////////////////////////////////////////////  table_change_statu
  void table_change_statu({required table_id}) {
    emit(LoadingState());

    DioHelper.postData(
          url: baseurl_Waiter + "table_change_status/${table_id}",
          data: {"branch_id": branch_id, "waiter_id": emp_id},
        )
        .then((value) {
          emit(tablechangeSuccessState());
          print(value.data);
        })
        .catchError((error) {
          print(error);
          emit(tablechangeErrorState());
        });
  }

  /////////////////////////////////////////////  get_one_invoice

  InvoiceResponse? invoice_response;

  void get_one_invoice({required invoice_id}) {
    emit(LoadingState());

    DioHelper.getData(url: baseurl_Waiter + "get_one_invoice/${invoice_id}")
        .then((value) {
          emit(invoiceSuccessState());
          invoice_response = InvoiceResponse.fromJson(value.data);

          // print(value.data.toString());
        })
        .catchError((error) {
          print(error.toString());
          emit((invoiceErrorState()));
        });
  }

  ///////////////////////////////////////////////  add cart
  void create_internal_order({
    required table_id,
    required items,
    required offers,
  }) {
    emit(LoadingState());

    DioHelper.postData(
          url: baseurl_Waiter + "create_internal_order",
          data: {
            "table_id": table_id,
            "branch_id": branch_id,
            "waiter_id": emp_id,
            "items": items,
            "offers": offers,
          },
        )
        .then((value) {
          emit(addcartSuccessState());
          print(value.data);
        })
        .catchError((error) {
          print(error);
          emit(addcartErrorState());
        });
  }

  ///////////////////////////////////////////////  update_cart
  void update_cart({required items, required offers, required edit_id}) {
    emit(LoadingState());

    DioHelper.postData(
          url: baseurl_Waiter + "update_internal_order/${edit_id}",
          data: {"items": items, "offers": offers},
        )
        .then((value) {
          emit(updatecartSuccessState());
          print(value.data);
        })
        .catchError((error) {
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

          emit(orderchangeErrorState());
        });
  }

  ///////////////////////////////////////////////  change_internal_order_status
  void change_internal_order_status_waiter({
    required table_id,
    required status,
    required order_id,
  }) {
    print(table_id);
    print(status);
    print(order_id);

    emit(LoadingState());

    DioHelper.postData(
      url: baseurl_Waiter + "change_internal_order_status/${order_id}",
      data: {"table_id": table_id, "status": status},
    ).then((value) {
      emit(orderchangeSuccessState());
      print(value.data);
    })..catchError((error) {
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

      emit(orderchangeErrorState());
    });
  }

  /////////////////////////////////////////////  get_internal_orders_finishing

  OrderResponse? orders_finishing_response;

  void get_internal_orders_finishing() {
    emit(LoadingState());
    DioHelper.getData(
          url: baseurl_Waiter + "get_internal_orders?status=finishing",
        )
        .then((value) {
          emit(get_order_SuccessState());
          orders_finishing_response = OrderResponse.fromJson(value.data);

          // print(value.data.toString());
        })
        .catchError((error) {
          print(error.toString());
          emit((get_order_ErrorState()));
        });
  }

  Future<int> change_invoice_status({
    required int table_id,
    required int invoice_id,
  }) async {
    emit(LoadingState());
    try {
      final response = await DioHelper.postData(
        url: baseurl_Waiter + "change_invoice_status/$invoice_id",
        data: {"table_id": table_id, "status": "checkout"},
      );
      emit(tablechangeSuccessState());
      print(response.data);
      return response.statusCode ?? 200; // رجع 200 كافتراضي لو مافي كود
    } on DioError catch (error) {
      if (error.response != null) {
        print("Status code: ${error.response?.statusCode}");
        print("Response data: ${error.response?.data}");
        emit(orderchangeErrorState());
        return error.response!.statusCode ?? 500; // رجع كود الخطأ لو موجود
      } else {
        print("Dio error message: ${error.message}");
        emit(orderchangeErrorState());
        return 500;
      }
    } catch (e) {
      print("Error: ${e.toString()}");
      emit(orderchangeErrorState());
      return 500;
    }
  }
}

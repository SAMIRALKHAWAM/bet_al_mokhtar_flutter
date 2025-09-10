import 'package:almoktar/models/mealModels.dart';
import 'package:latlong2/latlong.dart';

import '../../models/get_discounts.dart';

abstract class AppSates {}

class AppInitialState extends AppSates {}

class LoadingState extends AppSates {}

class categorySuccessState extends AppSates {}
class categoryErrorState extends AppSates {}

class MealSuccessState extends AppSates {}
class MealErrorState extends AppSates {}

class MealInfoSuccessState extends AppSates {}
class MealInfoErrorState extends AppSates {}

class offerSuccessState extends AppSates {}
class offerErrorState extends AppSates {}

class BranchSuccessState extends AppSates {}
class BranchErrorState extends AppSates {}
class DiscountLoadingState extends AppSates {}

class DiscountSuccessState extends AppSates {

  late final DiscountsResponse discountsResponse;
  DiscountSuccessState(this.discountsResponse);

}
class DiscountErrorState extends AppSates {

  final String error;
  DiscountErrorState(this.error);

}

class reservationSuccessState extends AppSates {}
class reservationErrorState extends AppSates {}

class addcartSuccessState extends AppSates {}
class addcartErrorState extends AppSates {}

class updatecartSuccessState extends AppSates {}
class updatecartErrorState extends AppSates {}

class tableSuccessState extends AppSates {}
class tableErrorState extends AppSates {}

class orderchangeSuccessState extends AppSates {}
class orderchangeErrorState extends AppSates {}

class get_internal_order_itemsSuccessState extends AppSates {}
class get_internal_order_itemsErrorState extends AppSates {}

class get_invoiceSuccessState extends AppSates {}
class get_invoiceErrorState extends AppSates {}

class get_order_SuccessState extends AppSates {}
class get_order_ErrorState extends AppSates {}

class tablechangeSuccessState extends AppSates {}
class tablechangeErrorState extends AppSates {}

class invoiceSuccessState extends AppSates {}
class invoiceErrorState extends AppSates {}


class FavoritesSuccess extends AppSates {}
class FavoritesError extends AppSates {}

class accept_external_orderSuccessState extends AppSates {}
class accept_external_orderErrorState extends AppSates {}

class rate_SuccessState extends AppSates {}
class rate_ErrorState extends AppSates {}

class like_SuccessState extends AppSates {}
class like_ErrorState extends AppSates {}

// حالة جديدة عند تحديث قائمة المفضلات
class FavoritesUpdatedState extends AppSates {
  final List<Datumm> favorites;
  FavoritesUpdatedState(this.favorites);
}

class OrderPreparing extends AppSates {}

class OrderOnTheWay extends AppSates {}

class OrderDelivered extends AppSates {}

class OrderLoading extends AppSates {}








// /////تتبع طلب

// class OrderLocationUpdatedState extends AppSates {
//   final LatLng location;

//   OrderLocationUpdatedState(this.location);
// }



// class OrderLoaded extends AppSates {
//   final List<OrderModel> orders;
//   OrderLoaded(this.orders);
// }

// class OrderError extends AppSates {
//   final String message;
//   OrderError(this.message);
// }

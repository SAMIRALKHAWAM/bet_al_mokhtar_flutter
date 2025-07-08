import 'package:almoktar/models/mealModels.dart';

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

class addcartSuccessState extends AppSates {}
class addcartErrorState extends AppSates {}

class tableSuccessState extends AppSates {}
class tableErrorState extends AppSates {}

class tablechangeSuccessState extends AppSates {}
class tablechangeErrorState extends AppSates {}

class invoiceSuccessState extends AppSates {}
class invoiceErrorState extends AppSates {}


class FavoritesSuccess extends AppSates {}
class FavoritesError extends AppSates {}

// حالة جديدة عند تحديث قائمة المفضلات
class FavoritesUpdatedState extends AppSates {
  final List<Datumm> favorites;
  FavoritesUpdatedState(this.favorites);
}

class OrderPreparing extends AppSates {}

class OrderOnTheWay extends AppSates {}

class OrderDelivered extends AppSates {}

class OrderLoading extends AppSates {}

// class OrderLoaded extends AppSates {
//   final List<OrderModel> orders;
//   OrderLoaded(this.orders);
// }

// class OrderError extends AppSates {
//   final String message;
//   OrderError(this.message);
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/cubit_app/cubit.dart';
import '../../components/colors.dart';
import '../../models/get_offers_model.dart';
import '../../models/mealModels.dart';

class WaiterOrderInterface extends StatefulWidget {
  final dynamic table_id;

  WaiterOrderInterface(this.table_id, {Key? key}) : super(key: key);

  @override
  _WaiterOrderInterfaceState createState() => _WaiterOrderInterfaceState();
}

class _WaiterOrderInterfaceState extends State<WaiterOrderInterface> with SingleTickerProviderStateMixin {
  Map<String, Map<String, dynamic>> cart = {};
  Map<int, Map<String, dynamic>> selectedOffers = {};
  Map<int, List<Datumm>> mealsByCategory = {};

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final cubit = AppCubit.get(context);
    cubit.category();
    cubit.MealAll();
    cubit.OfferAll();

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void groupMealsByCategory(List<Datumm> meals) {
    mealsByCategory.clear();
    for (var meal in meals) {
      mealsByCategory.putIfAbsent(meal.categoryId, () => []);
      mealsByCategory[meal.categoryId]!.add(meal);
    }
  }

  void addToCart(int mealId, String mealName, num price) {
    setState(() {
      cart.update(mealName, (existing) {
        existing['quantity'] += 1;
        return existing;
      }, ifAbsent: () => {'quantity': 1, 'price': price, 'id': mealId});
    });
  }

  void removeFromCart(String mealName) {
    setState(() {
      cart.remove(mealName);
    });
  }

  void updateQuantity(String mealName, int quantity) {
    if (quantity <= 0) {
      removeFromCart(mealName);
    } else {
      setState(() {
        cart[mealName]!['quantity'] = quantity;
      });
    }
  }

  void addOfferToCart(Offer offer) {
    setState(() {
      if (selectedOffers.containsKey(offer.id)) {
        selectedOffers[offer.id]!['quantity'] += 1;
      } else {
        selectedOffers[offer.id] = {'offer': offer, 'quantity': 1};
      }
    });
  }

  void removeOfferFromCart(int offerId) {
    setState(() {
      selectedOffers.remove(offerId);
    });
  }

  void updateOfferQuantity(int offerId, int quantity) {
    if (quantity <= 0) {
      removeOfferFromCart(offerId);
    } else {
      setState(() {
        selectedOffers[offerId]!['quantity'] = quantity;
      });
    }
  }

  num getTotalPrice() {
    num total = 0;
    cart.forEach((_, value) {
      total += value['price'] * value['quantity'];
    });
    selectedOffers.forEach((_, value) {
      final offer = value['offer'] as Offer;
      final qty = value['quantity'] as int;
      total += offer.price * qty;
    });
    return total;
  }

  void confirmOrder() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('تم تأكيد الطلب'),
        content: Text('تم إرسال الطلب إلى المطبخ بنجاح.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                cart.clear();
                selectedOffers.clear();
              });
            },
            child: Text('حسناً'),
          ),
        ],
      ),
    );
  }

  void showOfferDetails(Offer offer) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(offer.name),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(offer.description),
              SizedBox(height: 10),
              Text(
                "المحتويات:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...offer.offerItems.map(
                    (offerItem) => Text(
                  "- ${offerItem.item.name} × ${offerItem.quantity}",
                ),
              ),
              SizedBox(height: 10),
              Text(
                "السعر: ${offer.price} ل.س",
                style: TextStyle(color: ColorApp.accent),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("إغلاق"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorApp.accent,
            ),
            onPressed: () {
              addOfferToCart(offer);
              Navigator.of(context).pop();
            },
            child: Text("إضافة للسلة"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, dynamic>(
      builder: (context, state) {
        final cubit = AppCubit.get(context);

        if (cubit.cat_map == null ||
            cubit.mealAllModel == null ||
            cubit.Offer_response == null) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final categories = Map<int, String>.from(cubit.cat_map!);
        final allMeals = cubit.mealAllModel!.data;
        final offers = cubit.Offer_response!.data;
        groupMealsByCategory(allMeals);

        return Scaffold(
          backgroundColor: ColorApp.colorback,
          appBar: AppBar(
            backgroundColor: ColorApp.accent,
            title: Text("واجهة الطلب", style: TextStyle(color: Colors.white)),
            centerTitle: true,
            elevation: 0,
            bottom: MediaQuery.of(context).size.width < 600
                ? TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: "القائمة"),
                Tab(text: "السلة 🛒"),
              ],
            )
                : null,
          ),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWideScreen = constraints.maxWidth >= 600;

                if (isWideScreen) {
                  // شاشة كبيرة: عرض أفقي
                  return Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: buildMenuSection(categories, offers),
                        ),
                      ),
                      VerticalDivider(thickness: 1, color: Colors.grey[400]),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: buildCartSection(),
                        ),
                      ),
                    ],
                  );
                } else {
                  // شاشة صغيرة: نستخدم تبويبات مع TabBarView
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: buildMenuSection(categories, offers),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: buildCartSection(),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget buildMenuSection(Map<int, String> categories, List<Offer> offers) {
    return ListView(
      children: [
        ...categories.entries.map((entry) {
          final meals = mealsByCategory[entry.key] ?? [];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ExpansionTile(
              title: Text(
                entry.value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorApp.accent,
                ),
              ),
              children: meals.map((meal) {
                return ListTile(
                  leading: Icon(Icons.fastfood, color: ColorApp.accent),
                  title: Text(meal.name),
                  subtitle: Text("${meal.price} ل.س"),
                  trailing: IconButton(
                    icon: Icon(Icons.add_circle, color: ColorApp.accent),
                    onPressed: () => addToCart(meal.id, meal.name, meal.price),
                  ),
                );
              }).toList(),
            ),
          );
        }),
        Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          color: ColorApp.color4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ExpansionTile(
            initiallyExpanded: true,
            title: Text(
              "🎁 عروض المطعم",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorApp.accent,
              ),
            ),
            children: offers.map((offer) {
              return ListTile(
                title: Text(offer.name),
                subtitle: Text("السعر: ${offer.price} ل.س"),
                trailing: Icon(Icons.local_offer, color: ColorApp.accent),
                onTap: () => showOfferDetails(offer),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget buildCartSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            '🛒 سلة الطلب',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: cart.isEmpty && selectedOffers.isEmpty
              ? Center(
            child: Text(
              'السلة فارغة',
              style: TextStyle(fontSize: 18),
            ),
          )
              : ListView(
            children: [
              ...cart.entries.map((entry) {
                final name = entry.key;
                final quantity = entry.value['quantity'] as int;
                final price = entry.value['price'];
                return ListTile(
                  title: Text(name),
                  subtitle: Text("السعر: ${price * quantity} ل.س"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline),
                        onPressed: () => updateQuantity(name, quantity - 1),
                      ),
                      Text(quantity.toString()),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline),
                        onPressed: () => updateQuantity(name, quantity + 1),
                      ),
                    ],
                  ),
                );
              }),
              ...selectedOffers.entries.map((entry) {
                final offer = entry.value['offer'] as Offer;
                final quantity = entry.value['quantity'] as int;
                return ListTile(
                  title: Text(offer.name),
                  subtitle: Text("السعر: ${offer.price * quantity} ل.س"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline),
                        onPressed: () =>
                            updateOfferQuantity(offer.id, quantity - 1),
                      ),
                      Text(quantity.toString()),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline),
                        onPressed: () =>
                            updateOfferQuantity(offer.id, quantity + 1),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "الإجمالي: ${getTotalPrice()} ل.س",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorApp.accent,
          ),
          onPressed: (cart.isEmpty && selectedOffers.isEmpty)
              ? null
              : () {
            final items = cart.entries.map((entry) {
              return {
                "item_id": entry.value['id'],
                "quantity": entry.value['quantity'],
              };
            }).toList();

            final offers = selectedOffers.entries.map((entry) {
              return {"offer_id": entry.key, "quantity": entry.value['quantity']};
            }).toList();

            print(offers);
            print(items);

            AppCubit.get(context).create_internal_order(
              table_id: 1,
              branch_id: 1,
              waiter_id: 1,
              items: items,
              offers: offers,
            );

            confirmOrder();
          },          child: Text("تأكيد الطلب"),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/cubit_app/cubit.dart';
import '../../blocs/cubit_app/statues.dart';
import '../../components/colors.dart';
import '../../models/get_offers_model.dart';
import '../../models/mealModels.dart';



// --- إضافة ExpansionTile مخصصة مع أيقونة القلم تظهر فقط عند التوسيع ---
class EditableExpansionTile extends StatefulWidget {
  final String title;
  final dynamic table_id;
  final List<Widget> children;
  final dynamic invoice;
  final dynamic oldOrder;
  final void Function(dynamic oldOrder)? onAddOldOrderToCart;

  const EditableExpansionTile({
    required this.title,
    required this.children,
    required this.invoice,
    this.oldOrder,
    this.table_id,
    this.onAddOldOrderToCart,
    Key? key,
  }) : super(key: key);

  @override
  _EditableExpansionTileState createState() => _EditableExpansionTileState();
}

class _EditableExpansionTileState extends State<EditableExpansionTile> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    // AppCubit.get(context).get_one_invoice(invoice_id: widget.invoice);
  }

  @override
  Widget build(BuildContext context) {
    final isPending = (widget.oldOrder != null && widget.oldOrder.status == 'pending')
        ||(widget.oldOrder != null && widget.oldOrder.status == 'waiting');

    return Card(
      margin: EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      child: ExpansionTile(
        title: Row(
          children: [
            Expanded(child: Text("  طلب رقم ${widget.title}")),
            if (_isExpanded && isPending)
              IconButton(
                icon: Icon(Icons.edit, color: ColorApp.accent),
                tooltip: 'تعديل الطلب',
                onPressed: () {
                  if (widget.onAddOldOrderToCart != null && widget.oldOrder != null) {
                 AppCubit.get(context).change_internal_order_status(table_id: widget.table_id,
                     status: "pending", order_id: widget.title);
                 print(widget.table_id);

                    widget.onAddOldOrderToCart!(widget.oldOrder);
                  }
                },
              ),
          ],
        ),
        children: widget.children,
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
      ),
    );
  }
}

// --- نهاية إضافة الـ ExpansionTile المخصصة ---

class WaiterOrderInterface extends StatefulWidget {
  final dynamic table_id;
  final dynamic table_num;
  final dynamic invoice_id;
  dynamic edit;

  WaiterOrderInterface(this.table_id,this.table_num,this.invoice_id, {Key? key}) : super(key: key);

  @override
  _WaiterOrderInterfaceState createState() => _WaiterOrderInterfaceState();
}

class _WaiterOrderInterfaceState extends State<WaiterOrderInterface> with SingleTickerProviderStateMixin {
  Map<String, Map<String, dynamic>> mealsCart = {}; // سلة الوجبات
  Map<String, Map<String, dynamic>> offersCart = {}; // سلة العروض
  Map<int, List<Datumm>> mealsByCategory = {};

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final cubit = AppCubit.get(context);
    cubit.category();
    cubit.MealAll();
    cubit.OfferAll();
    // cubit.get_one_invoice(invoice_id: widget.invoice_id);

    _tabController = TabController(length: 2, vsync: this);
  }

  void groupMealsByCategory(List<Datumm> meals) {
    mealsByCategory.clear();
    for (var meal in meals) {
      mealsByCategory.putIfAbsent(meal.categoryId, () => []);
      mealsByCategory[meal.categoryId]!.add(meal);
    }
  }

  // key فريد لكل عنصر في السلة: id + نوع
  String _generateCartKey(int id, String type) => "$type-$id";

  void addToCart(int id, String name, num price, String type) {
    final key = _generateCartKey(id, type);
    setState(() {
      if (type == "meal") {
        if (mealsCart.containsKey(key)) {
          mealsCart[key]!['quantity'] += 1;
        } else {
          mealsCart[key] = {
            'id': id,
            'name': name,
            'price': price,
            'quantity': 1,
            'type': type,
          };
        }
      } else if (type == "offer") {
        if (offersCart.containsKey(key)) {
          offersCart[key]!['quantity'] += 1;
        } else {
          offersCart[key] = {
            'id': id,
            'name': name,
            'price': price,
            'quantity': 1,
            'type': type,
          };
        }
      }
    });
  }

  void removeFromCart(String key, String type) {
    setState(() {
      if (type == "meal") {
        mealsCart.remove(key);
      } else if (type == "offer") {
        offersCart.remove(key);
      }
    });
  }

  void updateQuantity(String key, int quantity, String type) {
    if (quantity <= 0) {
      removeFromCart(key, type);
    } else {
      setState(() {
        if (type == "meal") {
          mealsCart[key]!['quantity'] = quantity;
        } else if (type == "offer") {
          offersCart[key]!['quantity'] = quantity;
        }
      });
    }
  }

  num getTotalPrice() {
    num total = 0;
    mealsCart.forEach((_, value) {
      total += value['price'] * value['quantity'];
    });
    offersCart.forEach((_, value) {
      total += value['price'] * value['quantity'];
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
                widget.edit=null;
                mealsCart.clear();
                offersCart.clear();
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
                    (offerItem) => Text("- ${offerItem.item.name} × ${offerItem.quantity}"),
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
              addToCart(offer.id, offer.name, offer.price, "offer");
              Navigator.of(context).pop();
            },
            child: Text("إضافة للسلة"),
          ),
        ],
      ),
    );
  }

  void addOldOrderToCart(dynamic oldOrder) {
    setState(() {

      widget.edit = oldOrder.id;
      mealsCart.clear();
      offersCart.clear();

      for (var line in oldOrder.internalOrderLines) {
        final mealName = line.itemName;
        final price = line.itemPrice;
        final quantity = line.quantity;
        final id = line.itemId;
        final key = _generateCartKey(id, "meal");

        mealsCart[key] = {
          'id': id,
          'name': mealName,
          'price': price,
          'quantity': quantity,
          'type': "meal",
        };
      }

      for (var offer in oldOrder.internalOrderOffers) {
        final key = _generateCartKey(offer.offerId, "offer");
        offersCart[key] = {
          'id': offer.offerId,
          'name': offer.offer.name,
          'price': offer.offer.price,
          'quantity': offer.quantity,
          'type': "offer",
        };
      }
    });
    Navigator.of(context).pop();
  }

  Widget buildOldOrdersBottomSheet() {
    return BlocBuilder<AppCubit, AppSates>(
      builder: (context, state) {
        final invoice = AppCubit.get(context).invoice_response?.data;

        if (invoice == null) {
          return Center(child: CircularProgressIndicator());
        }

        if (invoice.internalOrders.isEmpty) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Text("لا يوجد طلبات سابقة للطاولة."),
            ),
          );
        }

        return Container(
          padding: EdgeInsets.all(16),
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "الطلبات السابقة",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: ColorApp.accent,
                ),
              ),
              Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: invoice.internalOrders.length,
                  itemBuilder: (context, index) {
                    final order = invoice.internalOrders[index];
                    return EditableExpansionTile(
                      table_id: widget.table_id,
                      title:  "${order.id}",
                      invoice: invoice,
                      oldOrder: order,
                      onAddOldOrderToCart: addOldOrderToCart,
                      children: [
                        ...order.internalOrderLines.map((line) => ListTile(
                          title: Text(line.itemName),
                          trailing: Text("× ${line.quantity}"),
                          subtitle: Text("${line.price} ل.س"),
                        )),
                        if (order.internalOrderOffers.isNotEmpty)
                          ...order.internalOrderOffers.map((offer) => ListTile(
                            title: Text(offer.offer.name),
                            trailing: Text("× ${offer.quantity}"),
                            subtitle: Text("${offer.price} ل.س"),
                          )),
                      ],
                    );
                  },
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("إغلاق"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorApp.accent,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppSates>(
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
            title: Text("الطاولة رقم ${widget.table_num}", style: TextStyle(color: Colors.white)),
            centerTitle: true,
            elevation: 0,
            actions: [
              if (widget.invoice_id != null)
                IconButton(
                  icon: Icon(Icons.history, color: Colors.white),
                  tooltip: 'الطلبات السابقة',
                  onPressed: () {
                    cubit.get_one_invoice(invoice_id: widget.invoice_id);

                    showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (_) => buildOldOrdersBottomSheet(),
                    );
                  },
                ),
            ],
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
                    onPressed: () => addToCart(meal.id, meal.name, meal.price, "meal"),
                  ),
                );
              }).toList(),
            ),
          );
        }),
        Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          color: Colors.orange[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ExpansionTile(
            title: Text(
              "العروض",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorApp.accent,
              ),
            ),
            children: offers.map((offer) {
              return ListTile(
                leading: Icon(Icons.local_offer, color: ColorApp.accent),
                title: Text(offer.name),
                subtitle: Text("${offer.price} ل.س"),
                trailing: IconButton(
                  icon: Icon(Icons.info_outline, color: ColorApp.accent),
                  onPressed: () => showOfferDetails(offer),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget buildCartSection() {
    if (mealsCart.isEmpty && offersCart.isEmpty) {
      return Center(
        child: Text(
          "السلة فارغة",
          style: TextStyle(fontSize: 20, color: Colors.grey[600]),
        ),
      );
    }

    final allItems = [
      ...mealsCart.entries.map((e) => e),
      ...offersCart.entries.map((e) => e),
    ];

    return Column(
      children: [
        Expanded(
          child: ListView(
            children: allItems.map((entry) {
              final key = entry.key;
              final item = entry.value;

              return ListTile(
                title: Text(item['name']),
                subtitle: Text("${item['price']} ل.س"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                      onPressed: () {
                        int newQty = item['quantity'] - 1;
                        updateQuantity(key, newQty, item['type']);
                      },
                    ),
                    Text("${item['quantity']}"),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline, color: Colors.green),
                      onPressed: () {
                        int newQty = item['quantity'] + 1;
                        updateQuantity(key, newQty, item['type']);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: Colors.grey),
                      onPressed: () => removeFromCart(key, item['type']),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "المجموع:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "${getTotalPrice()} ل.س",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ColorApp.accent),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: ElevatedButton(
            onPressed: (mealsCart.isEmpty && offersCart.isEmpty)
                ? null
                : () {
              final items = mealsCart.entries.map((entry) {
                return {
                  "item_id": entry.value['id'],
                  "quantity": entry.value['quantity'],
                };
              }).toList();

              final offers = offersCart.entries.map((entry) {
                return {"offer_id": entry.value['id'], "quantity": entry.value['quantity']};
              }).toList();

              print(offers);
              print(items);
              if(widget.edit!=null){
                AppCubit.get(context).update_cart(
                   edit_id: widget.edit,
                  items: items,
                  offers: offers,
                );              }

              AppCubit.get(context).create_internal_order(
                table_id: widget.table_id,
                items: items,
                offers: offers,
              );

              confirmOrder();
            },              child: Text("تأكيد الطلب"),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorApp.accent,
              minimumSize: Size(double.infinity, 50),
            ),
          ),
        ),
      ],
    );
  }
}

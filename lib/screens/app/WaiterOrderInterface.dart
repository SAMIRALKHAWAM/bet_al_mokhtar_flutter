import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/cubit_app/cubit.dart';

class WaiterOrderInterface extends StatefulWidget {
  @override
  _WaiterOrderInterfaceState createState() => _WaiterOrderInterfaceState();
}

class _WaiterOrderInterfaceState extends State<WaiterOrderInterface> {
  int? selectedCategoryId;
  Map<String, Map<String, dynamic>> cart = {};

  @override
  void initState() {
    super.initState();
    final cubit = AppCubit.get(context);
    cubit.category();
    cubit.MealAll();
  }

  void addToCart(String mealName, num price) {
    setState(() {
      if (cart.containsKey(mealName)) {
        cart[mealName]!['quantity'] += 1;
      } else {
        cart[mealName] = {'quantity': 1, 'price': price};
      }
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

  num getTotalPrice() {
    num total = 0;
    cart.forEach((_, value) {
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
                cart.clear();
              });
            },
            child: Text('حسناً'),
          ),
        ],
      ),
    );
  }

  void onCategorySelected(int id) {
    setState(() {
      selectedCategoryId = id;
      cart.clear();
    });
    AppCubit.get(context).Meal(id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, dynamic>(
      builder: (context, state) {
        final cubit = AppCubit.get(context);

        if (cubit.cat_map == null || cubit.mealAllModel == null) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final categories = Map<int, String>.from(cubit.cat_map!);

        if (selectedCategoryId == null && categories.isNotEmpty) {
          final first = categories.entries.first;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onCategorySelected(first.key);
          });
        }

        final meals = cubit.mealAllModel!.data ?? [];

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: MediaQuery.of(context).size.width > 400
                  ? Row(
                children: [
                  Expanded(child: buildMenuSection(categories, meals)),
                  VerticalDivider(),
                  Expanded(child: buildCartSection()),
                ],
              )
                  : Column(
                children: [
                  Expanded(child: buildMenuSection(categories, meals)),
                  Divider(),
                  Expanded(child: buildCartSection()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildMenuSection(Map<int, String> categories, List meals) {
    return ListView(
      children: categories.entries.map((entry) {
        final catId = entry.key;
        final catName = entry.value;
        final isSelected = selectedCategoryId == catId;
        final mealsInCategory = isSelected ? meals : [];

        return ExpansionTile(
          initiallyExpanded: isSelected,
          title: Text(
            catName,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          children: mealsInCategory.map<Widget>((meal) {
            final name = meal.name ?? '';
            final price = meal.price ?? 0;
            return ListTile(
              leading: Icon(Icons.fastfood),
              title: Text(name),
              subtitle: Text('$price ل.س'),
              trailing: IconButton(
                icon: Icon(Icons.add_circle, color: Colors.teal),
                onPressed: () => addToCart(name, price),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  Widget buildCartSection() {
    return Column(
      children: [
        Text('سلة الطلب', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Expanded(
          child: cart.isEmpty
              ? Center(child: Text('السلة فارغة'))
              : ListView(
            children: cart.entries.map((e) {
              final name = e.key;
              final qty = e.value['quantity'];
              final price = e.value['price'];
              return Card(
                child: ListTile(
                  title: Text(name),
                  subtitle: Text('الكمية: $qty - الإجمالي: ${price * qty} ل.س'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline),
                        onPressed: () => updateQuantity(name, qty - 1),
                      ),
                      Text('$qty'),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline),
                        onPressed: () => updateQuantity(name, qty + 1),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline),
                        onPressed: () => removeFromCart(name),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Divider(),
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'المجموع: ${getTotalPrice().toInt()} ريال',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: ElevatedButton.icon(
            icon: Icon(Icons.check),
            label: Text('تأكيد الطلب'),
            onPressed: cart.isEmpty ? null : confirmOrder,
            style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 40)),
          ),
        ),
      ],
    );
  }
}

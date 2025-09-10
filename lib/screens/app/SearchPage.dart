import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/cubit_app/cubit.dart';
import '../../blocs/cubit_app/statues.dart';
import 'FoodDetailsPage.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  List meals = [];

  @override
  void initState() {
    super.initState();
    final cubit = AppCubit.get(context);
    meals = cubit.mealAllModel?.data ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final filteredMeals = meals.where((meal) {
      final text = searchController.text.toLowerCase();
      return meal.name.toLowerCase().contains(text);
    }).toList();

    return Directionality( // ✅ دعم العربية
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: searchController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: "بحث عن وجبة...",
              border: InputBorder.none,
            ),
            onChanged: (_) {
              setState(() {});
            },
          ),
        ),
        body: filteredMeals.isEmpty
            ? const Center(child: Text("لا توجد نتائج"))
            : ListView.builder(
          itemCount: filteredMeals.length,
          itemBuilder: (context, index) {
            final meal = filteredMeals[index];
            final image = meal.itemImages.isNotEmpty
                ? meal.itemImages.first.image
                : null;

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 8.0),
              leading: image != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  image,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              )
                  : const Icon(Icons.fastfood),
              title: Text(
                meal.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
              subtitle: Text(
                '${meal.price.toStringAsFixed(2)} ل.س',
                style: const TextStyle(fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FoodHamburgerPage(itemId: meal.id),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

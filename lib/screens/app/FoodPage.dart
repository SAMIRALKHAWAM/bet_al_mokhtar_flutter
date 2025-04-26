

import 'package:almoktar/config/theme_manager.dart';
import 'package:almoktar/cubits/theme/theme_cubit.dart';
import 'package:almoktar/screens/app/FoodHamburgerPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/cubit_app/cubit.dart';
import '../../blocs/cubit_app/statues.dart';
import '../../components/defaultButton.dart';
import '../../components/text.dart';

// نموذج بيانات الطعام مع تصنيف
class FoodItem {
  final String name;
  final String image;
  final double price;
  final String category;

  FoodItem({
    required this.name,
    required this.image,
    required this.price,
    required this.category,
  });
}

// صفحة عرض قائمة الأطعمة ببحث، فلتر Chips وشبكة
class FoodPage extends StatefulWidget {
  const FoodPage({Key? key}) : super(key: key);

  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  // ثلاث تصنيفات فقط بحسب التصميم
  // final List<String> categories = ['All', 'Hamburger', 'Pizza'];
  dynamic  selectedCategory = 'category 1';

  final List<FoodItem> allFoods = [
    FoodItem(
      name: 'Classic Beef Burger',
      image: 'assets/images/Reset password.png',
      price: 5.99,
      category: 'Hamburger',
    ),
    FoodItem(
      name: 'Cheese Burger',
      image: 'assets/images/Reset password.png',
      price: 6.99,
      category: 'Hamburger',
    ),
    FoodItem(
      name: 'Pepperoni Pizza',
      image: 'assets/images/Reset password.png',
      price: 8.99,
      category: 'Pizza',
    ),
    FoodItem(
      name: 'Margherita Pizza',
      image: 'assets/images/Reset password.png',
      price: 7.99,
      category: 'Pizza',
    ),
  ];
  List<FoodItem> filteredFoods = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredFoods = List.from(allFoods);
    searchController.addListener(_applyFilters);

    AppCubit.get(context).category();
    Future.delayed(Duration(milliseconds: 500), () {
      final map = AppCubit.get(context).cat_map;
      if (map!.isNotEmpty && selectedCategory == null) {
        setState(() {
          selectedCategory = map.entries.first.value;
          _applyFilters();
        });
      }
    });




  }

  void _applyFilters() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredFoods =
          allFoods.where((item) {
              final matchesCategory =
                  selectedCategory == 'All' ||
                  item.category == selectedCategory;
              final matchesSearch = item.name.toLowerCase().contains(query);
              return matchesCategory && matchesSearch;
            }).toList()
            ..sort((a, b) {
              final aStarts = a.name.toLowerCase().startsWith(query);
              final bStarts = b.name.toLowerCase().startsWith(query);
              if (aStarts && !bStarts) return -1;
              if (!aStarts && bStarts) return 1;
              return a.name.compareTo(b.name);
            });
    });
  }

  @override
  void dispose() {
    searchController.removeListener(_applyFilters);
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppSates>(
      listener: (BuildContext context, state) {  },
      builder: (BuildContext context, state) {
        final theme = Theme.of(context);

        return
       AppCubit.get(context).categoryModel!=null ?
         Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // عنوان الشاشة
                  CustomText(
                    text1: 'Food Menu',
                    size: 28,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.titleLarge?.color,
                  ),
                  const SizedBox(height: 8),
                  // حقل البحث
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search food...',
                      prefixIcon: Icon(
                        Icons.search,
                        color: theme.iconTheme.color,
                      ),
                      filled: true,
                      fillColor: theme.cardColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Chips للتصنيف

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                        children: AppCubit.get(context).cat_map!.entries
                            .where((entry) => entry.value != null)
                            .map<Widget>((entry) {
                          final catName = entry.value;
                          final isSelected = catName == selectedCategory;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(catName),
                              selected: isSelected,
                              onSelected: (_) {
                                setState(() {
                                  selectedCategory = catName;
                                  // _applyFilters();
                                });
                              },
                              selectedColor: theme.colorScheme.primary,
                              backgroundColor: theme.cardColor,
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? theme.colorScheme.onPrimary
                                    : theme.textTheme.bodyMedium?.color,
                              ),
                            ),
                          );
                        }).toList(),

                    ),
                  ),



                  const SizedBox(height: 16),
                  // شبكة العناصر
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: filteredFoods.length,
                      itemBuilder: (context, index) {
                        final item = filteredFoods[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FoodHamburgerPage(item: item),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 8),
                                Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Center(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.asset(
                                          item.image,
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.favorite_border,
                                        color: theme.iconTheme.color,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text1: item.name,
                                        size: 16,
                                        fontWeight: FontWeight.bold,
                                        color:
                                        theme.textTheme.titleLarge?.color,
                                        // maxLines: 2,
                                      ),
                                      const SizedBox(height: 4),
                                      CustomText(
                                        text1:
                                        '\$${item.price.toStringAsFixed(2)}',
                                        size: 14,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
             :
           Center(
             child: CircularProgressIndicator(),
           )  ;

      },

    );
  }
}

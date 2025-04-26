// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../cubits/theme/theme_cubit.dart';
// import '../../components/text.dart';
// import '../../components/textButton.dart';

// class FoodPage extends StatelessWidget {
//   final List<String> categories = ["All", "hamburger", "pizza", "grills"];
//   final int selectedCategoryIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ThemeCubit, ThemeState>(
//       builder: (context, state) {
//         final theme = Theme.of(context);

//         return Scaffold(
//           backgroundColor: theme.scaffoldBackgroundColor,
//           body: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 20),
//                   CustomText(
//                     text1: "Food",
//                     size: 30,
//                     fontWeight: FontWeight.bold,
//                     color: theme.colorScheme.onBackground,
//                   ),
//                   CustomText(
//                     text1: "order your favourite food",
//                     size: 14,
//                     color: theme.colorScheme.onBackground.withOpacity(0.6),
//                   ),
//                   const SizedBox(height: 20),

//                   // Search bar
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                     decoration: BoxDecoration(
//                       color: theme.cardColor,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 8,
//                           offset: Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(Icons.search, color: theme.colorScheme.primary),
//                         SizedBox(width: 10),
//                         Expanded(
//                           child: Text(
//                             "search",
//                             style: TextStyle(
//                               color: theme.colorScheme.onBackground.withOpacity(
//                                 0.5,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 20),

//                   // Categories
//                   SizedBox(
//                     height: 40,
//                     child: ListView.separated(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: categories.length,
//                       separatorBuilder: (context, index) => SizedBox(width: 10),
//                       itemBuilder: (context, index) {
//                         final isSelected = index == selectedCategoryIndex;
//                         return TextButtonCustom(
//                           text: categories[index],
//                           onTap: () {
//                             // logic للتصفية إن أردت
//                           },
//                           color:
//                               isSelected
//                                   ? theme.colorScheme.onPrimary
//                                   : theme.colorScheme.onBackground.withOpacity(
//                                     0.5,
//                                   ),
//                           backgroundColor:
//                               isSelected
//                                   ? theme.colorScheme.primary
//                                   : theme.cardColor,
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 20,
//                             vertical: 6,
//                           ),
//                           // radius: 20,
//                           size: 14,
//                         );
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 20),

//                   // Food grid
//                   Expanded(
//                     child: GridView.builder(
//                       itemCount: 6,
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 2,
//                             childAspectRatio: 3 / 4,
//                             crossAxisSpacing: 15,
//                             mainAxisSpacing: 20,
//                           ),
//                       itemBuilder: (context, index) {
//                         return Container(
//                           padding: const EdgeInsets.all(10),
//                           decoration: BoxDecoration(
//                             color: theme.cardColor,
//                             borderRadius: BorderRadius.circular(20),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.05),
//                                 blurRadius: 10,
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Image.asset(
//                                 'assets/images/humburger.png',
//                                 height: 80,
//                               ),
//                               const SizedBox(height: 10),
//                               CustomText(
//                                 text1: "pizza",
//                                 size: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: theme.colorScheme.onBackground,
//                               ),
//                               const SizedBox(height: 5),
//                               CustomText(
//                                 text1: "2.5\$",
//                                 size: 14,
//                                 color: theme.colorScheme.onBackground
//                                     .withOpacity(0.7),
//                               ),
//                               Spacer(),
//                               Align(
//                                 alignment: Alignment.bottomRight,
//                                 child: Icon(
//                                   Icons.favorite_border,
//                                   color: theme.colorScheme.primary,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // Floating Action Button
//           floatingActionButton: FloatingActionButton(
//             onPressed: () {},
//             backgroundColor: theme.colorScheme.primary,
//             child: Icon(Icons.add, color: theme.colorScheme.onPrimary),
//           ),
//         );
//       },
//     );
//   }
// }

// import 'package:almoktar/config/theme_manager.dart';
// import 'package:almoktar/cubits/theme/theme_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../components/defaultButton.dart';
// import '../../components/text.dart';

// // نموذج بيانات الطعام
// class FoodItem {
//   final String name;
//   final String image;
//   final double price;

//   FoodItem({required this.name, required this.image, required this.price});
// }

// // صفحة عرض قائمة الأطعمة ببحث وشبكة
// class FoodPage extends StatefulWidget {
//   const FoodPage({Key? key}) : super(key: key);

//   @override
//   _FoodPageState createState() => _FoodPageState();
// }

// class _FoodPageState extends State<FoodPage> {
//   final List<FoodItem> allFoods = [
//     FoodItem(
//       name: 'Classic Beef Burger',
//       image: 'assets/images/Reset password.png',
//       price: 5.99,
//     ),
//     FoodItem(
//       name: 'Cheese Burger',
//       image: 'assets/images/Reset password.png',
//       price: 6.99,
//     ),
//     FoodItem(
//       name: 'Chicken Sandwich',
//       image: 'assets/images/Reset password.png',
//       price: 4.99,
//     ),
//     FoodItem(
//       name: 'Veggie Salad',
//       image: 'assets/images/Reset password.png',
//       price: 3.99,
//     ),
//     FoodItem(
//       name: 'Fish Taco',
//       image: 'assets/images/Reset password.png',
//       price: 5.49,
//     ),
//     FoodItem(
//       name: 'Fries',
//       image: 'assets/images/Reset password.png',
//       price: 2.49,
//     ),
//   ];
//   List<FoodItem> filteredFoods = [];
//   TextEditingController searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     filteredFoods = List.from(allFoods);
//     searchController.addListener(_onSearchChanged);
//   }

//   void _onSearchChanged() {
//     final query = searchController.text.toLowerCase();
//     setState(() {
//       filteredFoods =
//           allFoods
//               .where((item) => item.name.toLowerCase().contains(query))
//               .toList()
//             ..sort((a, b) {
//               // Items starting with query come first
//               bool aStarts = a.name.toLowerCase().startsWith(query);
//               bool bStarts = b.name.toLowerCase().startsWith(query);
//               if (aStarts && !bStarts) return -1;
//               if (!aStarts && bStarts) return 1;
//               return a.name.compareTo(b.name);
//             });
//     });
//   }

//   @override
//   void dispose() {
//     searchController.removeListener(_onSearchChanged);
//     searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ThemeCubit, ThemeState>(
//       builder: (context, state) {
//         final theme = Theme.of(context);
//         return Scaffold(
//           appBar: AppBar(
//             backgroundColor: theme.scaffoldBackgroundColor,
//             elevation: 0,
//             title: TextField(
//               controller: searchController,
//               decoration: InputDecoration(
//                 hintText: 'Search food...',
//                 prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
//                 filled: true,
//                 fillColor: theme.cardColor,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//             iconTheme: theme.iconTheme,
//           ),
//           backgroundColor: theme.scaffoldBackgroundColor,
//           body: Padding(
//             padding: const EdgeInsets.all(16),
//             child: GridView.builder(
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 mainAxisSpacing: 16,
//                 crossAxisSpacing: 16,
//                 childAspectRatio: 0.75,
//               ),
//               itemCount: filteredFoods.length,
//               itemBuilder: (context, index) {
//                 final item = filteredFoods[index];
//                 return GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => FoodHamburgerPage(item: item),
//                       ),
//                     );
//                   },
//                   child: Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         ClipRRect(
//                           borderRadius: const BorderRadius.vertical(
//                             top: Radius.circular(12),
//                           ),
//                           child: Image.asset(
//                             item.image,
//                             height: 120,
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               CustomText(
//                                 text1: item.name,
//                                 size: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: theme.textTheme.titleLarge?.color,
//                               ),
//                               const SizedBox(height: 4),
//                               CustomText(
//                                 text1: '\$${item.price.toStringAsFixed(2)}',
//                                 size: 14,
//                                 color: theme.colorScheme.primary,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// // صفحة تفاصيل الهامبرغر (بلا تغيير)
// class FoodHamburgerPage extends StatelessWidget {
//   final FoodItem item;

//   const FoodHamburgerPage({Key? key, required this.item}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ThemeCubit, ThemeState>(
//       builder: (context, state) {
//         final theme = Theme.of(context);
//         return Scaffold(
//           backgroundColor: theme.scaffoldBackgroundColor,
//           appBar: AppBar(
//             backgroundColor: theme.scaffoldBackgroundColor,
//             elevation: 0,
//             leading: IconButton(
//               icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
//               onPressed: () => Navigator.of(context).pop(),
//             ),
//             title: CustomText(
//               text1: item.name,
//               size: 20,
//               fontWeight: FontWeight.bold,
//               color: theme.textTheme.titleLarge?.color,
//             ),
//           ),
//           body: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: Container(
//                       height: 240,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                         image: DecorationImage(
//                           image: AssetImage(item.image),
//                           fit: BoxFit.cover,
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 10,
//                             offset: Offset(0, 5),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Flexible(
//                         child: CustomText(
//                           text1: item.name,
//                           size: 24,
//                           fontWeight: FontWeight.bold,
//                           color: theme.textTheme.titleLarge?.color,
//                         ),
//                       ),
//                       CustomText(
//                         text1: '\$${item.price.toStringAsFixed(2)}',
//                         size: 22,
//                         fontWeight: FontWeight.bold,
//                         color: theme.colorScheme.primary,
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   CustomText(
//                     text1:
//                         'A delicious ${item.name.toLowerCase()} with fresh ingredients and our special sauce.',
//                     size: 16,
//                     color: theme.textTheme.bodyMedium?.color,
//                   ),
//                   const SizedBox(height: 20),
//                   Row(
//                     children: [
//                       CustomText(
//                         text1: 'Quantity',
//                         size: 16,
//                         fontWeight: FontWeight.w600,
//                         color: theme.textTheme.bodyMedium?.color,
//                       ),
//                       const SizedBox(width: 16),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: theme.cardColor,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Row(
//                           children: [
//                             IconButton(
//                               icon: Icon(Icons.remove),
//                               onPressed: () {},
//                             ),
//                             CustomText(
//                               text1: '1',
//                               size: 16,
//                               color: theme.textTheme.bodyMedium?.color,
//                             ),
//                             IconButton(icon: Icon(Icons.add), onPressed: () {}),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 24),
//                   DefaultButton(
//                     text: 'Add to Cart',
//                     color: theme.colorScheme.primary,
//                     textColor: theme.buttonTextColor,
//                     width: double.infinity,
//                     onTap: () {},
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:almoktar/config/theme_manager.dart';
import 'package:almoktar/cubits/theme/theme_cubit.dart';
import 'package:almoktar/screens/app/FoodHamburgerPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final List<String> categories = ['All', 'Hamburger', 'Pizza', 'salad'];
  String selectedCategory = 'All';

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
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      children:
                          categories.map((cat) {
                            final isSelected = cat == selectedCategory;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ChoiceChip(
                                label: Text(cat),
                                selected: isSelected,
                                onSelected: (_) {
                                  setState(() {
                                    selectedCategory = cat;
                                    _applyFilters();
                                  });
                                },
                                selectedColor: theme.colorScheme.primary,
                                backgroundColor: theme.cardColor,
                                labelStyle: TextStyle(
                                  color:
                                      isSelected
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
        );
      },
    );
  }
}

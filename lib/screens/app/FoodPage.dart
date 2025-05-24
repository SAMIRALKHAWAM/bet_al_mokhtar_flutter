import 'package:almoktar/components/TweenAnimation.dart';
import 'package:almoktar/screens/app/FavPage.dart';
import 'package:almoktar/screens/app/FoodHamburgerPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/cubit_app/cubit.dart';
import '../../blocs/cubit_app/statues.dart';
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
  dynamic selectedCategory = 'All';

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
    AppCubit.get(context).MealAll();
    // AppCubit.get(context).Meal();

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
    return BlocConsumer<AppCubit, AppSates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, state) {
        final theme = Theme.of(context);

        return AppCubit.get(context).cat_map != null &&
                AppCubit.get(context).mealAllModel != null
            ? Scaffold(
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
                          children: [
                            // أول عنصر "All"
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ChoiceChip(
                                label: const Text("All"),
                                selected: selectedCategory == "All",
                                onSelected: (_) {
                                  setState(() {
                                    selectedCategory = "All";
                                    AppCubit.get(context).MealAll();
                                    _applyFilters();
                                  });
                                },
                                selectedColor: theme.colorScheme.primary,
                                backgroundColor: theme.cardColor,
                                labelStyle: TextStyle(
                                  color:
                                      selectedCategory == "All"
                                          ? theme.colorScheme.onPrimary
                                          : theme.textTheme.bodyMedium?.color,
                                ),
                              ),
                            ),
                            // باقي التصنيفات من الـ API
                            ...AppCubit.get(context).cat_map!.entries
                                .where((entry) => entry.value != null)
                                .map<Widget>((entry) {
                                  final catName = entry.value;
                                  final catId = entry.key;

                                  final isSelected =
                                      catName == selectedCategory;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: ChoiceChip(
                                      label: Text(catName),
                                      selected: isSelected,
                                      onSelected: (_) {
                                        setState(() {
                                          selectedCategory = catName;
                                          AppCubit.get(context).Meal(catId);

                                          // _applyFilters();
                                          print(catId);
                                        });
                                      },
                                      selectedColor: theme.colorScheme.primary,
                                      backgroundColor: theme.cardColor,
                                      labelStyle: TextStyle(
                                        color:
                                            isSelected
                                                ? theme.colorScheme.onPrimary
                                                : theme
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.color,
                                      ),
                                    ),
                                  );
                                })
                                .toList(),
                          ],
                        ),
                      ),

                      SizedBox(height: 16),

                      item_meal(AppCubit.get(context).mealAllModel!.data, 1),
                    ],
                  ),
                ),
              ),
            )
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget item_meal(dynamic meal, dynamic cat_name) {
    final theme = Theme.of(context);

    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: meal.length,
        itemBuilder: (context, index) {
          // final item = filteredFoods[index];
          return GestureDetector(
            onTap: () {
              AppCubit.get(context).get_one_item(meal[index].id);

              Navigator.push(
                context,
                MaterialPageRoute(
                  // builder: (_) => FavoritesPage(),
                   builder: (_) => FoodHamburgerPage(item: meal[index].id),
                  //  builder: (_) => FoodHamburgerPage(item: null,),
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
                          // child: Image.asset(
                          //   item.image,
                          //   height: 100,
                          //   width: 100,
                          //   fit: BoxFit.cover,
                          // ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),

                        child: AnimatedFavoriteIcon(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text1: meal[index].name,
                          size: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.titleLarge?.color,
                          // maxLines: 2,
                        ),
                        const SizedBox(height: 4),
                        CustomText(
                          text1: '\$${meal[index].price.toStringAsFixed(2)}',
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
    );
  }
}

// //////////////////////////////////////////////////////////////////////////////////////////////

// import 'package:almoktar/components/TweenAnimation.dart';
// import 'package:almoktar/screens/app/FoodHamburgerPage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../blocs/cubit_app/cubit.dart';
// import '../../blocs/cubit_app/statues.dart';
// import '../../components/text.dart';

// String baseUrl = "http://127.0.0.1:8000/98022rr.PNG";

// class FoodPage extends StatefulWidget {
//   const FoodPage({Key? key}) : super(key: key);

//   @override
//   _FoodPageState createState() => _FoodPageState();
// }

// class _FoodPageState extends State<FoodPage> {
//   dynamic selectedCategory = 'All';
//   List<dynamic> filteredApiFoods = [];
//   TextEditingController searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     searchController.addListener(_applyFilters);

//     AppCubit.get(context).category();
//     AppCubit.get(context).MealAll();

//     Future.delayed(Duration(milliseconds: 500), () {
//       final map = AppCubit.get(context).cat_map;
//       if (map != null && map.isNotEmpty && selectedCategory == null) {
//         setState(() {
//           selectedCategory = map.entries.first.value;
//           _applyFilters();
//         });
//       }
//     });
//   }

//   void _applyFilters() {
//     final query = searchController.text.toLowerCase();

//     final sourceList =
//         selectedCategory == 'All'
//             ? AppCubit.get(context).mealAllModel?.data
//             : AppCubit.get(context).mealModel?.data;

//     if (sourceList != null) {
//       setState(() {
//         filteredApiFoods =
//             sourceList.where((item) {
//                 return item.name.toLowerCase().contains(query);
//               }).toList()
//               ..sort((a, b) {
//                 final aStarts = a.name.toLowerCase().startsWith(query);
//                 final bStarts = b.name.toLowerCase().startsWith(query);
//                 if (aStarts && !bStarts) return -1;
//                 if (!aStarts && bStarts) return 1;
//                 return a.name.compareTo(b.name);
//               });
//       });
//     }
//   }

//   @override
//   void dispose() {
//     searchController.removeListener(_applyFilters);
//     searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<AppCubit, AppSates>(
//       listener: (context, state) {},
//       builder: (context, state) {
//         final theme = Theme.of(context);
//         final cubit = AppCubit.get(context);

//         final isAll = selectedCategory == 'All';
//         final mealData =
//             isAll ? cubit.mealAllModel?.data : cubit.mealModel?.data;

//         final dataToDisplay =
//             searchController.text.isEmpty ? mealData : filteredApiFoods;

//         return cubit.cat_map != null && mealData != null
//             ? Scaffold(
//               backgroundColor: theme.scaffoldBackgroundColor,
//               body: SafeArea(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       CustomText(
//                         text1: 'Food Menu',
//                         size: 28,
//                         fontWeight: FontWeight.bold,
//                         color: theme.textTheme.titleLarge?.color,
//                       ),
//                       const SizedBox(height: 8),
//                       TextField(
//                         controller: searchController,
//                         decoration: InputDecoration(
//                           hintText: 'Search food...',
//                           prefixIcon: Icon(
//                             Icons.search,
//                             color: theme.iconTheme.color,
//                           ),
//                           filled: true,
//                           fillColor: theme.cardColor,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide.none,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),

//                       // ChoiceChips
//                       SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: Row(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.only(right: 8.0),
//                               child: ChoiceChip(
//                                 label: const Text("All"),
//                                 selected: selectedCategory == "All",
//                                 onSelected: (_) {
//                                   setState(() {
//                                     selectedCategory = "All";
//                                     cubit.MealAll();
//                                     _applyFilters();
//                                   });
//                                 },
//                                 selectedColor: theme.colorScheme.primary,
//                                 backgroundColor: theme.cardColor,
//                                 labelStyle: TextStyle(
//                                   color:
//                                       selectedCategory == "All"
//                                           ? theme.colorScheme.onPrimary
//                                           : theme.textTheme.bodyMedium?.color,
//                                 ),
//                               ),
//                             ),
//                             ...cubit.cat_map!.entries
//                                 .where((entry) => entry.value != null)
//                                 .map((entry) {
//                                   final catName = entry.value;
//                                   final catId = entry.key;
//                                   final isSelected =
//                                       selectedCategory == catName;

//                                   return Padding(
//                                     padding: const EdgeInsets.only(right: 8.0),
//                                     child: ChoiceChip(
//                                       label: Text(catName),
//                                       selected: isSelected,
//                                       onSelected: (_) {
//                                         setState(() {
//                                           selectedCategory = catName;
//                                           cubit.Meal(catId);
//                                           _applyFilters();
//                                         });
//                                       },
//                                       selectedColor: theme.colorScheme.primary,
//                                       backgroundColor: theme.cardColor,
//                                       labelStyle: TextStyle(
//                                         color:
//                                             isSelected
//                                                 ? theme.colorScheme.onPrimary
//                                                 : theme
//                                                     .textTheme
//                                                     .bodyMedium
//                                                     ?.color,
//                                       ),
//                                     ),
//                                   );
//                                 })
//                                 .toList(),
//                           ],
//                         ),
//                       ),

//                       const SizedBox(height: 16),

//                       item_meal(dataToDisplay ?? []),
//                     ],
//                   ),
//                 ),
//               ),
//             )
//             : const Center(child: CircularProgressIndicator());
//       },
//     );
//   }

//   Widget item_meal(List<dynamic> meal) {
//     final theme = Theme.of(context);

//     return Expanded(
//       child: GridView.builder(
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           mainAxisSpacing: 16,
//           crossAxisSpacing: 16,
//           childAspectRatio: 0.75,
//         ),
//         itemCount: meal.length,
//         itemBuilder: (context, index) {
//           final item = meal[index];

//           return GestureDetector(
//             onTap: () {
//               AppCubit.get(context).get_one_item(item.id);
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => FoodHamburgerPage(item: item),
//                 ),
//               );
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                 color: theme.cardColor,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 4,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const SizedBox(height: 8),
//                   Stack(
//                     alignment: Alignment.topRight,
//                     children: [
//                       Center(
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(50),
//                           child:Image.network(
//   item.itemImages.isNotEmpty && item.itemImages.first.image.isNotEmpty
//     ? '${baseUrl}/${item.itemImages.first.image}'
//     : '${baseUrl}/default.png',
//   height: 100,
//   width: 100,
//   fit: BoxFit.cover,
//   errorBuilder: (context, error, stackTrace) {
//     return Icon(Icons.error, size: 50);  // عرض أيقونة خطأ إذا لم يتم تحميل الصورة
//   },
// ),
//                         ),
//                       ),
//                       const Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: AnimatedFavoriteIcon(),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CustomText(
//                           text1: item.name,
//                           size: 16,
//                           fontWeight: FontWeight.bold,
//                           color: theme.textTheme.titleLarge?.color,
//                         ),
//                         const SizedBox(height: 4),
//                         CustomText(
//                           text1: '\$${item.price.toStringAsFixed(2)}',
//                           size: 14,
//                           color: theme.colorScheme.primary,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }














///////////////////////////////////////////////////////////////////////
////هذا   استخدم 
///
// import 'package:almoktar/components/TweenAnimation.dart';
// import 'package:almoktar/screens/app/FoodHamburgerPage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../blocs/cubit_app/cubit.dart';
// import '../../blocs/cubit_app/statues.dart';
// import '../../components/text.dart';

// String baseUrl = "http://127.0.0.1:8000/98022rr.PNG";

// class FoodPage extends StatefulWidget {
//   const FoodPage({Key? key}) : super(key: key);

//   @override
//   _FoodPageState createState() => _FoodPageState();
// }

// class _FoodPageState extends State<FoodPage> {
//   String selectedCategory = 'All'; // نوعه String لأنه "All" نصي
//   List<dynamic> filteredApiFoods = [];
//   TextEditingController searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();

//     // استماع لتغير نص البحث وتحديث الفلترة مباشرة
//     searchController.addListener(_applyFilters);

//     // جلب التصنيفات والوجبات الكاملة
//     final cubit = AppCubit.get(context);
//     cubit.category();
//     cubit.MealAll();

//     // بعد تحميل التصنيفات، تعيين "All" كافتراضي وتطبيق الفلترة
//     Future.delayed(const Duration(milliseconds: 500), () {
//       if (cubit.cat_map != null && cubit.cat_map!.isNotEmpty) {
//         setState(() {
//           selectedCategory = 'All';
//         });
//         _applyFilters();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     searchController.removeListener(_applyFilters);
//     searchController.dispose();
//     super.dispose();
//   }

//   // تطبيق الفلترة بناءً على البحث والتصنيف المحدد
//   void _applyFilters() {
//     final query = searchController.text.toLowerCase();

//     final cubit = AppCubit.get(context);
//     final isAll = selectedCategory == 'All';

//     // اختر قائمة الوجبات المناسبة
//     final sourceList = isAll ? cubit.mealAllModel?.data : cubit.mealModel?.data;

//     if (sourceList != null) {
//       setState(() {
//         filteredApiFoods =
//             sourceList.where((item) {
//                 return item.name.toLowerCase().contains(query);
//               }).toList()
//               ..sort((a, b) {
//                 final aStarts = a.name.toLowerCase().startsWith(query);
//                 final bStarts = b.name.toLowerCase().startsWith(query);
//                 if (aStarts && !bStarts) return -1;
//                 if (!aStarts && bStarts) return 1;
//                 return a.name.compareTo(b.name);
//               });
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<AppCubit, AppSates>(
//       listener: (context, state) {
//         // عند انتهاء تحميل الوجبات سواء للكل أو لتصنيف معين
//         if (state is MealSuccessState || state is categorySuccessState) {
//           _applyFilters();
//         }
//       },
//       builder: (context, state) {
//         final theme = Theme.of(context);
//         final cubit = AppCubit.get(context);

//         final isAll = selectedCategory == 'All';

//         // اختر بيانات الوجبات لعرضها، بناءً على حالة البحث والفلترة
//         final mealData =
//             isAll ? cubit.mealAllModel?.data : cubit.mealModel?.data;
//         final dataToDisplay =
//             searchController.text.isEmpty ? mealData : filteredApiFoods;

//         // إذا بيانات التصنيفات والوجبات جاهزة
//         if (cubit.cat_map != null && mealData != null) {
//           return Scaffold(
//             backgroundColor: theme.scaffoldBackgroundColor,
//             body: SafeArea(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CustomText(
//                       text1: 'Food Menu',
//                       size: 28,
//                       fontWeight: FontWeight.bold,
//                       color: theme.textTheme.titleLarge?.color,
//                     ),
//                     const SizedBox(height: 8),
//                     TextField(
//                       controller: searchController,
//                       decoration: InputDecoration(
//                         hintText: 'Search food...',
//                         prefixIcon: Icon(
//                           Icons.search,
//                           color: theme.iconTheme.color,
//                         ),
//                         filled: true,
//                         fillColor: theme.cardColor,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),

//                     // ChoiceChips للتصنيفات مع دعم اختيار التصنيف وتحميل بياناته
//                     SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(right: 8.0),
//                             child: ChoiceChip(
//                               label: const Text("All"),
//                               selected: selectedCategory == "All",
//                               onSelected: (_) async {
//                                 setState(() {
//                                   selectedCategory = "All";
//                                 });
//                                 cubit.MealAll(); // تحميل كل الوجبات
//                                  _applyFilters();
//                               },
//                               selectedColor: theme.colorScheme.primary,
//                               backgroundColor: theme.cardColor,
//                               labelStyle: TextStyle(
//                                 color:
//                                     selectedCategory == "All"
//                                         ? theme.colorScheme.onPrimary
//                                         : theme.textTheme.bodyMedium?.color,
//                               ),
//                             ),
//                           ),
//                           ...cubit.cat_map!.entries
//                               .where((entry) => entry.value != null)
//                               .map((entry) {
//                                 final catName = entry.value;
//                                 final catId = entry.key;
//                                 final isSelected = selectedCategory == catName;

//                                 return Padding(
//                                   padding: const EdgeInsets.only(right: 8.0),
//                                   child: ChoiceChip(
//                                     label: Text(catName),
//                                     selected: isSelected,
//                                     onSelected: (_) {
//                                       setState(() {
//                                         selectedCategory = catName;
//                                       });
//                                       cubit.Meal(
//                                         catId,
//                                       ); // تحميل وجبات التصنيف المحدد
//                                        _applyFilters();
//                                     },
//                                     selectedColor: theme.colorScheme.primary,
//                                     backgroundColor: theme.cardColor,
//                                     labelStyle: TextStyle(
//                                       color:
//                                           isSelected
//                                               ? theme.colorScheme.onPrimary
//                                               : theme
//                                                   .textTheme
//                                                   .bodyMedium
//                                                   ?.color,
//                                     ),
//                                   ),
//                                 );
//                               })
//                               .toList(),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 16),

//                     // عرض عناصر الوجبات
//                     item_meal(dataToDisplay ?? []),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         } else {
//           return const Center(child: CircularProgressIndicator());
//         }
//       },
//     );
//   }

//   Widget item_meal(List<dynamic> meal) {
//     final theme = Theme.of(context);

//     return Expanded(
//       child: GridView.builder(
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           mainAxisSpacing: 16,
//           crossAxisSpacing: 16,
//           childAspectRatio: 0.75,
//         ),
//         itemCount: meal.length,
//         itemBuilder: (context, index) {
//           final item = meal[index];

//           return GestureDetector(
//             onTap: () {
//               AppCubit.get(context).get_one_item(item.id);
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => FoodHamburgerPage(item: item),
//                 ),
//               );
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                 color: theme.cardColor,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: const [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 4,
//                     offset: Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const SizedBox(height: 8),
//                   Stack(
//                     alignment: Alignment.topRight,
//                     children: [
//                       Center(
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(50),
//                           child: Image.network(
//                             item.itemImages.isNotEmpty &&
//                                     item.itemImages.first.image.isNotEmpty
//                                 ? '$baseUrl/${item.itemImages.first.image}'
//                                 : '$baseUrl/default.png',
//                             height: 100,
//                             width: 100,
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) {
//                               return const Icon(Icons.error, size: 50);
//                             },
//                           ),
//                         ),
//                       ),
//                       const Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: AnimatedFavoriteIcon(),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CustomText(
//                           text1: item.name,
//                           size: 16,
//                           fontWeight: FontWeight.bold,
//                           color: theme.textTheme.titleLarge?.color,
//                         ),
//                         const SizedBox(height: 4),
//                         CustomText(
//                           text1: '\$${item.price.toStringAsFixed(2)}',
//                           size: 14,
//                           color: theme.colorScheme.primary,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

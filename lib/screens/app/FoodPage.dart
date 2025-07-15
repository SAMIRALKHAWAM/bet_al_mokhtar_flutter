import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/cubit_app/cubit.dart';
import '../../blocs/cubit_app/statues.dart';
import '../../components/text.dart';
import 'FoodHamburgerPage.dart';
import 'offer_pages.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({Key? key}) : super(key: key);

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  String selectedCategory = 'All';
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    AppCubit.get(context).category();
    AppCubit.get(context).MealAll();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocConsumer<AppCubit, AppSates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = AppCubit.get(context);

        if (cubit.cat_map == null || cubit.mealAllModel == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final meals = cubit.mealAllModel!.data;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text1: 'Food Menu',
                        size: 28,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.titleLarge?.color,
                      ),
                      IconButton(
                        icon: Image.asset(
                          'assets/images/offer.png',
                          width: 28,
                          height: 28,
                        ),
                        onPressed: () {
                          cubit.OfferAll();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => OffersPage()),
                          );
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Search
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search food...',
                      prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
                      filled: true,
                      fillColor: theme.cardColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Categories
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCategoryChip(context, 'All', selectedCategory == 'All', () {
                          setState(() {
                            selectedCategory = 'All';
                            cubit.MealAll();
                          });
                        }),
                        ...cubit.cat_map!.entries.map((entry) {
                          return _buildCategoryChip(
                            context,
                            entry.value,
                            selectedCategory == entry.value,
                                () {
                              setState(() {
                                selectedCategory = entry.value;
                                cubit.Meal(entry.key);
                              });
                            },
                          );
                        }).toList(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Meals Grid
                  Expanded(
                    child: GridView.builder(
                      itemCount: meals.length,
                      padding: EdgeInsets.zero,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.68,
                      ),
                      itemBuilder: (context, index) {
                        final meal = meals[index];
                        final imageUrl = meal.itemImages.isNotEmpty
                            ? 'http://${meal.itemImages.first.image}'
                            : null;

                        return GestureDetector(
                          onTap: () {
                            cubit.get_one_item(meal.id);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FoodHamburgerPage(itemId: meal.id),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // الصورة
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                  child: imageUrl != null
                                      ? Image.network(
                                    imageUrl,
                                    height: 120,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image, size: 60),
                                  )
                                      : Container(
                                    height: 120,
                                    width: double.infinity,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.fastfood, size: 60),
                                  ),
                                ),

                                // الاسم + السعر + زر المفضلة (ريسبونسف)
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        meal.name,
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04, // نسبي
                                          fontWeight: FontWeight.bold,
                                          color: theme.textTheme.titleLarge?.color,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              '\$${meal.price.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontSize: screenWidth * 0.035, // نسبي
                                                color: theme.colorScheme.primary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.favorite_border),
                                            color: theme.colorScheme.primary,
                                            iconSize: 20,
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            onPressed: () {
                                              // Add to favorites logic here
                                            },
                                          ),
                                        ],
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

  Widget _buildCategoryChip(
      BuildContext context, String label, bool selected, VoidCallback onTap) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: theme.colorScheme.primary,
        backgroundColor: theme.cardColor,
        labelStyle: TextStyle(
          color:
          selected ? theme.colorScheme.onPrimary : theme.textTheme.bodyMedium?.color,
        ),
      ),
    );
  }
}

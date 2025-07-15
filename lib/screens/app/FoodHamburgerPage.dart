import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../blocs/cubit_app/cubit.dart';
import '../../blocs/cubit_app/statues.dart';
import '../../components/defaultButton.dart';
import '../../components/text.dart';
import '../../models/get_one_itemModel.dart';

String getFullImageUrl(String? path) {
  if (path == null || path.isEmpty) {
    return 'https://via.placeholder.com/150';
  }

  if (path.startsWith('http')) {
    return path;
  }

  const String baseUrl = "http://"; // ضع رابط السيرفر هنا
  return "$baseUrl$path";
}

class FoodHamburgerPage extends StatefulWidget {
  final dynamic itemId;

  const FoodHamburgerPage({Key? key, required this.itemId}) : super(key: key);

  @override
  State<FoodHamburgerPage> createState() => _FoodHamburgerPageState();
}

class _FoodHamburgerPageState extends State<FoodHamburgerPage> {
  int count = 1;
  int currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppCubit.get(context).get_one_item(widget.itemId);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<AppCubit, AppSates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = AppCubit.get(context);

        if (cubit.get_one_item_model == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final Data meal = cubit.get_one_item_model!.data;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: CustomText(
              text1: meal.name,
              size: 20,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.titleLarge?.color,
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // سلايدر الصور
                Column(
                  children: [
                    SizedBox(
                      height: 240,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: meal.itemImages.length,
                        onPageChanged: (index) {
                          setState(() {
                            currentPage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          final imageUrl =
                          getFullImageUrl(meal.itemImages[index].image);
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: meal.itemImages.length,
                        effect: WormEffect(
                          activeDotColor: theme.colorScheme.primary,
                          dotColor: Colors.grey.shade300,
                          dotHeight: 10,
                          dotWidth: 10,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // الاسم والسعر
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: CustomText(
                        text1: meal.name,
                        size: 24,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.titleLarge?.color,
                      ),
                    ),
                    CustomText(
                      text1: '\$${meal.price.toStringAsFixed(2)}',
                      size: 22,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // الوصف
                CustomText(
                  text1:
                  'Delicious ${meal.name.toLowerCase()} made with fresh ingredients and our special sauce.',
                  size: 16,
                  color: theme.textTheme.bodyMedium?.color,
                ),

                const SizedBox(height: 20),

                // الكمية
                Row(
                  children: [
                    CustomText(
                      text1: 'Quantity',
                      size: 16,
                      fontWeight: FontWeight.w600,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                    const SizedBox(width: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                if (count > 1) count--;
                              });
                            },
                          ),
                          CustomText(
                            text1: count.toString(),
                            size: 16,
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                count++;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // زر الإضافة للسلة
                DefaultButton(
                  text: 'Add to Cart',
                  color: theme.colorScheme.primary,
                  textColor: theme.colorScheme.onPrimary,
                  width: double.infinity,
                  onTap: () {
                    final meal = cubit.get_one_item_model!.data;

                    AppCubit.get(context).addItemToOrder(
                      id: meal.id,
                      name: meal.name,
                      quantity: count,
                      price: meal.price,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تمت الإضافة بنجاح')),
                    );
                  },

                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

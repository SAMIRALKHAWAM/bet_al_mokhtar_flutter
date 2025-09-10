import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/cubit_app/cubit.dart';
import '../../blocs/cubit_app/statues.dart';
import '../../components/text.dart';
import 'FoodDetailsPage.dart';
import 'SearchPage.dart';
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
    AppCubit.get(context).OfferAll();
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
        final offers = cubit.Offer_response?.data;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomText(
                          text1: 'food_menu'.tr(),
                          size: 35,
                          fontWeight: FontWeight.bold,
                          color: theme.textTheme.titleLarge?.color,
                          font: "title",
                        ),
                      ),
                      IconButton(
                        icon: Image.asset(
                          'assets/images/offer.png',
                          width: 35,
                          height: 35,
                        ),
                        onPressed: () {
                          AppCubit.get(context).OfferAll();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OffersPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (offers != null && offers.isNotEmpty)
                    OfferSlider(offers: offers),

                  // TextField(
                  //   controller: searchController,
                  //   decoration: InputDecoration(
                  //     hintText: 'search_hint'.tr(),
                  //     prefixIcon: Icon(
                  //       Icons.search,
                  //       color: theme.iconTheme.color,
                  //     ),
                  //     suffixIcon: searchController.text.isNotEmpty
                  //         ? IconButton(
                  //       icon: Icon(
                  //         Icons.clear,
                  //         color: theme.iconTheme.color,
                  //       ),
                  //       onPressed: () => searchController.clear(),
                  //     )
                  //         : null,
                  //     filled: true,
                  //     fillColor: theme.cardColor,
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(12),
                  //       borderSide: BorderSide.none,
                  //     ),
                  //   ),
                  //   onChanged: (value) {
                  //     setState(() {});
                  //   },
                  // ),


                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SearchPage()),
                      );
                    },
                    child: AbsorbPointer( // يمنع المستخدم من الكتابة هون
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'search_hint'.tr(),
                          prefixIcon: Icon(Icons.search),
                          filled: true,
                          fillColor: theme.cardColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCategoryChip(
                          context,
                          'all'.tr(),
                          selectedCategory == 'All',
                              () {
                            setState(() {
                              selectedCategory = 'All';
                              cubit.MealAll();
                            });
                          },
                        ),
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

                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints.maxWidth;
                        const crossAxisCount = 2;
                        const spacing = 12.0;
                        final totalSpacing = spacing * (crossAxisCount - 1);
                        final itemWidth = (width - totalSpacing) / crossAxisCount;
                        final itemHeight = itemWidth / 0.85;

                        return GridView.builder(
                          itemCount: meals.length,
                          padding: EdgeInsets.zero,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: spacing,
                            crossAxisSpacing: spacing,
                            childAspectRatio: itemWidth / itemHeight,
                          ),
                          itemBuilder: (context, index) {
                            final meal = meals[index];
                            final imageUrl = meal.itemImages.isNotEmpty
                                ? meal.itemImages.first.image
                                : null;

                            return GestureDetector(
                              onTap: () {
                                cubit.get_one_item(meal.id);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        FoodHamburgerPage(itemId: meal.id),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: theme.cardColor,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 5,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(14),
                                        topRight: Radius.circular(14),
                                      ),
                                      child: imageUrl != null
                                          ? Image.network(
                                        imageUrl,
                                        height: itemHeight * 0.5,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, _) =>
                                        const Icon(Icons.broken_image, size: 60),
                                      )
                                          : Container(
                                        height: itemHeight * 0.5,
                                        width: double.infinity,
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.fastfood,
                                          size: 60,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 5.0),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              meal.name,
                                              style: TextStyle(
                                                fontSize: width * 0.045,
                                                fontWeight: FontWeight.w600,
                                                color: theme.textTheme.titleLarge?.color,
                                                height: 1.2,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const Spacer(),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  '${meal.price.toStringAsFixed(2)} ل.س',
                                                  style: TextStyle(
                                                    fontSize: width * 0.035,
                                                    color: theme.colorScheme.primary,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    meal.like ? Icons.favorite : Icons.favorite_border,
                                                    color: meal.like ? Colors.red : theme.colorScheme.primary,
                                                  ),
                                                  iconSize: 20,
                                                  padding: EdgeInsets.zero,
                                                  constraints: const BoxConstraints(),
                                                  onPressed: () {
                                                    // أولاً: نحدث الواجهة فوراً
                                                    setState(() {
                                                      meal.like = !meal.like;
                                                    });

                                                    // ثانياً: نرسل الطلب إلى السيرفر
                                                    AppCubit.get(context).Like_UnLike(id_item: meal.id);
                                                  },
                                                ),

                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
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
      BuildContext context,
      String label,
      bool selected,
      VoidCallback onTap,
      ) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(right: 6.0),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            fontSize: width * 0.035, // أكبر من السابق
            color: selected
                ? theme.colorScheme.onPrimary
                : theme.textTheme.bodyMedium?.color,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: theme.colorScheme.primary,
        backgroundColor: theme.cardColor,
        elevation: selected ? 3 : 0,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), // أكبر شوي
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

}

class OfferSlider extends StatefulWidget {
  final List offers;
  const OfferSlider({Key? key, required this.offers}) : super(key: key);

  @override
  State<OfferSlider> createState() => _OfferSliderState();
}

class _OfferSliderState extends State<OfferSlider> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.offers.length > 1) {
        _timer = Timer.periodic(const Duration(seconds: 4), (_) {
          if (!mounted) return;
          _currentPage = (_currentPage + 1) % widget.offers.length;
          if (_controller.hasClients) {
            _controller.animateToPage(
              _currentPage,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        SizedBox(
          height: width * 0.3, // حجم أصغر
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.offers.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final offer = widget.offers[index];
              final offerName = offer.name ?? '';
              final rawImage = offer.offerItems.isNotEmpty &&
                  offer.offerItems.first.item.itemImages.isNotEmpty
                  ? offer.offerItems.first.item.itemImages.first.image
                  : null;
              final imageUrl = (rawImage != null)
                  ? (rawImage.startsWith('http') ? rawImage : 'http://$rawImage')
                  : null;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      imageUrl != null
                          ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image),
                      )
                          : Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, size: 60),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.6),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            offerName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: const [
                                Shadow(
                                  color: Colors.black45,
                                  blurRadius: 4,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.offers.length,
                (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentPage == index ? 10 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? theme.colorScheme.primary
                    : Colors.grey,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

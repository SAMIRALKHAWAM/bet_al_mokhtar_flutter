import 'package:almoktar/blocs/cubit_app/cubit.dart';
import 'package:almoktar/blocs/cubit_app/statues.dart';
import 'package:almoktar/components/defaultButton.dart';
import 'package:almoktar/components/text.dart';
import 'package:almoktar/config/theme_manager.dart';
import 'package:almoktar/cubits/theme/theme_cubit.dart';
import 'package:almoktar/screens/app/FoodPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodHamburgerPage extends StatefulWidget {
  final FoodItem item;

  FoodHamburgerPage({Key? key, required this.item}) : super(key: key);

  @override
  State<FoodHamburgerPage> createState() => _FoodHamburgerPageState();
}

class _FoodHamburgerPageState extends State<FoodHamburgerPage> {
  int count = 1;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppSates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, state) {
        final theme = Theme.of(context);
        dynamic data = AppCubit.get(context);
        return AppCubit.get(context).get_one_item_model != null
            ? Scaffold(
              backgroundColor: theme.scaffoldBackgroundColor,
              appBar: AppBar(
                backgroundColor: theme.scaffoldBackgroundColor,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: CustomText(
                  text1: data.get_one_item_model!.data.name,
                  size: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.titleLarge?.color,
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          height: 240,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image: AssetImage(widget.item.image),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: CustomText(
                              text1: data.get_one_item_model!.data.name,

                              size: 24,
                              fontWeight: FontWeight.bold,
                              color: theme.textTheme.titleLarge?.color,
                            ),
                          ),
                          CustomText(
                            text1:
                                '\$${data.get_one_item_model!.data.price.toStringAsFixed(2)}',
                            size: 22,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      CustomText(
                        text1: "",
                        // 'A delicious ${data.get_one_item_model!.data.name.toLowerCase()} with fresh ingredients and our special sauce.',
                        size: 16,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                      const SizedBox(height: 20),
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
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    setState(() {
                                      if (count > 1) {
                                        count = count - 1;
                                      }
                                    });
                                  },
                                ),
                                CustomText(
                                  text1: "$count",
                                  size: 16,
                                  color: theme.textTheme.bodyMedium?.color,
                                ),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    setState(() {
                                      count = count + 1;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      DefaultButton(
                        text: 'Add to Cart',
                        color: theme.colorScheme.primary,
                        textColor: theme.buttonTextColor,
                        width: double.infinity,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
            )
            : Center(child: CircularProgressIndicator());
      },
    );
  }
}

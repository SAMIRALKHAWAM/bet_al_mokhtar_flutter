import 'package:almoktar/blocs/cubit_app/cubit.dart';
import 'package:almoktar/blocs/cubit_app/statues.dart';
import 'package:almoktar/components/TweenAnimation.dart';
import 'package:almoktar/screens/app/FoodDetailsPage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// class FavoritePage extends StatelessWidget {
//   const FavoritePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final cubit = AppCubit.get(context);

//     return Scaffold(
//       appBar: AppBar(title: const Text("المفضلة")),
//       body: BlocBuilder<AppCubit, AppSates>(
//         builder: (context, state) {
//           final items = cubit.favoriteItems;
//           if (items.isEmpty) {
//             return const Center(child: Text("لا توجد عناصر مفضلة"));
//           }
//           return ListView.builder(
//             itemCount: items.length,
//             itemBuilder: (context, index) {
//               final item = items[index];
//               return ListTile(
//                 leading: Image.network(item.image ?? ""),
//                 title: Text(item.name ?? ""),
//                 trailing: AnimatedFavoriteIcon(),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }


// ✅ 4. صفحة المفضلة FavoritesPage (جديدة)
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = AppCubit.get(context).favoriteMeals;
    return Scaffold(
      appBar: AppBar(title: Text('Favorites')),
      body: favorites.isEmpty
          ? Center(child: Text('No favorites yet.'))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final meal = favorites[index];
                return ListTile(
                  // leading: Image.asset(meal.image, width: 50, height: 50),
                  title: Text(meal.name),
                  subtitle: Text('\$${meal.price.toStringAsFixed(2)}'),
                  trailing: AnimatedFavoriteIcon(),
                  onTap: () {
                    // AppCubit.get(context).get_one_item(meal.id);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (_) => FoodHamburgerPage(item: meal),
                    //   ),
                    // );
                  },
                );
              },
            ),
    );
  }
}

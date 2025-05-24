import 'package:flutter/material.dart';

class AnimatedFavoriteIcon extends StatefulWidget {
  const AnimatedFavoriteIcon({super.key});

  @override
  State<AnimatedFavoriteIcon> createState() => _AnimatedFavoriteIconState();
}

class _AnimatedFavoriteIconState extends State<AnimatedFavoriteIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation color;
  late Animation size;
  late Animation wid;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    color = ColorTween(begin: Colors.grey, end: Colors.red).animate(controller);
    wid = Tween(begin: 2.0, end: 3.1).animate(controller);
    size = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 2.0, end: 3.0), weight: 4),
      // TweenSequenceItem(tween: Tween(begin: 4.0, end: 3.0), weight: 1),
      // TweenSequenceItem(tween: Tween(begin: 3.0, end: 4.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 3.0, end: 2.5), weight: 4),
    ]).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return IconButton(
          onPressed: () {
            if (controller.isCompleted || controller.isAnimating) {
              controller.reverse();
            } else {
              controller.forward();
            }
          },
          icon: Icon(
            Icons.favorite,
            color: color.value,
            size: size.value * 10, // ضبط الحجم حسب الحاجة
          ),
        );
      },
    );
  }
}



// import 'package:almoktar/blocs/cubit_app/cubit.dart';
// import 'package:almoktar/blocs/cubit_app/statues.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../models/category_models.dart';

// class AnimatedFavoriteIcon extends StatefulWidget {
//   final Datum item;

//   const AnimatedFavoriteIcon({Key? key, required this.item}) : super(key: key);

//   @override
//   State<AnimatedFavoriteIcon> createState() => _AnimatedFavoriteIconState();
// }

// class _AnimatedFavoriteIconState extends State<AnimatedFavoriteIcon>
//     with SingleTickerProviderStateMixin {
//   late AnimationController controller;
//   late Animation<Color?> color;
//   late Animation<double> size;

//   @override
//   void initState() {
//     super.initState();

//     controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );

//     color = ColorTween(begin: Colors.grey, end: Colors.red).animate(controller);
//     size = TweenSequence([
//       TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 1),
//       TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 1),
//     ]).animate(controller);
//   }

//   void _animate(bool isFavorite) {
//     if (isFavorite) {
//       controller.forward();
//     } else {
//       controller.reverse();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AppCubit, AppSates>(
//       builder: (context, state) {
//         final cubit = AppCubit.get(context);
//         final isFav = cubit.isFavorite(widget.item.id);

//         // تأكد من أن الأنيميشن يعكس الحالة الحالية
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           _animate(isFav);
//         });

//         return AnimatedBuilder(
//           animation: controller,
//           builder: (context, _) {
//             return IconButton(
//               onPressed: () {
//                 cubit.toggleFavorite(widget.item);
//               },
//               icon: Icon(
//                 isFav ? Icons.favorite : Icons.favorite_border,
//                 color: color.value,
//                 size: 24 * size.value,
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
// }
